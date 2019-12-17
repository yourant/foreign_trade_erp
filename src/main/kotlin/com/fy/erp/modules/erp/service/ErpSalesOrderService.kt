package com.fy.erp.modules.erp.service;

import com.fy.erp.common.persistence.Page
import com.fy.erp.common.service.CrudService
import com.fy.erp.common.service.enu.NextOperation
import com.fy.erp.modules.act.entity.Act
import com.fy.erp.modules.act.service.ActTaskService
import com.fy.erp.modules.act.utils.ActUtils.PD_SALES_ORDER
import com.fy.erp.modules.erp.dao.ErpPayTypeDao
import com.fy.erp.modules.erp.dao.ErpProductionOrderDao
import com.fy.erp.modules.erp.dao.ErpSalesOrderDao
import com.fy.erp.modules.erp.entity.*
import com.fy.erp.modules.erp.entity.SalesOrderTaskID.*
import com.fy.erp.modules.sys.utils.UserUtils
import org.apache.commons.lang3.StringUtils.isBlank
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Propagation
import org.springframework.transaction.annotation.Transactional

/**
 * 销售订单Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpSalesOrderService : CrudService<ErpSalesOrderDao, ErpSalesOrder>() {

    @Autowired
    lateinit var actTaskService: ActTaskService

    @Autowired
    lateinit var erpPayTypeService: ErpPayTypeService
    @Autowired
    lateinit var erpProductionOrderService: ErpProductionOrderService

    @Autowired
    lateinit var erpPayTypeDao: ErpPayTypeDao
    @Autowired
    lateinit var erpProductionOrderDao: ErpProductionOrderDao

    @Autowired
    lateinit var erpShipmentsService: ErpShipmentsService


    override fun get(id: String): ErpSalesOrder {
        val erpSalesOrder = super.get(id)

        erpSalesOrder.erpPayTypeList = erpPayTypeDao.findList(ErpPayType(erpSalesOrder))
        erpSalesOrder.erpPayTypeList.forEach { child ->
            child.erpPayMoneyList = erpPayTypeService.get(child.id).erpPayMoneyList
            if (child.erpPayMoneyList.isNotEmpty()) {
                child.totalPrice = child.erpPayMoneyList.map { it.comeMoney }.sumByDouble { it!! }
            }

        }

        erpSalesOrder.erpProductionOrderList = erpProductionOrderDao.findList(ErpProductionOrder(erpSalesOrder))
        erpSalesOrder.erpProductionOrderList.forEach { child ->
            child.erpProductionItemsList = erpProductionOrderService.get(child.id).erpProductionItemsList
        }

        return erpSalesOrder
    }

    override fun findList(erpSalesOrder: ErpSalesOrder): List<ErpSalesOrder> {
        return super.findList(erpSalesOrder)
    }

    // ========================================================================================

    override fun findPage(page: Page<ErpSalesOrder>, erpSalesOrder: ErpSalesOrder): Page<ErpSalesOrder> {

        val roleEnNames = UserUtils.getAllRoleEnNames()
        // 角色是ywy和jl的数据过滤 配置数据范围
        if (roleEnNames.contains("ywy") || roleEnNames.contains("jl")) {
            erpSalesOrder.sqlMap["dsf"] = dataScopeFilter(UserUtils.getUser(), "o3", "u3")
        } else if (roleEnNames.contains("czy") || roleEnNames.contains("cj")) {//根据工作流API查询对应的数据

            erpSalesOrder.sqlMap["assignee"] = UserUtils.getUser().loginName
        }

        return super.findPage(page, erpSalesOrder)
    }

    @Transactional(readOnly = false)
    override fun save(erpSalesOrder: ErpSalesOrder): Int {
        return super.save(erpSalesOrder) +
                erpSalesOrder.erpPayTypeList.map { child ->
                    when (getNextOperation(child)!!) {
                        NextOperation.INSERT -> { // 插入的情况
                            child.erpSalesOrder = erpSalesOrder
                            erpPayTypeService.save(child)
                        }
                        NextOperation.UPDATE -> {  // 更新的情况
                            erpPayTypeService.save(child)
                        }
                        NextOperation.DELETE -> { //删除的情况
                            erpPayTypeService.deleteAll(child)
                        }
                    }
                }.sumBy { it } +
                erpSalesOrder.erpProductionOrderList.map { child ->
                    when (getNextOperation(child)!!) {
                        NextOperation.INSERT -> { // 插入的情况
                            child.erpSalesOrder = erpSalesOrder
                            erpProductionOrderService.save(child)
                        }
                        NextOperation.UPDATE -> {  // 更新的情况
                            erpProductionOrderService.save(child)
                        }
                        NextOperation.DELETE -> { //删除的情况
                            erpProductionOrderService.deleteAll(child)
                        }
                    }
                }.sumBy { it }
    }

    /**
     * TODO 待测试，如测试失败，可以系统提供的删除方法：复制流程实例id到"运行中的流程"，搜索，后删除
     */

    @Transactional(readOnly = false,propagation = Propagation.NEVER)
    override fun delete(erpSalesOrder: ErpSalesOrder): Int {
//        彻底删除销售订单前，先工作流信息清楚

        try {
            actTaskService.taskService.addComment(erpSalesOrder.act.taskId, erpSalesOrder.act.procInsId, "管理员强制删除");//备注
            actTaskService.runtimeService.deleteProcessInstance(erpSalesOrder.act.procInsId, "");
            actTaskService.historyService.deleteHistoricProcessInstance(erpSalesOrder.act.procInsId);//(顺序不能换)
        } catch (e: Exception) {

        }

//        删除销售订单
        return super.delete(erpSalesOrder) +
//                删除支付信息
                erpPayTypeDao.delete(ErpPayType(erpSalesOrder)) +
//                删除生产订单
                erpProductionOrderDao.delete(ErpProductionOrder(erpSalesOrder))
//        TODO 是否有必要在删除销售订单的时候，一并将发货信息删除？如果不删除是否需要提示用户自己手动删除？
//                erpShipmentsService.delete(ErpShipments(?))
    }

    /**
     * 保存整机销售订单
     * 开启工作流
     */
    @Transactional(readOnly = false)
    fun saveAndProcess(erpSalesOrder: ErpSalesOrder) {
        /*
               1：startProcess方法需要businessId，就是this.save(erpSalesOrder)，生成uuid
               2：而执行startProcess方法前需要判断页面上传入的erpSalesOrder.id，根据是否为空来执行不同的工作流方法
               所以提前声明id
                */
        val id = erpSalesOrder.id

        // 保存草稿
        this.save(erpSalesOrder)

        // 不是草稿，则一定是提交下一节点
        if (!erpSalesOrder.isDraft) {
            oaComplete(erpSalesOrder, id)
        }
    }


    /**
     * 如果不是保存草稿，那么一定是流转下一步，那么在这里是开启一个新流程
     */
    fun calOrderStatusByProcessIns(act: Act, vars: MutableMap<String, Any>): String {
        val taskDefKey = act.taskDefKey
        return when (valueOf(taskDefKey)) {
            BEGIN -> {
                vars["user_czy"] = ""
                "1"
            }
            CREATE_PRODUCTION_PLAN -> {
                vars["user_jl"] = ""
                "2" // 新建生产计划
            }
            CHECK_PRODUCTION_PLAN -> {
                if (act.flag == "1") {
                    vars["user_kj"] = ""
                    "3" // 生产计划审批通过
                } else {
                    vars["user_czy"] = ""
                    "4" // 生产计划未审批通过
                }
            }
            BEGIN_PAYMENT -> {
                vars["user_jl"] = ""
                "5" // 首付款已付
            }
            CHECK_BEGIN_PAYMENT -> {
                if (act.flag == "1") {
                    vars["user_czy"] = ""
                    "6" // 首付款审批通过
                } else {
                    vars["user_kj"] = ""
                    "7" // 首付款未审批通过
                }
            }
            CREATE_PRODUCTION_ORDER -> {
                vars["user_kj"] = ""
                "8" // 开始生产
            }
            END_PAYMENT -> {
                vars["user_jl"] = ""
                "9" // 尾款已付
            }
            CHECK_END_PAYMENT -> {
                if (act.flag == "1") {
                    vars["user_czy"] = ""
                    "10" // 尾款审批通过
                } else {
                    vars["user_kj"] = ""
                    "11" // 尾款未审批通过
                }
            }
            CREATE_SHIPMENTS -> {
                vars["user_kj"] = ""
                "12" // 发货
            }
            CAL_SALES_COMMISSIONS -> {
                vars["user_jl"] = ""
                "13" // 工资结算
            }
            CHECK_CAL_SALES_COMMISSIONS -> {
                if (act.flag == "1") {
                    "14" // 工资结算审批通过
                } else {
                    vars["user_kj"] = ""
                    "15" // 工资结算未审批通过
                }
            }
            END -> {
                "16" // 订单完成
            }
        }
    }

    /**
     * 完成当前任务，流转下一节点
     */
    fun oaComplete(erpSalesOrder: ErpSalesOrder, id: String) {
        val act = erpSalesOrder.act
        val vars = hashMapOf<String, Any>()

        if (isBlank(id) || isBlank(act.taskId)) { // id 是空，则是新建销售流程
            vars["businessId"] = erpSalesOrder.id
            vars["piNo"] = erpSalesOrder.piNo.toString()
            vars["user_czy"] = ""

            //            开启整机销售订单流程
            val procInsId = actTaskService.startProcess(PD_SALES_ORDER[0], PD_SALES_ORDER[1], erpSalesOrder.id, "整机:" + erpSalesOrder.piNo.toString(), vars)

            //            保存业务对象数据对应的流程实例id
            act.procInsId = procInsId
            //            新建订单，调用startProcess方法的页面不在流程中，所以无法获取act，更无法通过calOrderStatusByProcessIns(act: Act)计算出status
            erpSalesOrder.status = "1"

            this.save(erpSalesOrder)

        } else {
            vars["pass"] = act.flag
            vars["moneyPass"] = erpSalesOrder.moneyPass

            actTaskService.taskService.setVariableLocal(act.taskId, "pass", act.flag)
            //                完成任务，流转下一节点
            actTaskService.complete(act.taskId, act.procInsId, act.comment, vars)


            //                根据流程当前执行节点，返回订单业务状态
            erpSalesOrder.status = calOrderStatusByProcessIns(act, vars)

            //                记录状态到业务表
            this.save(erpSalesOrder)
        }
    }

    /**
     * 根据流程实例流转的当前节点，返回不同的form界面
     */
    fun oaForm(erpSalesOrder: ErpSalesOrder): String {

//        设置上一步审批结果
        val (flag, comment) =  getApproveInfoFromPreNode(erpSalesOrder.procInsId)
        erpSalesOrder.act.flag = flag
        erpSalesOrder.act.comment = comment

//        返回不同的表单
        val taskDefKey = erpSalesOrder.act.taskDefKey
        return when (SalesOrderTaskID.valueOf(taskDefKey)) {
            BEGIN -> {
//                开始页面位于流程外，点击“提交下一步时”，开始节点会立刻自动流转到下一节点，永远不会执行到此
                ""
            }
            CREATE_PRODUCTION_PLAN -> {
//                "czy/erpProductionPlainForm"
                "czy/erpProductionOrderForm"
            }
            CHECK_PRODUCTION_PLAN -> {
//                "jl/checkProductionPlainForm"
                "jl/checkProductionOrderForm"
            }
            BEGIN_PAYMENT -> {
                "kj/erpPaymentForm"
            }
            CHECK_BEGIN_PAYMENT -> {
                "jl/checkErpPaymentForm"
            }
            CREATE_PRODUCTION_ORDER -> {
                "czy/erpProductionOrderForm"
            }
            END_PAYMENT -> {
                "kj/erpPaymentForm"
            }
            CHECK_END_PAYMENT -> {
                "jl/checkErpPaymentForm"
            }
            CREATE_SHIPMENTS -> {
                /*
                 * 发货流程不会走这个方法：
                 * @see com.fy.erp.modules.erp.web.ErpSalesOrderController.oaForm
                 * 而是走下面的方法（因为流程模型上“操作员发货节点”配置了独立的表单编号）：
                 * @see com.fy.erp.modules.erp.web.ErpShipmentsController.shipmentForm
                 */
                ""
            }
            CAL_SALES_COMMISSIONS -> {
                "kj/erpCommissionForm"
            }
            CHECK_CAL_SALES_COMMISSIONS -> {
                "jl/checkErpPaymentForm"
            }
            END -> {
//                流程已结束后，没有流程实例了，则代办任务不可见，则此form方法不会执行
                ""
            }
        }

    }

    /**
     * 获取上一节点的审批信息
     */
    private fun getApproveInfoFromPreNode(procInsId: String?): Pair<String?, String?> {
        val lastTask = actTaskService.historyService.createHistoricTaskInstanceQuery()
                .processInstanceId(procInsId).orderByHistoricTaskInstanceEndTime().desc().list().first()

        val lastTaskVari = actTaskService.historyService.createHistoricVariableInstanceQuery()
                .variableName("pass")
                .taskId(lastTask.id)
                .singleResult()

        val comment = actTaskService.taskService.getTaskComments(lastTask.id)

        return Pair(lastTaskVari?.value?.toString(), if (comment.size > 0) {
            comment.last().fullMessage
        } else null)
    }

}