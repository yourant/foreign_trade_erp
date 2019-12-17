package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpShipments
import com.fy.erp.modules.erp.service.ErpProductionItemsService
import com.fy.erp.modules.erp.service.ErpShipmentsService

/**
 * ErpShipmentsController
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpShipments")
open class ErpShipmentsController : BC() {

    @A
    lateinit var erpShipmentsService: ErpShipmentsService

    @A
    lateinit var erpProductionItemsService: ErpProductionItemsService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpShipments {
        return if (isNotBlank(id)) erpShipmentsService.get(id!!) else ErpShipments()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpShipments:list")
    fun list(erpShipments: ErpShipments, req: REQ, res: RES, m: M): String {
        val page = erpShipmentsService.findPage(Page(req, res), erpShipments)
        m.addAttribute("page", page)
        return "modules/erp/erpShipmentsList"
    }

    @RM("form")
    @PERM("erp:erpShipments:form")
    fun form(erpShipments: ErpShipments, m: M): String {
        m.addAttribute("erpShipments", erpShipments)
        return "modules/erp/erpShipmentsForm"
    }

    @RM("view")
    @PERM("erp:erpShipments:view")
    fun view(erpShipments: ErpShipments, m: M): String {
        m.addAttribute("erpShipments", erpShipments)
        m.addAttribute("isForEdit", false)
        return "modules/erp/erpShipmentsView"
    }

    @RM("save")
    @PERM("erp:erpShipments:save")
    fun save(erpShipments: ErpShipments, @RP(required = true)salesOrderId: String, m: M, ra: RA): String {
        if (!beanValidator(m, erpShipments)) {
            return form(erpShipments, m)
        }
        erpShipmentsService.saveAndProcess(erpShipments,salesOrderId)
        addMessage(ra, "保存发货单成功")
        return "redirect:${Global.getAdminPath()}/erp/erpSalesOrder/?repage"
    }


    @RM("delete")
    @PERM("erp:erpShipments:delete")
    fun delete(erpShipments: ErpShipments, ra: RA): String {
        erpShipmentsService.delete(erpShipments)
        addMessage(ra, "删除发货单成功")
        return "redirect:${Global.getAdminPath()}/erp/erpShipments/?repage"
    }

    // ========================================================================================

    /**
     *
     */
    @RM("shipmentForm")
    @PERM("erp:erpSalesOrder:shipmentForm")
    fun shipmentForm(erpShipments: ErpShipments, @RP(required = true)salesOrderId: String, m: M): String {
        val boxList = erpProductionItemsService.findBoxList(salesOrderId)
        val newErpShipments = erpShipmentsService.findShipmentsBySalesOrderId(salesOrderId)
        m.addAttribute("erpShipments", newErpShipments)
        m.addAttribute("salesOrderId", salesOrderId)
        m.addAttribute("boxList", boxList)
        return "modules/sales_order/czy/erpShipmentsForm"
    }

    /**
     *
     */
    @RM("shipmentProcessForm")
    @PERM("erp:erpSalesOrder:shipmentForm")
    fun shipmentProcessForm(erpShipments: ErpShipments, m: M): String {

        // 流程实例中获取businessId
        val act = erpShipments.act
        val salesOrderId = act.businessId

        // 装箱信息（生产订单明细、车架号、集装箱）
        val boxList = erpProductionItemsService.findBoxList(salesOrderId)

        val newErpShipments = erpShipmentsService.findShipmentsBySalesOrderId(salesOrderId)
        newErpShipments.act = act

        m.addAttribute("salesOrderId", salesOrderId)
        m.addAttribute("boxList", boxList)
        m.addAttribute("erpShipments", newErpShipments)
        return "modules/sales_order/czy/erpShipmentsForm"
    }

    @RM("shipmentView")
    @PERM("erp:erpSalesOrder:tableShipment")
    fun shipmentView(erpShipments: ErpShipments, @RP(required = true)salesOrderId: String, m: M): String {
        val boxList = erpProductionItemsService.findBoxList(salesOrderId)
        val newErpShipments = erpShipmentsService.findShipmentsBySalesOrderId(salesOrderId)
        m.addAttribute("erpShipments", newErpShipments)
        m.addAttribute("salesOrderId", salesOrderId)
        m.addAttribute("boxList", boxList)
        return "modules/sales_order/czy/erpShipmentsView"
    }

}