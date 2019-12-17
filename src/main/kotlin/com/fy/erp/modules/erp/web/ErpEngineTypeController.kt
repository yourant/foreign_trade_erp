package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpEngineType
import com.fy.erp.modules.erp.service.ErpEngineTypeService

/**
 * 发动机型号Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpEngineType")
open class ErpEngineTypeController : BC() {

    @A
    lateinit var erpEngineTypeService: ErpEngineTypeService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpEngineType {
        return if (isNotBlank(id)) erpEngineTypeService.get(id!!) else ErpEngineType()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpEngineType:list")
    fun list(erpEngineType: ErpEngineType, req: REQ, res: RES, m: M): String {
        val page = erpEngineTypeService.findPage(Page(req, res), erpEngineType)
        m.addAttribute("page", page)
        return "modules/erp/erpEngineTypeList"
    }

    @RM("form")
    @PERM("erp:erpEngineType:form")
    fun form(erpEngineType: ErpEngineType, m: M): String {
        m.addAttribute("erpEngineType", erpEngineType)
        return "modules/erp/erpEngineTypeForm"
    }

    @RM("view")
    @PERM("erp:erpEngineType:view")
    fun view(erpEngineType: ErpEngineType, m: M): String {
        m.addAttribute("erpEngineType", erpEngineType)
        m.addAttribute("isForEdit", false)
        return "modules/erp/erpEngineTypeView"
    }

    @RM("save")
    @PERM("erp:erpEngineType:save")
    fun save(erpEngineType: ErpEngineType, m: M, ra: RA): String {
        if (!beanValidator(m, erpEngineType)) {
            return form(erpEngineType, m)
        }
        erpEngineTypeService.save(erpEngineType)
        addMessage(ra, "保存发动机型号成功")
        return "redirect:${Global.getAdminPath()}/erp/erpEngineType/?repage"
    }

    @RM("delete")
    @PERM("erp:erpEngineType:delete")
    fun delete(erpEngineType: ErpEngineType, ra: RA): String {
        erpEngineTypeService.delete(erpEngineType)
        addMessage(ra, "删除发动机型号成功")
        return "redirect:${Global.getAdminPath()}/erp/erpEngineType/?repage"
    }

    // ========================================================================================
}