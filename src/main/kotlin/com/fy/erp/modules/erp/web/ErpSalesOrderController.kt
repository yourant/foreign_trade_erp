package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import com.fy.erp.modules.act.service.ActTaskService
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpSalesOrder
import com.fy.erp.modules.erp.entity.ErpShipments
import com.fy.erp.modules.erp.service.ErpProductionItemsService
import com.fy.erp.modules.erp.service.ErpSalesOrderService
import org.springframework.beans.factory.annotation.Autowired

/**
 * 销售订单Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpSalesOrder")
open class ErpSalesOrderController : BC() {

    @A
    lateinit var erpSalesOrderService: ErpSalesOrderService

    @A
    lateinit var erpProductionItemsService: ErpProductionItemsService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpSalesOrder {
        return if (isNotBlank(id)) erpSalesOrderService.get(id!!) else ErpSalesOrder()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpSalesOrder:list")
    fun list(erpSalesOrder: ErpSalesOrder, req: REQ, res: RES, m: M): String {
        val page = erpSalesOrderService.findPage(Page(req, res), erpSalesOrder)
        m.addAttribute("page", page)
        return "modules/sales_order/erpSalesOrderList"
    }


    @RM("delete")
    @PERM("erp:erpSalesOrder:delete")
    fun delete(erpSalesOrder: ErpSalesOrder, ra: RA): String {
        erpSalesOrderService.delete(erpSalesOrder)
        addMessage(ra, "删除销售订单成功")
        return "redirect:${Global.getAdminPath()}/erp/erpSalesOrder/?repage"
    }

    // ========================================================================================

    @RM("save")
    @PERM("erp:erpSalesOrder:save")
    fun save(erpSalesOrder: ErpSalesOrder, m: M, ra: RA): String {
        if (!beanValidator(m, erpSalesOrder)) {
            return form(erpSalesOrder, m)
        }
        return if (erpSalesOrder.isSavePiFile) {
            erpSalesOrderService.save(erpSalesOrder)
            addMessage(ra, "附件保存成功")
            return "include/success"
        } else {
            erpSalesOrderService.saveAndProcess(erpSalesOrder)
            addMessage(ra, "保存销售订单成功")
            "redirect:${Global.getAdminPath()}/erp/erpSalesOrder/?repage"
        }
    }

    @RM("form")
    @PERM("erp:erpSalesOrder:form")
    fun form(erpSalesOrder: ErpSalesOrder, m: M): String {
        m.addAttribute("erpSalesOrder", erpSalesOrder)
        return "modules/sales_order/ywy/erpSalesOrderForm"
    }

    @RM("view")
    @PERM("erp:erpSalesOrder:view")
    fun view(erpSalesOrder: ErpSalesOrder, m: M): String {
        m.addAttribute("erpSalesOrder", erpSalesOrder)
        m.addAttribute("isForEdit", false)
        return "modules/sales_order/ywy/erpSalesOrderView"
    }

    /**
     *新建整机销售
     */
    @RM("oaForm")
    @PERM("erp:erpSalesOrder:oaForm")
    fun oaForm(erpSalesOrder: ErpSalesOrder, m: M): String {
        val formPath: String = erpSalesOrderService.oaForm(erpSalesOrder)
        m.addAttribute("erpSalesOrder", erpSalesOrder)
        return "modules/sales_order/" + formPath
    }

    /**
     *新建生产订单
     */
    @RM("addProductionOrder")
    @PERM("erp:erpSalesOrder:addProductionOrder")
    fun addProductionOrder(erpSalesOrder: ErpSalesOrder, m: M): String {
        m.addAttribute("erpSalesOrder", erpSalesOrder)
        return "modules/sales_order/czy/erpProductionOrderForm"
    }

    /**
     *新建生产计划
     */
    @RM("addProductionPlain")
    @PERM("erp:erpSalesOrder:addProductionPlain")
    fun addProductionPlain(erpSalesOrder: ErpSalesOrder, m: M): String {
        m.addAttribute("erpSalesOrder", erpSalesOrder)
        return "modules/sales_order/czy/erpProductionPlainForm"
    }

    /**
     *录入款项信息
     */
    @RM("addPayType")
    @PERM("erp:erpSalesOrder:addPayType")
    fun addPayType(erpSalesOrder: ErpSalesOrder, m: M): String {
        m.addAttribute("erpSalesOrder", erpSalesOrder)
        return "modules/sales_order/kj/erpPaymentForm"
    }

    /**
     *结算工资
     */
    @RM("settlementWageForm")
    @PERM("erp:erpSalesOrder:settlementWageForm")
    fun settlementWageForm(erpSalesOrder: ErpSalesOrder, m: M): String {
        m.addAttribute("erpSalesOrder", erpSalesOrder)
        return "modules/sales_order/kj/erpCommissionForm"
    }

    /**
     *查看结算工资
     */
    @RM("settlementWageView")
    @PERM("erp:erpSalesOrder:tableSettlementWage")
    fun settlementWageView(erpSalesOrder: ErpSalesOrder, m: M): String {
        m.addAttribute("erpSalesOrder", erpSalesOrder)
        return "modules/sales_order/kj/erpCommissionView"
    }

    /**
     *查看录入款项信息
     */
    @RM("showPayType")
    @PERM("erp:erpSalesOrder:tablePayType")
    fun showPayType(erpSalesOrder: ErpSalesOrder, m: M): String {
        m.addAttribute("erpSalesOrder", erpSalesOrder)
        return "modules/sales_order/kj/erpPaymentView"
    }

    /**
     *查看生产订单
     */
    @RM("showProductionOrder")
    @PERM("erp:erpSalesOrder:tableProductionOrder")
    fun showProductionOrder(erpSalesOrder: ErpSalesOrder, m: M): String {
        m.addAttribute("erpSalesOrder", erpSalesOrder)
        return "modules/sales_order/czy/erpProductionOrderView"
    }

    /**
     *查看生产计划
     */
    @RM("showProductionPlain")
    @PERM("erp:erpSalesOrder:tableProductionPlain")
    fun showProductionPlain(erpSalesOrder: ErpSalesOrder, m: M): String {
        m.addAttribute("erpSalesOrder", erpSalesOrder)
        return "modules/sales_order/czy/erpProductionPlainView"
    }

}