package com.fy.erp.modules.erp.service;

import com.fy.erp.common.persistence.Page
import com.fy.erp.common.service.CrudService
import com.fy.erp.common.service.enu.NextOperation
import com.fy.erp.modules.erp.dao.ErpDockerDao
import com.fy.erp.modules.erp.dao.ErpPartsOrderDao
import com.fy.erp.modules.erp.dao.ErpSendItemsDao
import com.fy.erp.modules.erp.entity.ErpDocker
import com.fy.erp.modules.erp.entity.ErpPartsOrder
import com.fy.erp.modules.erp.entity.ErpSendItems
import com.fy.erp.modules.act.entity.Act
import com.fy.erp.modules.act.service.ActTaskService
import com.fy.erp.modules.act.utils.ActUtils
import org.apache.commons.lang3.StringUtils
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import com.fy.erp.modules.erp.entity.PartsOrderTaskID
import com.fy.erp.modules.erp.entity.PartsOrderTaskID.*
import org.springframework.transaction.annotation.Propagation

/**
 * 配件订单Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpPartsOrderService : CrudService<ErpPartsOrderDao, ErpPartsOrder>() {

    @Autowired
    lateinit var actTaskService: ActTaskService

    @Autowired
    lateinit var erpExpressService: ErpExpressService
    @Autowired
    lateinit var erpShipmentsService: ErpShipmentsService
    @Autowired
    lateinit var erpSendItemsService: ErpSendItemsService

    @Autowired
    lateinit var erpDockerDao: ErpDockerDao
    @Autowired
    lateinit var erpSendItemsDao: ErpSendItemsDao

    override fun get(id: String): ErpPartsOrder {
        val erpPartsOrder = super.get(id)
        erpPartsOrder.erpSendItemsList = erpSendItemsService.findList(ErpSendItems(erpPartsOrder))
        //查询集装箱信息
        if (erpPartsOrder.erpShipments != null) {
            erpPartsOrder.erpShipments!!.erpDockerList = erpDockerDao.findList(ErpDocker(erpPartsOrder.erpShipments!!))
        }
        return erpPartsOrder
    }

    override fun findList(erpPartsOrder: ErpPartsOrder): List<ErpPartsOrder> {
        return super.findList(erpPartsOrder)
    }

    override fun findPage(page: Page<ErpPartsOrder>, erpPartsOrder: ErpPartsOrder): Page<ErpPartsOrder> {
        return super.findPage(page, erpPartsOrder)
    }

    // ========================================================================================

    @Transactional(readOnly = false)
    override fun save(erpPartsOrder: ErpPartsOrder): Int {
        val count = super.save(erpPartsOrder)
        var expressCount = 0
        var shipmentsCount = 0
        if (erpPartsOrder.erpExpress != null) {//快递信息不为空则保存
            erpPartsOrder.erpExpress!!.erpPartsOrder = erpPartsOrder
            expressCount = erpExpressService.save(erpPartsOrder.erpExpress!!)
        }
        val dockerKeyMap = hashMapOf<String, String>()
        if (erpPartsOrder.erpShipments != null) {//拼箱信息不为空则保存
            erpPartsOrder.erpShipments!!.erpPartsOrder = erpPartsOrder
            shipmentsCount = erpShipmentsService.save(erpPartsOrder.erpShipments!!)
            //保存集装箱信息
            val dockerCount = erpPartsOrder.erpShipments!!.erpDockerList.map { child ->
                val count = when (getNextOperation(child)!!) {
                    NextOperation.INSERT -> { // 插入的情况
                        child.erpShipments = erpPartsOrder.erpShipments!!
                        child.preInsert()
                        erpDockerDao.insert(child)
                    }
                    NextOperation.UPDATE -> {  // 更新的情况
                        child.preUpdate()
                        erpDockerDao.update(child)
                    }
                    NextOperation.DELETE -> { //删除的情况
                        erpDockerDao.delete(child)
                    }
                }
                dockerKeyMap[(child.dockerNo + "-" + child.sealNo)] = child.id
                count
            }.sumBy { it }
        }
        //发货信息 只能有一种发货方式
        val sendItemsCount = erpPartsOrder.erpSendItemsList.map { child ->
            if (StringUtils.isNotBlank(child.dockerKey) && child.statusKey == "shipments") {
                child.erpDocker = ErpDocker(dockerKeyMap[child.dockerKey]!!)
            }
            when {
                child.statusKey == "express" -> {//发快递的
                    child.erpExpress = erpPartsOrder.erpExpress
                    child.erpDocker = null
                }
                child.statusKey == "shipments" -> {//发拼箱的
                    child.erpDocker!!.erpShipments = erpPartsOrder.erpShipments
                    child.erpExpress = null
                }
                else -> {
                    child.erpDocker = null
                    child.erpExpress = null
                }
            }
            child.enumSendItemsType = "1" // 发送配件类型 1：三包单
            child.erpPartsOrder = erpPartsOrder
            when (getNextOperation(child)!!) {
                NextOperation.INSERT -> { // 插入的情况
                    child.preInsert()
                    erpSendItemsDao.insert(child)
                }
                NextOperation.UPDATE -> {  // 更新的情况
                    child.preUpdate()
                    erpSendItemsDao.update(child)
                }
                NextOperation.DELETE -> { //删除的情况
                    erpSendItemsDao.delete(child)
                }
            }
        }.sumBy { it }
        return count + expressCount + shipmentsCount + sendItemsCount
    }

    @Transactional(readOnly = false,propagation = Propagation.NEVER)
    override fun delete(erpPartsOrder: ErpPartsOrder): Int {
        //        彻底删除销售订单前，先工作流信息清楚

        try {
            actTaskService.taskService.addComment(erpPartsOrder.act.taskId, erpPartsOrder.act.procInsId, "管理员强制删除");//备注
            actTaskService.runtimeService.deleteProcessInstance(erpPartsOrder.act.procInsId, "");
            actTaskService.historyService.deleteHistoricProcessInstance(erpPartsOrder.act.procInsId);//(顺序不能换)
        } catch (e: Exception) {
        }

        return super.delete(erpPartsOrder);
    }

    /**
     * 保存配件订单
     * 开启工作流
     */
    @Transactional(readOnly = false)
    fun saveAndProcess(erpPartsOrder: ErpPartsOrder) {
        /*
           1：startProcess方法需要businessId，就是this.save(erpPartsOrder)，生成uuid
           2：而执行startProcess方法前需要判断页面上传入的erpPartsOrder.id，根据是否为空来执行不同的工作流方法
           所以提前声明id
            */
        val id = erpPartsOrder.id

        // 保存草稿
        this.save(erpPartsOrder)

        // 不是草稿，则一定是开启流程
        if (!erpPartsOrder.isDraft) {
            oaComplete(erpPartsOrder, id)
        }
    }

    /**
     * 开启流程 并根据解决方案类型流转不同的节点 1：维修，2：配件
     */
    fun oaComplete(erpPartsOrder: ErpPartsOrder, id: String) {
        val act = erpPartsOrder.act
        val vars = hashMapOf<String, Any>()

        if (StringUtils.isBlank(id) || StringUtils.isBlank(act.taskId)) { // id 是空，则是新建配件订单流程
            vars["businessId"] = erpPartsOrder.id
            vars["piNo"] = erpPartsOrder.pi.toString()

            // 开启配件订单流程
            val procInsId = actTaskService.startProcess(ActUtils.PD_PARTS_ORDER[0], ActUtils.PD_PARTS_ORDER[1], erpPartsOrder.id, "配件：" + erpPartsOrder.pi.toString(), vars)

            // 保存业务对象数据对应的流程实例id
            act.procInsId = procInsId
            // 新建配件订单，调用startProcess方法的页面不在流程中，所以无法获取act，更无法通过calOrderStatusByProcessIns(act: Act)计算出status
            erpPartsOrder.status = "1" // 新建配件订单
            super.save(erpPartsOrder)

        } else {
            vars["pass"] = act.flag

            actTaskService.taskService.setVariableLocal(act.taskId, "pass", act.flag)
            // 完成任务，流转下一节点
            actTaskService.complete(act.taskId, act.procInsId, act.comment, vars)


            // 根据流程当前执行节点，返回订单业务状态
            erpPartsOrder.status = calOrderStatusByProcessIns(act, vars)

            // 记录状态到业务表
            super.save(erpPartsOrder)
        }
    }

    /**
     * 如果不是保存草稿，那么一定是流转下一步
     */
    fun calOrderStatusByProcessIns(act: Act, vars: MutableMap<String, Any>): String {
        val taskDefKey = act.taskDefKey
        return when (valueOf(taskDefKey)) {
            BEGIN -> {
                "1"
            }
            CREATE_SEND_ITEMS -> {
                "2" // 录入配件信息
            }
            CHECK_SEND_ITEMS -> {
                if (act.flag == "1") {
                    "3" // 配件审批通过
                } else {
                    "4" // 配件未审批通过
                }
            }
            CREATE_PAYMENT -> {
                "5" // 会计确认收款
            }
            CHECK_PAYMENT -> {
                if (act.flag == "1") {
                    "6" // 收款审批通过
                } else {
                    "7" // 收款审批未通过
                }
            }
            CREATE_SHIPPING_INFO -> {
                "8" // 录入发货信息
            }
            CHECK_SHIPPING_INFO -> {
                if (act.flag == "1") {
                    "9" // 发货信息审批通过
                } else {
                    "10" // 发货信息未审批通过
                }
            }
            END -> {
                "15" // 订单完成
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

    fun oaForm(erpPartsOrder: ErpPartsOrder): String {
        //  设置上一步审批结果
        val (flag, comment) = getApproveInfoFromPreNode(erpPartsOrder.act.procInsId)
        erpPartsOrder.act.flag = flag
        erpPartsOrder.act.comment = comment

        //  返回不同的表单
        val taskDefKey = erpPartsOrder.act.taskDefKey
        return when (PartsOrderTaskID.valueOf(taskDefKey)) {
            BEGIN -> {
                //  开始页面位于流程外，点击“提交下一步时”，开始节点会立刻自动流转到下一节点，永远不会执行到此
                ""
            }
            CREATE_SEND_ITEMS -> {
                "erpSendItemsForm"
            }
            CHECK_SEND_ITEMS -> {
                "checkErpSendItemsForm"
            }
            CREATE_PAYMENT -> {
                "erpSendItemsForm"
            }
            CHECK_PAYMENT -> {
                "checkErpSendItemsForm"
            }
            CREATE_SHIPPING_INFO -> {
                "erpSendItemsForm"
            }
            CHECK_SHIPPING_INFO -> {
                "checkErpSendItemsForm"
            }
            END -> {
                //   流程已结束后，没有流程实例了，则代办任务不可见，则此form方法不会执行
                ""
            }
        }
    }
}