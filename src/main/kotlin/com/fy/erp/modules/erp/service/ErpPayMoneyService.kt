package com.fy.erp.modules.erp.service;

import com.fy.erp.common.persistence.Page
import com.fy.erp.common.service.CrudService
import com.fy.erp.modules.erp.dao.ErpPayMoneyDao
import com.fy.erp.modules.erp.entity.ErpPayMoney
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

/**
 * 支付金额Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpPayMoneyService : CrudService<ErpPayMoneyDao, ErpPayMoney>() {


    override fun get(id: String): ErpPayMoney {
        val erpPayMoney = super.get(id)
        return erpPayMoney
    }

    override fun findList(erpPayMoney: ErpPayMoney): List<ErpPayMoney> {
        return super.findList(erpPayMoney)
    }

    override fun findPage(page: Page<ErpPayMoney>, erpPayMoney: ErpPayMoney): Page<ErpPayMoney> {
        return super.findPage(page, erpPayMoney)
    }

    // ========================================================================================

    @Transactional(readOnly = false)
    override fun save(erpPayMoney: ErpPayMoney): Int {
        return super.save(erpPayMoney)
    }

    @Transactional(readOnly = false)
    override fun delete(erpPayMoney: ErpPayMoney): Int {
        return super.delete(erpPayMoney)
    }
}