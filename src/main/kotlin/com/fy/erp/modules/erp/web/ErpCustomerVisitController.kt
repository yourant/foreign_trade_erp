package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import com.fy.erp.modules.erp.entity.ErpCustomer
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpCustomerVisit
import com.fy.erp.modules.erp.service.ErpCustomerVisitService

/**
 * 客户跟踪Controller
 * @author 尹彬
 * @version 2017-12-26
 */
@C
@RM("\${adminPath}/erp/erpCustomerVisit")
open class ErpCustomerVisitController : BC() {

    @A
    lateinit var erpCustomerVisitService: ErpCustomerVisitService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpCustomerVisit {
        return if (isNotBlank(id)) erpCustomerVisitService.get(id!!) else ErpCustomerVisit()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpCustomerVisit:list")
    fun list(erpCustomerVisit: ErpCustomerVisit, @RP(required = false) erpCustomerId: String?, req: REQ, res: RES, m: M): String {
        val customerId = erpCustomerId ?: (req.session.getAttribute("__customerId") ?: "")
        erpCustomerVisit.erpCustomer = ErpCustomer(customerId as String)
        req.session.setAttribute("__customerId", customerId)
        val page = erpCustomerVisitService.findPage(Page(req, res), erpCustomerVisit)
        m.addAttribute("page", page)
        return "modules/erp/erpCustomerVisitList"
    }

    @RM("form")
    @PERM("erp:erpCustomerVisit:form")
    fun form(erpCustomerVisit: ErpCustomerVisit, m: M): String {
        m.addAttribute("erpCustomerVisit", erpCustomerVisit)
        return "modules/erp/erpCustomerVisitForm"
    }

    @RM("view")
    @PERM("erp:erpCustomerVisit:view")
    fun view(erpCustomerVisit: ErpCustomerVisit, m: M): String {
        m.addAttribute("erpCustomerVisit", erpCustomerVisit)
        m.addAttribute("isForEdit", false)
        return "modules/erp/erpCustomerVisitView"
    }

    @RM("save")
    @PERM("erp:erpCustomerVisit:save")
    fun save(erpCustomerVisit: ErpCustomerVisit, req: REQ, res: RES, m: M, ra: RA): String {
        if (!beanValidator(m, erpCustomerVisit)) {
            return form(erpCustomerVisit, m)
        }
        val customerId = req.session.getAttribute("__customerId")
        if (customerId != null) {
            erpCustomerVisit.erpCustomer = ErpCustomer(customerId as String)
            erpCustomerVisitService.save(erpCustomerVisit)
            addMessage(ra, "保存客户跟踪成功")
        } else {
            addMessage(ra, "保存客户跟踪失败")
        }
        return "redirect:${Global.getAdminPath()}/erp/erpCustomerVisit/?repage"
    }

    @RM("delete")
    @PERM("erp:erpCustomerVisit:delete")
    fun delete(erpCustomerVisit: ErpCustomerVisit, ra: RA): String {
        erpCustomerVisitService.delete(erpCustomerVisit)
        addMessage(ra, "删除客户跟踪成功")
        return "redirect:${Global.getAdminPath()}/erp/erpCustomerVisit/?repage"
    }

    // ========================================================================================
}