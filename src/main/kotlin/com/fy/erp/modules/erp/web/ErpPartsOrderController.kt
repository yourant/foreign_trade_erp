package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpPartsOrder
import com.fy.erp.modules.erp.service.ErpPartsOrderService

/**
 * 配件订单Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpPartsOrder")
open class ErpPartsOrderController : BC() {

    @A
    lateinit var erpPartsOrderService: ErpPartsOrderService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpPartsOrder {
        return if (isNotBlank(id)) erpPartsOrderService.get(id!!) else ErpPartsOrder()
    }

    @RM("delete")
    @PERM("erp:erpPartsOrder:delete")
    fun delete(erpPartsOrder: ErpPartsOrder, ra: RA): String {
        erpPartsOrderService.delete(erpPartsOrder)
        addMessage(ra, "删除配件订单成功")
        return "redirect:${Global.getAdminPath()}/erp/erpPartsOrder/?repage"
    }

    // ========================================================================================

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpPartsOrder:list")
    fun list(erpPartsOrder: ErpPartsOrder, req: REQ, res: RES, m: M): String {
        val page = erpPartsOrderService.findPage(Page(req, res), erpPartsOrder)
        m.addAttribute("page", page)
        return "modules/parts_order/erpPartsOrderList"
    }

    @RM("form")
    @PERM("erp:erpPartsOrder:form")
    fun form(erpPartsOrder: ErpPartsOrder, m: M): String {
        m.addAttribute("erpPartsOrder", erpPartsOrder)
        return "modules/parts_order/erpPartsOrderForm"
    }

    @RM("save")
    @PERM("erp:erpPartsOrder:save")
    fun save(erpPartsOrder: ErpPartsOrder, m: M, ra: RA): String {
        if (!beanValidator(m, erpPartsOrder)) {
            return form(erpPartsOrder, m)
        }
        erpPartsOrderService.saveAndProcess(erpPartsOrder)
        addMessage(ra, "保存配件订单成功")
        return "redirect:${Global.getAdminPath()}/erp/erpPartsOrder/?repage"
    }

    @RM("view")
    @PERM("erp:erpPartsOrder:view")
    fun view(erpPartsOrder: ErpPartsOrder, m: M): String {
        m.addAttribute("erpPartsOrder", erpPartsOrder)
        m.addAttribute("isForEdit", false)
        return "modules/parts_order/erpPartsOrderView"
    }

    /**
     * 操作员录入发货信息表单
     */
    @RM("sendItemForm")
    @PERM("erp:erpPartsOrder:sendItemForm")
    fun sendItemForm(erpPartsOrder: ErpPartsOrder, m: M): String {
        m.addAttribute("erpPartsOrder", erpPartsOrder)
        return "modules/parts_order/erpSendItemsForm"
    }
    /**
     * 查看操作员录入的发货信息
     */
    @RM("sendItemView")
    @PERM("erp:erpPartsOrder:sendItemView")
    fun sendItemView(erpPartsOrder: ErpPartsOrder, m: M): String {
        m.addAttribute("erpPartsOrder", erpPartsOrder)
        return "modules/parts_order/erpSendItemsView"
    }

    /**
     *配件订单流程各节点跳转页面
     */
    @RM("oaForm")
    //@PERM("erp:erpPartsOrder:oaForm")
    fun oaForm(erpPartsOrder: ErpPartsOrder, m: M): String {
        val formPath:String = erpPartsOrderService.oaForm(erpPartsOrder)
        m.addAttribute("erpPartsOrder", erpPartsOrder)
        return "modules/parts_order/"+formPath
    }


}