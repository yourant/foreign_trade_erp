package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpSendItems
import com.fy.erp.modules.erp.service.ErpSendItemsService

/**
 * 发货明细Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpSendItems")
open class ErpSendItemsController : BC() {

    @A
    lateinit var erpSendItemsService: ErpSendItemsService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpSendItems {
        return if (isNotBlank(id)) erpSendItemsService.get(id!!) else ErpSendItems()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpSendItems:list")
    fun list(erpSendItems: ErpSendItems, req: REQ, res: RES, m: M): String {
        val page = erpSendItemsService.findPage(Page(req, res), erpSendItems)
        m.addAttribute("page", page)
        return "modules/erp/erpSendItemsList"
    }

    @RM("form")
    @PERM("erp:erpSendItems:form")
    fun form(erpSendItems: ErpSendItems, m: M): String {
        m.addAttribute("erpSendItems", erpSendItems)
        return "modules/erp/erpSendItemsForm"
    }

    @RM("view")
    @PERM("erp:erpSendItems:view")
    fun view(erpSendItems: ErpSendItems, m: M): String {
        m.addAttribute("erpSendItems", erpSendItems)
        m.addAttribute("isForEdit", false)
        return "modules/erp/erpSendItemsView"
    }

    @RM("save")
    @PERM("erp:erpSendItems:save")
    fun save(erpSendItems: ErpSendItems, m: M, ra: RA): String {
        if (!beanValidator(m, erpSendItems)) {
            return form(erpSendItems, m)
        }
        erpSendItemsService.save(erpSendItems)
        addMessage(ra, "保存发货明细成功")
        return "redirect:${Global.getAdminPath()}/erp/erpSendItems/?repage"
    }

    @RM("delete")
    @PERM("erp:erpSendItems:delete")
    fun delete(erpSendItems: ErpSendItems, ra: RA): String {
        erpSendItemsService.delete(erpSendItems)
        addMessage(ra, "删除发货明细成功")
        return "redirect:${Global.getAdminPath()}/erp/erpSendItems/?repage"
    }

    // ========================================================================================

    /**
     * 添加发货信息
     */
    @RM("addParts")
    @RB
            //@PERM("erp:erpSendItems:sendItemForm")
    fun addParts(@RP("partsIds") partsIds: String,@RP("partsOrderId")partsOrderId: String, m: M): Int {
        return erpSendItemsService.addParts(partsIds,partsOrderId)
    }
}