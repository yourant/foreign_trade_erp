package com.fy.erp.modules.erp.service;

import com.fy.erp.common.persistence.Page
import com.fy.erp.common.service.CrudService
import com.fy.erp.common.service.enu.NextOperation
import com.fy.erp.common.utils.ExportXlsUtil
import com.fy.erp.modules.erp.dao.ErpCarPartsDao
import com.fy.erp.modules.erp.dao.ErpSendItemsDao
import com.fy.erp.modules.erp.entity.ErpCarParts
import com.fy.erp.modules.erp.entity.ErpSendItems
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

/**
 * 配件Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpCarPartsService : CrudService<ErpCarPartsDao, ErpCarParts>() {

    @Autowired
    lateinit var erpPartsOrderService: ErpPartsOrderService
    @Autowired
    lateinit var erpSendItemsService: ErpSendItemsService

    @Autowired
    lateinit var erpSendItemsDao: ErpSendItemsDao

    override fun get(id: String): ErpCarParts {
        val erpCarParts = super.get(id)
        erpCarParts.erpSendItemsList = erpSendItemsDao.findList(ErpSendItems(erpCarParts))
        return erpCarParts
    }

    override fun findPage(page: Page<ErpCarParts>, erpCarParts: ErpCarParts): Page<ErpCarParts> {
        return super.findPage(page, erpCarParts)
    }

    @Transactional(readOnly = false)
    override fun save(erpCarParts: ErpCarParts): Int {
        super.save(erpCarParts)
        return erpCarParts.erpSendItemsList.map { child ->
            when (getNextOperation(child)!!) {
                NextOperation.INSERT -> { // 插入的情况
                    child.erpCarParts = erpCarParts
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
        }.sumBy { it } /* */
    }

    @Transactional(readOnly = false)
    override fun delete(erpCarParts: ErpCarParts): Int {
        super.delete(erpCarParts)
        return erpSendItemsDao.delete(ErpSendItems(erpCarParts))
    }

    // ========================================================================================

    fun findCarPartsList(erpCarParts: ErpCarParts, partsOrderId: String): List<ErpCarParts> {
        val erpPartsOrder = erpPartsOrderService.get(partsOrderId)
        val erpSendItemsList = erpSendItemsService.findList(ErpSendItems(erpPartsOrder))
        val erpCarPartsList = super.findList(erpCarParts)
        erpCarPartsList.forEach { erpCarParts ->
            erpSendItemsList.forEach { erpSendItems ->
                if (erpCarParts.id == erpSendItems.erpCarParts!!.id) {
                    erpCarParts.name = "true"
                }
            }
        }
        return erpCarPartsList
    }

    /**
     * 导出excel
     */
    fun exportXls(erpCarParts: ErpCarParts, outputPath: String) {
//        todo  需要查询数据
        val list = this.findList(erpCarParts)

        val templatePath = ExportXlsUtil::class.java.classLoader.getResource("xls-template")!!.path
        val template = File(templatePath, "report1.xlsx")

        val map = hashMapOf<String, Any?>()
        var mutableList = list.toMutableList().let {
            it.mapIndexed { index, erpCarParts -> erpCarParts.seqNo = index + 1;erpCarParts }
        }
        map["list"] = mutableList

        ExportXlsUtil.exportExcel(FileInputStream(template), FileOutputStream(outputPath), map)
    }

}