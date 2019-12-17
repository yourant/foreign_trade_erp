package com.fy.erp.modules.erp.service

import com.fy.erp.common.service.CrudService
import com.fy.erp.modules.erp.dao.ErpEngineTypeDao
import com.fy.erp.modules.erp.entity.ErpEngineType
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

/**
 * 发动机型号Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpEngineTypeService : CrudService<ErpEngineTypeDao, ErpEngineType>() {

// ========================================================================================

}