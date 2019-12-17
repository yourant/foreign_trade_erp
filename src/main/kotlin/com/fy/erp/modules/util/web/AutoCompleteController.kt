package com.fy.erp.modules.util.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import com.fy.erp.modules.sys.utils.UserUtils
import com.fy.erp.modules.util.entity.AutoComplete
import com.fy.erp.modules.util.service.AutoCompleteService
import com.google.common.collect.Lists
import com.google.common.collect.Maps
import org.apache.commons.lang3.StringUtils
import org.apache.shiro.authz.annotation.RequiresPermissions
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseBody

/**
 * 国家管理Controller
 * @author 尹彬
 * @version 2017-10-31
 */
@C
@RM("\${adminPath}/autoComplete")
public class AutoCompleteController : BC() {

    @A
    lateinit var autoCompleteService: AutoCompleteService;

    /**
     * 输入框方式
     * 获取自动完成视图的JSON数据。
     */
    @RM(*arrayOf("list", ""))
    @RB
    @PERM("crm:autoComplete:list")
    fun list(@RP("viewName") viewName: String): List<AutoComplete> {
        return autoCompleteService.findAutoCompleteList(viewName)
    }

    /**
     * 弹出对话框方式
     * 获取自动完成视图的JSON数据。
     * @param extId 排除的ID
     * @param type    类型（1：公司；2：部门/小组/其它：3：用户）
     * @param grade 显示级别
     * @param response
     * @return
     */
    @PERM("user")
    @RB
    @RM(value = ["treeData"])
    fun treeData(@RP("viewName") viewName: String, @RP("type") type: String, res: RES): List<Map<String, Any>> {
        return autoCompleteService.findSelectList(viewName)
    }

    /**
     * 查询某个业务员自己的客户
     */
    @PERM("user")
    @RB
    @RM("findCustomerBySessionUser")
    fun findCustomerBySessionUser(): List<Map<String, Any>> {
        return autoCompleteService.findCustomerByUser(UserUtils.getUser())
    }

}