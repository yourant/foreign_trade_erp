package com.fy.erp.modules.erp.service;

import com.fy.erp.common.persistence.Page
import com.fy.erp.common.service.CrudService
import com.fy.erp.modules.erp.dao.ErpSendItemsDao
import com.fy.erp.modules.erp.entity.ErpCarParts
import com.fy.erp.modules.erp.entity.ErpPartsOrder
import com.fy.erp.modules.erp.entity.ErpSendItems
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

/**
 * 发货明细Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpSendItemsService : CrudService<ErpSendItemsDao, ErpSendItems>() {

    override fun get(id: String): ErpSendItems {
        val erpSendItems = super.get(id)
        return erpSendItems
    }

    override fun findList(erpSendItems: ErpSendItems): List<ErpSendItems> {
        return super.findList(erpSendItems)
    }

    override fun findPage(page: Page<ErpSendItems>, erpSendItems: ErpSendItems): Page<ErpSendItems> {
        return super.findPage(page, erpSendItems)
    }


    // ========================================================================================

    @Transactional(readOnly = false)
    override fun save(erpSendItems: ErpSendItems): Int {
        return super.save(erpSendItems)
    }

    @Transactional(readOnly = false)
    override fun delete(erpSendItems: ErpSendItems): Int {
        return super.delete(erpSendItems)
    }

    @Transactional(readOnly = false)
    fun addParts(partsIds: String, partsOrderId: String): Int {
        val count = partsIds.split(",").map {
            val erpSendItems = ErpSendItems()
            erpSendItems.erpPartsOrder = ErpPartsOrder(partsOrderId)
            erpSendItems.enumSendItemsType = "2"
            erpSendItems.erpCarParts = ErpCarParts(it)
            super.save(erpSendItems)
        }.sumBy { it }
        return count
    }

}