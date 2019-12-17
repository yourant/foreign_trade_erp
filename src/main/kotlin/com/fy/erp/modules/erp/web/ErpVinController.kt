package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpVin
import com.fy.erp.modules.erp.service.ErpVinService

/**
 * 车架信息Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpVin")
open class ErpVinController : BC() {

    @A
    lateinit var erpVinService: ErpVinService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpVin {
        return if (isNotBlank(id)) erpVinService.get(id!!) else ErpVin()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpVin:list")
    fun list(erpVin: ErpVin, req: REQ, res: RES, m: M): String {
        val page = erpVinService.findPage(Page(req, res), erpVin)
        m.addAttribute("page", page)
        return "modules/erp/erpVinList"
    }

    @RM("form")
    @PERM("erp:erpVin:form")
    fun form(erpVin: ErpVin, m: M): String {
        m.addAttribute("erpVin", erpVin)
        return "modules/erp/erpVinForm"
    }

    @RM("view")
    @PERM("erp:erpVin:view")
    fun view(erpVin: ErpVin, m: M): String {
        m.addAttribute("erpVin", erpVin)
        m.addAttribute("isForEdit", false)
        return "modules/erp/erpVinView"
    }

    @RM("save")
    @PERM("erp:erpVin:save")
    fun save(erpVin: ErpVin, m: M, ra: RA): String {
        if (!beanValidator(m, erpVin)) {
            return form(erpVin, m)
        }
        erpVinService.save(erpVin)
        addMessage(ra, "保存车架信息成功")
        return "redirect:${Global.getAdminPath()}/erp/erpVin/?repage"
    }

    @RM("delete")
    @PERM("erp:erpVin:delete")
    fun delete(erpVin: ErpVin, ra: RA): String {
        erpVinService.delete(erpVin)
        addMessage(ra, "删除车架信息成功")
        return "redirect:${Global.getAdminPath()}/erp/erpVin/?repage"
    }

    // ========================================================================================
}