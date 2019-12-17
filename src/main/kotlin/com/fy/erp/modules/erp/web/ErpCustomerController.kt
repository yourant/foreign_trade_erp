package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpCustomer
import com.fy.erp.modules.erp.service.ErpCustomerService
import com.fy.erp.modules.sys.utils.UserUtils

/**
 * 客户Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpCustomer")
open class ErpCustomerController : BC() {

    @A
    lateinit var erpCustomerService: ErpCustomerService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpCustomer {
        return if (isNotBlank(id)) erpCustomerService.get(id!!) else ErpCustomer()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpCustomer:list")
    fun list(erpCustomer: ErpCustomer, req: REQ, res: RES, m: M): String {
        val page = erpCustomerService.findPage(Page(req, res), erpCustomer)
        m.addAttribute("page", page)
        return "modules/erp/erpCustomerList"
    }

    @RM("form")
    @PERM("erp:erpCustomer:form")
    fun form(erpCustomer: ErpCustomer, m: M): String {
        m.addAttribute("erpCustomer", erpCustomer)
        return "modules/erp/erpCustomerForm"
    }

    @RM("view")
    @PERM("erp:erpCustomer:view")
    fun view(erpCustomer: ErpCustomer, m: M): String {
        m.addAttribute("erpCustomer", erpCustomer)
        m.addAttribute("isForEdit", false)
        return "modules/erp/erpCustomerView"
    }

    @RM("save")
    @PERM("erp:erpCustomer:save")
    fun save(erpCustomer: ErpCustomer, m: M, ra: RA): String {
        if (!beanValidator(m, erpCustomer)) {
            return form(erpCustomer, m)
        }
        erpCustomerService.save(erpCustomer)
        addMessage(ra, "保存客户成功")
        return "redirect:${Global.getAdminPath()}/erp/erpCustomer/?repage"
    }

    @RM("delete")
    @PERM("erp:erpCustomer:delete")
    fun delete(erpCustomer: ErpCustomer, ra: RA): String {
        erpCustomerService.delete(erpCustomer)
        addMessage(ra, "删除客户成功")
        return "redirect:${Global.getAdminPath()}/erp/erpCustomer/?repage"
    }

    // ========================================================================================
}