package com.fy.erp.modules.erp.service;

import com.fy.erp.common.persistence.Page
import com.fy.erp.common.service.CrudService
import com.fy.erp.modules.erp.dao.ErpVinDao
import com.fy.erp.modules.erp.entity.ErpVin
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

/**
 * 车架信息Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpVinService : CrudService<ErpVinDao, ErpVin>() {


    override fun get(id: String): ErpVin {
        val erpVin = super.get(id)
        return erpVin
    }

    override fun findList(erpVin: ErpVin): List<ErpVin> {
        return super.findList(erpVin)
    }

    override fun findPage(page: Page<ErpVin>, erpVin: ErpVin): Page<ErpVin> {
        return super.findPage(page, erpVin)
    }

    // ========================================================================================

    @Transactional(readOnly = false)
    override fun save(erpVin: ErpVin): Int {
        return super.save(erpVin)
    }

    @Transactional(readOnly = false)
    override fun delete(erpVin: ErpVin): Int {
        return super.delete(erpVin)
    }


}