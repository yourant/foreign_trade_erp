package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpPayMoney
import com.fy.erp.modules.erp.service.ErpPayMoneyService

/**
 * 支付金额Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpPayMoney")
open class ErpPayMoneyController : BC() {

    @A
    lateinit var erpPayMoneyService: ErpPayMoneyService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpPayMoney {
        return if (isNotBlank(id)) erpPayMoneyService.get(id!!) else ErpPayMoney()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpPayMoney:list")
    fun list(erpPayMoney: ErpPayMoney, req: REQ, res: RES, m: M): String {
        val page = erpPayMoneyService.findPage(Page(req, res), erpPayMoney)
        m.addAttribute("page", page)
        return "modules/erp/erpPayMoneyList"
    }

    @RM("form")
    @PERM("erp:erpPayMoney:form")
    fun form(erpPayMoney: ErpPayMoney, m: M): String {
        m.addAttribute("erpPayMoney", erpPayMoney)
        return "modules/erp/erpPayMoneyForm"
    }

    @RM("view")
    @PERM("erp:erpPayMoney:view")
    fun view(erpPayMoney: ErpPayMoney, m: M): String {
        m.addAttribute("erpPayMoney", erpPayMoney)
        m.addAttribute("isForEdit", false)
        return "modules/erp/erpPayMoneyView"
    }

    @RM("save")
    @PERM("erp:erpPayMoney:save")
    fun save(erpPayMoney: ErpPayMoney, m: M, ra: RA): String {
        if (!beanValidator(m, erpPayMoney)) {
            return form(erpPayMoney, m)
        }
        erpPayMoneyService.save(erpPayMoney)
        addMessage(ra, "保存支付金额成功")
        return "redirect:${Global.getAdminPath()}/erp/erpPayMoney/?repage"
    }

    @RM("delete")
    @PERM("erp:erpPayMoney:delete")
    fun delete(erpPayMoney: ErpPayMoney, ra: RA): String {
        erpPayMoneyService.delete(erpPayMoney)
        addMessage(ra, "删除支付金额成功")
        return "redirect:${Global.getAdminPath()}/erp/erpPayMoney/?repage"
    }

    // ========================================================================================

    @RM("savePayMoney")
    @RB
    @PERM("erp:erpPayMoney:save")
    fun savePayMoney(erpPayMoney: ErpPayMoney): String {
        erpPayMoneyService.save(erpPayMoney)
        return "保存支付金额成功"
    }
}