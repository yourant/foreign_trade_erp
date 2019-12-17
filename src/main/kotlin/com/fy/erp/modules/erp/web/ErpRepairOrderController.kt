package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpRepairOrder
import com.fy.erp.modules.erp.entity.ErpVinDTO
import com.fy.erp.modules.erp.service.ErpRepairOrderService

/**
 * 三包订单Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpRepairOrder")
open class ErpRepairOrderController : BC() {

    @A
    lateinit var erpRepairOrderService: ErpRepairOrderService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpRepairOrder {
        return if (isNotBlank(id)) erpRepairOrderService.get(id!!) else ErpRepairOrder()
    }

    @RM("delete")
    @PERM("erp:erpRepairOrder:delete")
    fun delete(erpRepairOrder: ErpRepairOrder, ra: RA): String {
        erpRepairOrderService.delete(erpRepairOrder)
        addMessage(ra, "删除三包订单成功")
        return "redirect:${Global.getAdminPath()}/erp/erpRepairOrder/?repage"
    }

    // ========================================================================================
    @RM(*arrayOf("list", ""))
    @PERM("erp:erpRepairOrder:list")
    fun list(erpRepairOrder: ErpRepairOrder, req: REQ, res: RES, m: M): String {
        val page = erpRepairOrderService.findPage(Page(req, res), erpRepairOrder)
        m.addAttribute("page", page)
        return "modules/repair_order/erpRepairOrderList"
    }

    @RM("form")
    @PERM("erp:erpRepairOrder:form")
    fun form(erpRepairOrder: ErpRepairOrder, m: M): String {
        m.addAttribute("erpRepairOrder", erpRepairOrder)
        return "modules/repair_order/erpRepairOrderForm"
    }

    @RM("view")
    @PERM("erp:erpRepairOrder:view")
    fun view(erpRepairOrder: ErpRepairOrder, m: M): String {
        m.addAttribute("erpRepairOrder", erpRepairOrder)
        m.addAttribute("isForEdit", false)
        return "modules/repair_order/erpRepairOrderView"
    }

    @RM("save")
    @PERM("erp:erpRepairOrder:save")
    fun save(erpRepairOrder: ErpRepairOrder, m: M, ra: RA): String {
        if (!beanValidator(m, erpRepairOrder)) {
            return form(erpRepairOrder, m)
        }
        erpRepairOrderService.saveAndProcess(erpRepairOrder)
        addMessage(ra, "保存三包订单成功")
        return "redirect:${Global.getAdminPath()}/erp/erpRepairOrder/?repage"
    }

    /**
     * 操作员录入维修方法
     */
    @RM("erpRepairMethodForm")
    @PERM("erp:erpRepairOrder:erpRepairMethodForm")
    fun erpRepairMethodForm(erpRepairOrder: ErpRepairOrder, m: M): String {
        m.addAttribute("erpRepairOrder", erpRepairOrder)
        return "modules/repair_order/erpRepairMethodForm"
    }

    /**
     * 操作员录入发货信息表单
     */
    @RM("sendItemForm")
    @PERM("erp:erpRepairOrder:sendItemForm")
    fun sendItemForm(erpRepairOrder: ErpRepairOrder, m: M): String {
        m.addAttribute("erpRepairOrder", erpRepairOrder)
        return "modules/repair_order/erpSendItemsForm"
    }

    /**
     * 查看操作员录入的发货信息
     */
    @RM("sendItemView")
    @PERM("erp:erpRepairOrder:sendItemView")
    fun sendItemView(erpRepairOrder: ErpRepairOrder, m: M): String {
        m.addAttribute("erpRepairOrder", erpRepairOrder)
        return "modules/repair_order/erpSendItemsView"
    }

    /**
     * 根据vinId获取vinDTO的JSON数据
     */
    @RM("findVinDTOById")
    @RB
    fun findVinDTOById(@RP("vinId") vinId: String): ErpVinDTO {
        return erpRepairOrderService.findVinDTOById(vinId)
    }

    /**
     *三包订单流程各节点跳转页面
     */
    @RM("oaForm")
    @PERM("erp:erpRepairOrder:oaForm")
    fun oaForm(erpRepairOrder: ErpRepairOrder, m: M): String {
        val formPath:String = erpRepairOrderService.oaForm(erpRepairOrder)
        m.addAttribute("erpRepairOrder", erpRepairOrder)
        return "modules/repair_order/"+formPath
    }
}