package com.fy.erp.modules.erp.service

import com.fy.erp.common.service.CrudService
import com.fy.erp.modules.erp.dao.ErpCarTypeDao
import com.fy.erp.modules.erp.entity.ErpCarType
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

/**
 * 车型Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpCarTypeService : CrudService<ErpCarTypeDao, ErpCarType>() {

// ========================================================================================

}