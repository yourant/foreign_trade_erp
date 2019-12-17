package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpProductionItems
import com.fy.erp.modules.erp.entity.ErpProductionOrder
import com.fy.erp.modules.erp.entity.ErpSalesOrder
import com.fy.erp.modules.erp.entity.ErpShipments
import com.fy.erp.modules.erp.service.ErpProductionItemsService

/**
 * 生产明细Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpProductionItems")
open class ErpProductionItemsController : BC() {

    @A
    lateinit var erpProductionItemsService: ErpProductionItemsService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpProductionItems {
        return if (isNotBlank(id)) erpProductionItemsService.get(id!!)  else ErpProductionItems()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpProductionItems:list")
    fun list(erpProductionItems: ErpProductionItems, req: REQ, res: RES, m: M): String {
        val page = erpProductionItemsService.findPage(Page(req, res), erpProductionItems)
        m.addAttribute("page", page)
        return "modules/erp/erpProductionItemsList"
    }

    @RM("form")
    @PERM("erp:erpProductionItems:form")
    fun form(erpProductionItems: ErpProductionItems, m: M): String {
        m.addAttribute("erpProductionItems", erpProductionItems)
        return "modules/erp/erpProductionItemsForm"
    }

    @RM("view")
    @PERM("erp:erpProductionItems:view")
    fun view(erpProductionItems: ErpProductionItems, m: M): String {
        m.addAttribute("erpProductionItems", erpProductionItems)
        m.addAttribute("isForEdit", false)
        return "modules/erp/erpProductionItemsView"
    }

    @RM("save")
    @PERM("erp:erpProductionItems:save")
    fun save(erpProductionItems: ErpProductionItems, m: M, ra: RA): String {
        if (!beanValidator(m, erpProductionItems)) {
            return form(erpProductionItems, m)
        }
        erpProductionItemsService.save(erpProductionItems)
        addMessage(ra, "保存生产明细成功")
        return "redirect:${Global.getAdminPath()}/erp/erpProductionItems/?repage"
    }

    @RM("delete")
    @PERM("erp:erpProductionItems:delete")
    fun delete(erpProductionItems: ErpProductionItems, ra: RA): String {
        erpProductionItemsService.delete(erpProductionItems)
        addMessage(ra, "删除生产明细成功")
        return "redirect:${Global.getAdminPath()}/erp/erpProductionItems/?repage"
    }

    // ========================================================================================

}