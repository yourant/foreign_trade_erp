package com.fy.erp.modules.erp.service

import com.fy.erp.common.service.CrudService
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

import com.fy.erp.modules.erp.entity.ErpCustomerVisit
import com.fy.erp.modules.erp.dao.ErpCustomerVisitDao

/**
 * 客户跟踪Service
 * @author 尹彬
 * @version 2017-12-26
 */
@Service
@Transactional(readOnly = true)
open class ErpCustomerVisitService: CrudService<ErpCustomerVisitDao, ErpCustomerVisit>() {

// ========================================================================================

}