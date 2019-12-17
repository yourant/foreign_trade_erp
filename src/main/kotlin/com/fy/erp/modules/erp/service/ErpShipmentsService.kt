package com.fy.erp.modules.erp.service;

import com.fy.erp.common.persistence.Page
import com.fy.erp.common.service.CrudService
import com.fy.erp.common.service.enu.NextOperation
import com.fy.erp.modules.act.service.ActTaskService
import com.fy.erp.modules.erp.dao.ErpDockerDao
import com.fy.erp.modules.erp.dao.ErpShipmentsDao
import com.fy.erp.modules.erp.dao.ErpVinDao
import com.fy.erp.modules.erp.entity.ErpDocker
import com.fy.erp.modules.erp.entity.ErpSalesOrderShipments
import com.fy.erp.modules.erp.entity.ErpShipments
import org.apache.commons.lang3.StringUtils.isNotBlank
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

/**
 * 发货单Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpShipmentsService : CrudService<ErpShipmentsDao, ErpShipments>() {

    @Autowired
    lateinit var actTaskService: ActTaskService

    @Autowired
    lateinit var erpSalesOrderService: ErpSalesOrderService

    @Autowired
    lateinit var erpDockerDao: ErpDockerDao
    @Autowired
    lateinit var erpShipmentsDao: ErpShipmentsDao
    @Autowired
    lateinit var erpVinDao: ErpVinDao


    override fun get(id: String): ErpShipments {
        val erpShipments = super.get(id)
        //整机销售流程传的是销售订单ID 名字和发货单ID重复 所以可能查出null
        return if (erpShipments != null) {
            erpShipments.erpDockerList = erpDockerDao.findList(ErpDocker(erpShipments))
            erpShipments
        } else {
            //整机销售流程传的是销售顶单的id
            val newerpShipments: ErpShipments = ErpShipments()
            newerpShipments.act.businessId = id
            newerpShipments
        }

    }

    override fun findList(erpShipments: ErpShipments): List<ErpShipments> {
        return super.findList(erpShipments)
    }

    override fun findPage(page: Page<ErpShipments>, erpShipments: ErpShipments): Page<ErpShipments> {
        return super.findPage(page, erpShipments)
    }

    @Transactional(readOnly = false)
    override fun save(erpShipments: ErpShipments): Int {
        super.save(erpShipments)
        return erpShipments.erpDockerList.map { child ->
            when (getNextOperation(child)!!) {
                NextOperation.INSERT -> { // 插入的情况
                    child.erpShipments = erpShipments
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
        }.sumBy { it } /* */
    }

    @Transactional(readOnly = false)
    override fun delete(erpShipments: ErpShipments): Int {
        super.delete(erpShipments)
        return erpDockerDao.delete(ErpDocker(erpShipments))
    }

    // ========================================================================================

    /**
     * 保存发货单信息并保存发货单和销售订单中间表  只是添加的时候保存
     */
    @Transactional(readOnly = false)
    fun save(erpShipments: ErpShipments, salesOrderId: String): Int {
        val shipmentsCount = super.save(erpShipments)

        val erpSalesOrderShipments = ErpSalesOrderShipments()
        erpSalesOrderShipments.erpSalesOrderId = salesOrderId
        erpSalesOrderShipments.erpShipmentsId = erpShipments.id

        val selectSalesOrderShipments = erpShipmentsDao.selectSalesOrderShipments(erpSalesOrderShipments)

        var mappingCount = 0;
        if (selectSalesOrderShipments == null || selectSalesOrderShipments?.id == null) {
            erpSalesOrderShipments.preInsert()
            mappingCount = erpShipmentsDao.insertSalesOrderShipments(erpSalesOrderShipments)
        }
        //添加发货单保存发货单和销售单中间表
/*
        val mappingCount = when (getNextOperation(erpSalesOrderShipments)!!) {
            NextOperation.INSERT -> { // 插入的情况
                erpSalesOrderShipments.preInsert()
                erpShipmentsDao.insertSalesOrderShipments(erpSalesOrderShipments)
            }
            NextOperation.UPDATE -> 0  // 更新的情况
            NextOperation.DELETE -> 0 //删除的情况
        }
*/

        val dockerKeyMap = hashMapOf<String, String>()

        val dockerCount = erpShipments.erpDockerList.map { child ->
            val count = when (getNextOperation(child)!!) {
                NextOperation.INSERT -> { // 插入的情况
                    child.erpShipments = erpShipments
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

        val vinCount = erpShipments.erpVinList.map { child ->
            if (isNotBlank(child.dockerKey)) {
                child.erpDocker = ErpDocker(dockerKeyMap[child.dockerKey]!!)
            }
            when (getNextOperation(child)!!) {
                NextOperation.INSERT -> { // 插入的情况
                    child.preInsert()
                    erpVinDao.insert(child)
                }
                NextOperation.UPDATE -> {  // 更新的情况
                    child.preUpdate()
                    erpVinDao.update(child)
                }
                NextOperation.DELETE -> { //删除的情况
                    erpVinDao.delete(child)
                }
            }
        }.sumBy { it }

        return shipmentsCount + mappingCount + dockerCount + vinCount
    }

    /**
     * 根据销售订单ID查询发货单信息
     */
    fun findShipmentsBySalesOrderId(erpSalesOrderId: String): ErpShipments {
        val erpSalesOrderShipments = ErpSalesOrderShipments()
        erpSalesOrderShipments.erpSalesOrderId = erpSalesOrderId
        val salesOrderShipments = erpShipmentsDao.selectSalesOrderShipments(erpSalesOrderShipments)
        return if (salesOrderShipments != null) {
            this.get(salesOrderShipments.erpShipmentsId!!)
        } else {
            ErpShipments()
        }
    }

    /**
     * 保存发货单 集装箱 装箱信息
     * 流转下一节点
     */
    @Transactional(readOnly = false)
    fun saveAndProcess(erpShipments: ErpShipments, salesOrderId: String) {
        // 保存草稿
        this.save(erpShipments, salesOrderId)

        // 不是草稿，则一定是提交下一节点
        if (!erpShipments.isDraft) {
            oaComplete(erpShipments, salesOrderId)
        }
    }

    /**
     * 完成当前任务，流转下一节点
     */
    fun oaComplete(erpShipments: ErpShipments, salesOrderId: String) {

        val act = erpShipments.act
        val vars = hashMapOf<String, Any>()
        vars["pass"] = act.flag
        // 完成任务，流转下一节点
        actTaskService.complete(act.taskId, act.procInsId, act.comment, vars)


        // 根据流程当前执行节点，返回订单业务状态
        val erpSalesOrder = erpSalesOrderService.get(salesOrderId)
        // 发货状态
        erpSalesOrder.status = "12"
        // 记录状态到业务表
        erpSalesOrderService.save(erpSalesOrder)

    }

}