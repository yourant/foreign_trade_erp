package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpDocker
import com.fy.erp.modules.erp.service.ErpDockerService

/**
 * 集装箱Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpDocker")
open class ErpDockerController : BC() {

    @A
    lateinit var erpDockerService: ErpDockerService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpDocker {
        return if (isNotBlank(id)) erpDockerService.get(id!!) else ErpDocker()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpDocker:list")
    fun list(erpDocker: ErpDocker, req: REQ, res: RES, m: M): String {
        val page = erpDockerService.findPage(Page(req, res), erpDocker)
        m.addAttribute("page", page)
        return "modules/erp/erpDockerList"
    }

    @RM("form")
    @PERM("erp:erpDocker:form")
    fun form(erpDocker: ErpDocker, m: M): String {
        m.addAttribute("erpDocker", erpDocker)
        return "modules/erp/erpDockerForm"
    }

    @RM("view")
    @PERM("erp:erpDocker:view")
    fun view(erpDocker: ErpDocker, m: M): String {
        m.addAttribute("erpDocker", erpDocker)
        m.addAttribute("isForEdit", false)
        return "modules/erp/erpDockerView"
    }

    @RM("save")
    @PERM("erp:erpDocker:save")
    fun save(erpDocker: ErpDocker, m: M, ra: RA): String {
        if (!beanValidator(m, erpDocker)) {
            return form(erpDocker, m)
        }
        erpDockerService.save(erpDocker)
        addMessage(ra, "保存集装箱成功")
        return "redirect:${Global.getAdminPath()}/erp/erpDocker/?repage"
    }

    @RM("delete")
    @PERM("erp:erpDocker:delete")
    fun delete(erpDocker: ErpDocker, ra: RA): String {
        erpDockerService.delete(erpDocker)
        addMessage(ra, "删除集装箱成功")
        return "redirect:${Global.getAdminPath()}/erp/erpDocker/?repage"
    }

    // ========================================================================================
}