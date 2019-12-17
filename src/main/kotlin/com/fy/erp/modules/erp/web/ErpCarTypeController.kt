package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpCarType
import com.fy.erp.modules.erp.service.ErpCarTypeService

/**
 * 车型Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpCarType")
open class ErpCarTypeController : BC() {

    @A
    lateinit var erpCarTypeService: ErpCarTypeService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpCarType {
        return if (isNotBlank(id)) erpCarTypeService.get(id!!) else ErpCarType()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpCarType:list")
    fun list(erpCarType: ErpCarType, req: REQ, res: RES, m: M): String {
        val page = erpCarTypeService.findPage(Page(req, res), erpCarType)
        m.addAttribute("page", page)
        return "modules/erp/erpCarTypeList"
    }

    @RM("form")
    @PERM("erp:erpCarType:form")
    fun form(erpCarType: ErpCarType, m: M): String {
        m.addAttribute("erpCarType", erpCarType)
        return "modules/erp/erpCarTypeForm"
    }

    @RM("view")
    @PERM("erp:erpCarType:view")
    fun view(erpCarType: ErpCarType, m: M): String {
        m.addAttribute("erpCarType", erpCarType)
        m.addAttribute("isForEdit", false)
        return "modules/erp/erpCarTypeView"
    }

    @RM("save")
    @PERM("erp:erpCarType:save")
    fun save(erpCarType: ErpCarType, m: M, ra: RA): String {
        if (!beanValidator(m, erpCarType)) {
            return form(erpCarType, m)
        }
        erpCarTypeService.save(erpCarType)
        addMessage(ra, "保存车型成功")
        return "redirect:${Global.getAdminPath()}/erp/erpCarType/?repage"
    }

    @RM("delete")
    @PERM("erp:erpCarType:delete")
    fun delete(erpCarType: ErpCarType, ra: RA): String {
        erpCarTypeService.delete(erpCarType)
        addMessage(ra, "删除车型成功")
        return "redirect:${Global.getAdminPath()}/erp/erpCarType/?repage"
    }

    // ========================================================================================
}