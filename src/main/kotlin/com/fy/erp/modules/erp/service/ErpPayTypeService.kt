package com.fy.erp.modules.erp.service;

import com.fy.erp.common.persistence.Page
import com.fy.erp.common.service.CrudService
import com.fy.erp.common.service.enu.NextOperation
import com.fy.erp.modules.erp.dao.ErpPayMoneyDao
import com.fy.erp.modules.erp.dao.ErpPayTypeDao
import com.fy.erp.modules.erp.entity.ErpPayMoney
import com.fy.erp.modules.erp.entity.ErpPayType
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

/**
 * 支付类型Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpPayTypeService : CrudService<ErpPayTypeDao, ErpPayType>() {

    @Autowired
    lateinit var erpPayMoneyDao: ErpPayMoneyDao

    override fun get(id: String): ErpPayType {
        val erpPayType = super.get(id)
        erpPayType.erpPayMoneyList = erpPayMoneyDao.findList(ErpPayMoney(erpPayType))
        return erpPayType
    }

    override fun findList(erpPayType: ErpPayType): List<ErpPayType> {
        return super.findList(erpPayType)
    }

    override fun findPage(page: Page<ErpPayType>, erpPayType: ErpPayType): Page<ErpPayType> {
        return super.findPage(page, erpPayType)
    }

    @Transactional(readOnly = false)
    override fun save(erpPayType: ErpPayType): Int {
        super.save(erpPayType)
        return erpPayType.erpPayMoneyList.map { child ->
            when (getNextOperation(child)!!) {
                NextOperation.INSERT -> { // 插入的情况
                    child.erpPayType = erpPayType
                    child.preInsert()
                    erpPayMoneyDao.insert(child)
                }
                NextOperation.UPDATE -> {  // 更新的情况
                    child.preUpdate()
                    erpPayMoneyDao.update(child)
                }
                NextOperation.DELETE -> { //删除的情况
                    erpPayMoneyDao.delete(child)
                }
            }
        }.sumBy { it } /* */
    }

    @Transactional(readOnly = false)
    override fun delete(erpPayType: ErpPayType): Int {
        super.delete(erpPayType)
        return erpPayMoneyDao.delete(ErpPayMoney(erpPayType))
    }

    // ========================================================================================

    @Transactional(readOnly = false)
    fun deleteAll(erpPayType: ErpPayType): Int {
        super.delete(erpPayType)
        return erpPayType.erpPayMoneyList.map { child ->
            erpPayMoneyDao.delete(child)
        }.sumBy { it }
    }

}