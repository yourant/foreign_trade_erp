package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpProductionOrder
import com.fy.erp.modules.erp.entity.ErpSalesOrder
import com.fy.erp.modules.erp.service.ErpProductionOrderService

/**
 * 生产订单Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpProductionOrder")
open class ErpProductionOrderController : BC() {

    @A
    lateinit var erpProductionOrderService: ErpProductionOrderService

    @MA
    operator fun get(@RP(required = false) id: String?, @RP(required = false) orderId: String?): ErpProductionOrder {
        return if (isNotBlank(id)) erpProductionOrderService.get(id!!) else if(isNotBlank(orderId)) ErpProductionOrder(ErpSalesOrder(orderId!!)) else ErpProductionOrder()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpProductionOrder:list")
    fun list(erpProductionOrder: ErpProductionOrder, req: REQ, res: RES, m: M): String {
        val page = erpProductionOrderService.findPage(Page(req, res), erpProductionOrder)
        m.addAttribute("page", page)
        return "modules/erp/erpProductionOrderList"
    }

    @RM("form")
    @PERM("erp:erpProductionOrder:form")
    fun form(erpProductionOrder: ErpProductionOrder, m: M): String {
        m.addAttribute("erpProductionOrder", erpProductionOrder)
        m.addAttribute("isForm", true)
        m.addAttribute("action", "/erp/erpProductionOrder/save")
        return "modules/erp/erpProductionOrderForm"
    }

    @RM("view")
    @PERM("erp:erpProductionOrder:view")
    fun view(erpProductionOrder: ErpProductionOrder, m: M): String {
        m.addAttribute("erpProductionOrder", erpProductionOrder)
        m.addAttribute("isForEdit", false)
        return "modules/erp/erpProductionOrderView"
    }

    @RM("save")
    @PERM("erp:erpProductionOrder:save")
    fun save(erpProductionOrder: ErpProductionOrder, m: M, ra: RA): String {
        if (!beanValidator(m, erpProductionOrder)) {
            return form(erpProductionOrder, m)
        }
        erpProductionOrderService.save(erpProductionOrder)
        addMessage(ra, "保存生产订单成功")
        return "redirect:${Global.getAdminPath()}/erp/erpProductionOrder/?repage"
    }

    @RM("delete")
    @PERM("erp:erpProductionOrder:delete")
    fun delete(erpProductionOrder: ErpProductionOrder, ra: RA): String {
        erpProductionOrderService.delete(erpProductionOrder)
        addMessage(ra, "删除生产订单成功")
        return "redirect:${Global.getAdminPath()}/erp/erpProductionOrder/?repage"
    }

    // ========================================================================================

    @RM("childForm")
    @PERM("erp:erpProductionOrder:form")
    fun childForm(erpProductionOrder: ErpProductionOrder, m: M): String {
        m.addAttribute("erpProductionOrder", erpProductionOrder)
        m.addAttribute("action", "/erp/erpProductionOrder/childSave")
        return "modules/erp/erpProductionOrderForm"
    }

    @RM("childView")
    @PERM("erp:erpProductionOrder:form")
    fun childView(erpProductionOrder: ErpProductionOrder, m: M): String {
        m.addAttribute("erpProductionOrder", erpProductionOrder)
        m.addAttribute("action", "/erp/erpProductionOrder/childSave")
        return "modules/erp/erpProductionOrderForm2"
    }

    @RM("childSave")
    @PERM("erp:erpProductionOrder:save")
    fun childSave(erpProductionOrder: ErpProductionOrder, m: M, ra: RA): String {
        if (!beanValidator(m, erpProductionOrder)) {
            return childForm(erpProductionOrder, m)
        }
        erpProductionOrderService.save(erpProductionOrder)
        m.addAttribute("messages", "保存生产订单成功")
        return "include/success"
    }
}