package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import com.fy.erp.modules.erp.entity.ErpPayMoney
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpPayType
import com.fy.erp.modules.erp.entity.ErpSalesOrder
import com.fy.erp.modules.erp.service.ErpPayTypeService

/**
 * 支付类型Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpPayType")
open class ErpPayTypeController : BC() {

    @A
    lateinit var erpPayTypeService: ErpPayTypeService

    @MA
    operator fun get(@RP(required = false) id: String?, @RP(required = false) orderId: String?): ErpPayType {
        return if (isNotBlank(id)) erpPayTypeService.get(id!!) else if(isNotBlank(orderId)) ErpPayType(ErpSalesOrder(orderId!!)) else ErpPayType()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpPayType:list")
    fun list(erpPayType: ErpPayType, req: REQ, res: RES, m: M): String {
        val page = erpPayTypeService.findPage(Page(req, res), erpPayType)
        m.addAttribute("page", page)
        return "modules/erp/erpPayTypeList"
    }

    @RM("form")
    @PERM("erp:erpPayType:form")
    fun form(erpPayType: ErpPayType, m: M): String {
        m.addAttribute("erpPayType", erpPayType)
        m.addAttribute("isForm", true)
        m.addAttribute("action", "/erp/erpPayType/save")
        return "modules/erp/erpPayTypeForm"
    }

    @RM("view")
    @PERM("erp:erpPayType:view")
    fun view(erpPayType: ErpPayType, m: M): String {
        m.addAttribute("erpPayType", erpPayType)
        m.addAttribute("isForEdit", false)
        return "modules/erp/erpPayTypeView"
    }

    @RM("save")
    @PERM("erp:erpPayType:save")
    fun save(erpPayType: ErpPayType, m: M, ra: RA): String {
        if (!beanValidator(m, erpPayType)) {
            return form(erpPayType, m)
        }
        erpPayTypeService.save(erpPayType)
        addMessage(ra, "保存支付类型成功")
        return "redirect:${Global.getAdminPath()}/erp/erpPayType/?repage"
    }

    @RM("delete")
    @PERM("erp:erpPayType:delete")
    fun delete(erpPayType: ErpPayType, ra: RA): String {
        erpPayTypeService.delete(erpPayType)
        addMessage(ra, "删除支付类型成功")
        return "redirect:${Global.getAdminPath()}/erp/erpPayType/?repage"
    }

    // ========================================================================================

    @RM("childForm")
    @PERM("erp:erpPayType:form")
    fun childForm(erpPayType: ErpPayType, m: M): String {
        m.addAttribute("erpPayType", erpPayType)
        m.addAttribute("action", "/erp/erpPayType/childSave")
        return "modules/erp/erpPayTypeForm"
    }

    @RM("childSave")
    @PERM("erp:erpPayType:save")
    fun childSave(erpPayType: ErpPayType, m: M, ra: RA): String {
        if (!beanValidator(m, erpPayType)) {
            return childForm(erpPayType, m)
        }
        erpPayTypeService.save(erpPayType)
        m.addAttribute("messages", "保存支付类型成功")
        return "include/success"
    }

}