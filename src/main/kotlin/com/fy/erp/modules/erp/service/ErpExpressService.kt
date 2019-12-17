package com.fy.erp.modules.erp.service;

import com.fy.erp.common.persistence.Page
import com.fy.erp.common.service.CrudService
import com.fy.erp.modules.erp.dao.ErpExpressDao
import com.fy.erp.modules.erp.entity.ErpExpress
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

/**
 * 快递Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpExpressService : CrudService<ErpExpressDao, ErpExpress>() {


    override fun get(id: String): ErpExpress {
        val erpExpress = super.get(id)
        return erpExpress
    }

    override fun findList(erpExpress: ErpExpress): List<ErpExpress> {
        return super.findList(erpExpress)
    }

    override fun findPage(page: Page<ErpExpress>, erpExpress: ErpExpress): Page<ErpExpress> {
        return super.findPage(page, erpExpress)
    }

    // ========================================================================================


    @Transactional(readOnly = false)
    override fun save(erpExpress: ErpExpress): Int {
        return super.save(erpExpress)
    }

    @Transactional(readOnly = false)
    override fun delete(erpExpress: ErpExpress): Int {
        return super.delete(erpExpress)
    }

}