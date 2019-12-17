package com.fy.erp.modules.util.service

import com.fy.erp.common.service.CrudService
import com.fy.erp.modules.sys.entity.User
import com.fy.erp.modules.util.dao.AutoCompleteDao
import com.fy.erp.modules.util.entity.AutoComplete
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

/**
 * 国家管理Service
 * @author 尹彬
 * @version 2017-10-31
 */
@Service
@Transactional(readOnly = true)
open class AutoCompleteService : CrudService<AutoCompleteDao, AutoComplete>() {

    fun findAutoCompleteList(viewName: String): List<AutoComplete> {
        return dao.findAutoCompleteList(viewName)
    }

    fun findSelectList(viewName: String): List<Map<String, Any>> {
        return dao.findSelectList(viewName)
    }

    /**
     * 查询某个业务员自己的客户
     */
    fun findCustomerByUser(user: User): List<Map<String, Any>> {
//        user.sqlMap["dsf"] = dataScopeFilter(user, "o3", "u2")
        return dao.findCustomerByUser(user)
    }

}