package com.fy.erp.modules.erp.service

import com.fy.erp.common.persistence.Page
import com.fy.erp.common.service.CrudService
import com.fy.erp.modules.erp.dao.ErpCustomerDao
import com.fy.erp.modules.erp.entity.ErpCustomer
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

/**
 * 客户Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpCustomerService : CrudService<ErpCustomerDao, ErpCustomer>() {

    override fun findPage(page: Page<ErpCustomer>, entity: ErpCustomer): Page<ErpCustomer> {
        entity.getSqlMap().put("dsf", dataScopeFilter(entity.getCurrentUser(), "o3", "u2"));
        return super.findPage(page, entity)
    }


    // ========================================================================================

}