package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.SysCountry
import com.fy.erp.modules.erp.service.SysCountryService

/**
 * 国家Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/sysCountry")
open class SysCountryController : BC() {

    @A
    lateinit var sysCountryService: SysCountryService

    @MA
    operator fun get(@RP(required = false) id: String?): SysCountry {
        return if (isNotBlank(id)) sysCountryService.get(id!!) else SysCountry()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:sysCountry:list")
    fun list(sysCountry: SysCountry, req: REQ, res: RES, m: M): String {
        val page = sysCountryService.findPage(Page(req, res), sysCountry)
        m.addAttribute("page", page)
        return "modules/erp/sysCountryList"
    }

    @RM("form")
    @PERM("erp:sysCountry:form")
    fun form(sysCountry: SysCountry, m: M): String {
        m.addAttribute("sysCountry", sysCountry)
        return "modules/erp/sysCountryForm"
    }

    @RM("view")
    @PERM("erp:sysCountry:view")
    fun view(sysCountry: SysCountry, m: M): String {
        m.addAttribute("sysCountry", sysCountry)
        m.addAttribute("isForEdit", false)
        return "modules/erp/sysCountryView"
    }

    @RM("save")
    @PERM("erp:sysCountry:save")
    fun save(sysCountry: SysCountry, m: M, ra: RA): String {
        if (!beanValidator(m, sysCountry)) {
            return form(sysCountry, m)
        }
        sysCountryService.save(sysCountry)
        addMessage(ra, "保存国家成功")
        return "redirect:${Global.getAdminPath()}/erp/sysCountry/?repage"
    }

    @RM("delete")
    @PERM("erp:sysCountry:delete")
    fun delete(sysCountry: SysCountry, ra: RA): String {
        sysCountryService.delete(sysCountry)
        addMessage(ra, "删除国家成功")
        return "redirect:${Global.getAdminPath()}/erp/sysCountry/?repage"
    }

    // ========================================================================================
}