package com.fy.erp.modules.erp.service;

import com.fy.erp.common.persistence.Page
import com.fy.erp.common.service.CrudService
import com.fy.erp.modules.erp.dao.ErpDockerDao
import com.fy.erp.modules.erp.dao.ErpProductionItemsDao
import com.fy.erp.modules.erp.dao.ErpVinDao
import com.fy.erp.modules.erp.entity.ErpProductionItems
import com.fy.erp.modules.erp.entity.ErpVin
import com.google.common.collect.Lists
import org.apache.commons.lang3.StringUtils.isNotBlank
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.*

/**
 * 生产明细Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpProductionItemsService : CrudService<ErpProductionItemsDao, ErpProductionItems>() {


    @Autowired
    lateinit var erpProductionItemsDao: ErpProductionItemsDao

    @Autowired
    lateinit var erpVinDao: ErpVinDao

    @Autowired
    lateinit var erpDockerDao: ErpDockerDao

    override fun get(id: String): ErpProductionItems {
        val erpProductionItems = super.get(id)
        return erpProductionItems
    }

    override fun findList(erpProductionItems: ErpProductionItems): List<ErpProductionItems> {
        return super.findList(erpProductionItems)
    }




    override fun findPage(page: Page<ErpProductionItems>, erpProductionItems: ErpProductionItems): Page<ErpProductionItems> {
        return super.findPage(page, erpProductionItems)
    }


    // ========================================================================================

    @Transactional(readOnly = false)
    override fun save(erpProductionItems: ErpProductionItems): Int {
        return super.save(erpProductionItems)
    }

    @Transactional(readOnly = false)
    override fun delete(erpProductionItems: ErpProductionItems): Int {
        return super.delete(erpProductionItems)
    }

    fun findList(erpSalesOrderId: String): List<ErpProductionItems> {
        return dao.findListBySalesOrderId(erpSalesOrderId)
    }

    fun findBoxList(erpSalesOrderId: String): List<ErpProductionItems> {
        val boxList = erpProductionItemsDao.findBoxList(erpSalesOrderId)

        val  productionItemsList = findList(erpSalesOrderId)
        for (erpProductionItems in productionItemsList) {
            erpProductionItems.erpVinList = erpVinDao.findList(ErpVin(erpProductionItems))
            erpProductionItems.erpVinList
                    .filter { it.erpDocker != null }
                    .forEach { it.erpDocker = erpDockerDao.get(it.erpDocker!!.id) }
        }

        for (erpProductionItems in boxList) {
            val erpCarType = erpProductionItems.erpCarType
            val erpEngineType = erpProductionItems.erpEngineType
            for (erpProductionItems2 in productionItemsList) {
                val erpCarType2 = erpProductionItems2.erpCarType
                val erpEngineType2 = erpProductionItems2.erpEngineType
                if (erpCarType!!.id == erpCarType2!!.id && erpEngineType!!.id == erpEngineType2!!.id) {
                    erpProductionItems.erpVinList.addAll(erpProductionItems2.erpVinList)
                }
            }
        }

        return boxList
    }


}