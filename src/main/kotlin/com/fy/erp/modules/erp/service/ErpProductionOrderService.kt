package com.fy.erp.modules.erp.service;

import com.fy.erp.common.persistence.Page
import com.fy.erp.common.service.CrudService
import com.fy.erp.common.service.enu.NextOperation
import com.fy.erp.modules.erp.dao.ErpProductionItemsDao
import com.fy.erp.modules.erp.dao.ErpProductionOrderDao
import com.fy.erp.modules.erp.entity.ErpProductionItems
import com.fy.erp.modules.erp.entity.ErpProductionOrder
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

/**
 * 生产订单Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpProductionOrderService : CrudService<ErpProductionOrderDao, ErpProductionOrder>() {

    @Autowired
    lateinit var erpProductionItemsDao: ErpProductionItemsDao

    override fun get(id: String): ErpProductionOrder {
        val erpProductionOrder = super.get(id)
        erpProductionOrder.erpProductionItemsList = erpProductionItemsDao.findList(ErpProductionItems(erpProductionOrder))
        return erpProductionOrder
    }

    override fun findList(erpProductionOrder: ErpProductionOrder): List<ErpProductionOrder> {
        return super.findList(erpProductionOrder)
    }

    override fun findPage(page: Page<ErpProductionOrder>, erpProductionOrder: ErpProductionOrder): Page<ErpProductionOrder> {
        return super.findPage(page, erpProductionOrder)
    }

    @Transactional(readOnly = false)
    override fun save(erpProductionOrder: ErpProductionOrder): Int {
        super.save(erpProductionOrder)
        return erpProductionOrder.erpProductionItemsList.map { child ->
            when (getNextOperation(child)!!) {
                NextOperation.INSERT -> { // 插入的情况
                    child.erpProductionOrder = erpProductionOrder
                    child.preInsert()
                    erpProductionItemsDao.insert(child)
                }
                NextOperation.UPDATE -> {  // 更新的情况
                    child.preUpdate()
                    erpProductionItemsDao.update(child)
                }
                NextOperation.DELETE -> { //删除的情况
                    erpProductionItemsDao.delete(child)
                }
            }
        }.sumBy { it } /* */
    }

    @Transactional(readOnly = false)
    override fun delete(erpProductionOrder: ErpProductionOrder): Int {
        super.delete(erpProductionOrder)
        return erpProductionItemsDao.delete(ErpProductionItems(erpProductionOrder))
    }

    // ========================================================================================

    @Transactional(readOnly = false)
    fun deleteAll(erpProductionOrder: ErpProductionOrder): Int {
        super.delete(erpProductionOrder)
        return erpProductionOrder.erpProductionItemsList.map { child ->
            erpProductionItemsDao.delete(child)
        }.sumBy { it }
    }


}