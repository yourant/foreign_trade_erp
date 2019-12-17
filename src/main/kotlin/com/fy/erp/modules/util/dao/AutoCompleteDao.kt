package com.fy.erp.modules.util.dao

import com.fy.erp.common.persistence.CrudDao
import com.fy.erp.common.persistence.annotation.MyBatisDao
import com.fy.erp.modules.sys.entity.User
import com.fy.erp.modules.util.entity.AutoComplete
import org.apache.ibatis.annotations.Param

/**
 * 国家管理DAO接口
 * @author 尹彬
 * @version 2017-10-31
 */
@MyBatisDao
interface AutoCompleteDao : CrudDao<AutoComplete> {

    fun findAutoCompleteList(@Param("viewName") viewName: String): List<AutoComplete>;

    fun findSelectList(@Param("viewName") viewName: String): List<Map<String, Any>>

    fun findCustomerByUser(@Param("user") user: User): List<Map<String, Any>>

}