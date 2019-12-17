package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpExpress
import com.fy.erp.modules.erp.service.ErpExpressService

/**
 * 快递Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpExpress")
open class ErpExpressController : BC() {

    @A
    lateinit var erpExpressService: ErpExpressService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpExpress {
        return if (isNotBlank(id)) erpExpressService.get(id!!) else ErpExpress()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpExpress:list")
    fun list(erpExpress: ErpExpress, req: REQ, res: RES, m: M): String {
        val page = erpExpressService.findPage(Page(req, res), erpExpress)
        m.addAttribute("page", page)
        return "modules/erp/erpExpressList"
    }

    @RM("form")
    @PERM("erp:erpExpress:form")
    fun form(erpExpress: ErpExpress, m: M): String {
        m.addAttribute("erpExpress", erpExpress)
        return "modules/erp/erpExpressForm"
    }

    @RM("view")
    @PERM("erp:erpExpress:view")
    fun view(erpExpress: ErpExpress, m: M): String {
        m.addAttribute("erpExpress", erpExpress)
        m.addAttribute("isForEdit", false)
        return "modules/erp/erpExpressView"
    }

    @RM("save")
    @PERM("erp:erpExpress:save")
    fun save(erpExpress: ErpExpress, m: M, ra: RA): String {
        if (!beanValidator(m, erpExpress)) {
            return form(erpExpress, m)
        }
        erpExpressService.save(erpExpress)
        addMessage(ra, "保存快递成功")
        return "redirect:${Global.getAdminPath()}/erp/erpExpress/?repage"
    }

    @RM("delete")
    @PERM("erp:erpExpress:delete")
    fun delete(erpExpress: ErpExpress, ra: RA): String {
        erpExpressService.delete(erpExpress)
        addMessage(ra, "删除快递成功")
        return "redirect:${Global.getAdminPath()}/erp/erpExpress/?repage"
    }

    // ========================================================================================
}