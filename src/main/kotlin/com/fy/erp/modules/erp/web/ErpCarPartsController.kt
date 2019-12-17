package com.fy.erp.modules.erp.web

import com.fy.erp.alias.*
import com.fy.erp.common.config.Global
import com.fy.erp.common.persistence.Page
import com.fy.erp.common.utils.DateUtils
import org.apache.commons.lang3.StringUtils.*
import com.fy.erp.modules.erp.entity.ErpCarParts
import com.fy.erp.modules.erp.entity.ErpCarType
import com.fy.erp.modules.erp.entity.ErpEngineType
import com.fy.erp.modules.erp.service.ErpCarPartsService
import org.springframework.util.FileCopyUtils
import org.springframework.web.util.UriUtils
import java.io.File
import java.io.FileInputStream
import java.io.FileNotFoundException
import java.io.UnsupportedEncodingException

/**
 * 配件Controller
 * @author 尹彬
 * @version 2017-11-06
 */
@C
@RM("\${adminPath}/erp/erpCarParts")
open class ErpCarPartsController : BC() {

    @A
    lateinit var erpCarPartsService: ErpCarPartsService

    @MA
    operator fun get(@RP(required = false) id: String?): ErpCarParts {
        return if (isNotBlank(id)) erpCarPartsService.get(id!!) else ErpCarParts()
    }

    @RM(*arrayOf("list", ""))
    @PERM("erp:erpCarParts:list")
    fun list(erpCarParts: ErpCarParts, req: REQ, res: RES, m: M): String {
        val page = erpCarPartsService.findPage(Page(req, res), erpCarParts)
        m.addAttribute("page", page)
        return "modules/erp/erpCarPartsList"
    }

    @RM("form")
    @PERM("erp:erpCarParts:form")
    fun form(erpCarParts: ErpCarParts, m: M): String {
        m.addAttribute("erpCarParts", erpCarParts)
        return "modules/erp/erpCarPartsForm"
    }

    @RM("view")
    @PERM("erp:erpCarParts:view")
    fun view(erpCarParts: ErpCarParts, m: M): String {
        m.addAttribute("erpCarParts", erpCarParts)
        m.addAttribute("isForEdit", false)
        return "modules/erp/erpCarPartsView"
    }

    @RM("save")
    @PERM("erp:erpCarParts:save")
    fun save(erpCarParts: ErpCarParts, m: M, ra: RA): String {
        if (!beanValidator(m, erpCarParts)) {
            return form(erpCarParts, m)
        }
        erpCarPartsService.save(erpCarParts)
        addMessage(ra, "保存配件成功")
        return "redirect:${Global.getAdminPath()}/erp/erpCarParts/?repage"
    }

    @RM("delete")
    @PERM("erp:erpCarParts:delete")
    fun delete(erpCarParts: ErpCarParts, ra: RA): String {
        erpCarPartsService.delete(erpCarParts)
        addMessage(ra, "删除配件成功")
        return "redirect:${Global.getAdminPath()}/erp/erpCarParts/?repage"
    }

    // ========================================================================================

    /**
     * 根据车型ID和发动机ID查询出所有相关的配件
     */
    @RM("findListByCarIdAndEngineId")
    @RB
    fun findListByCarIdAndEngineId(@RP("carId") carId: String,@RP("engineId") engineId: String): List<ErpCarParts> {
        val erpCarParts = ErpCarParts()
        erpCarParts.erpCarType = ErpCarType(carId)
        erpCarParts.erpEngineType = ErpEngineType(engineId)
        return erpCarPartsService.findList(erpCarParts)
    }

    @RM(*arrayOf("partsList"))
    @PERM("erp:erpCarParts:list")
    fun partsList(@RP("partsOrderId") partsOrderId: String,erpCarParts: ErpCarParts, req: REQ, res: RES, m: M): String {
        val list = erpCarPartsService.findCarPartsList(erpCarParts,partsOrderId)
        m.addAttribute("list", list)
        m.addAttribute("partsOrderId", partsOrderId)
        return "modules/parts_order/erpCarPartsList"
    }


    /**
     * 配件导出
     */
    @RM(*arrayOf("exportXls"))
    @PERM("erp:erpCarParts:exportXls")
    fun exportXls(erpCarParts: ErpCarParts, req: REQ, res: RES, m: M) {
        val date = DateUtils.getDate()
        val filename = "配件数据-$date.xlsx"
        val outputPath = req.session.servletContext.getRealPath("/userfiles/") + File.separator + filename

        erpCarPartsService.exportXls(erpCarParts,outputPath)

        download(req, res, filename)
    }

    /**
     * 下载xlsx文件
     */
    fun download(req: REQ, res: RES, filename: String) {
        var filepath = filename
        val index = filepath.indexOf(Global.USERFILES_BASE_URL)
        if (index >= 0) {
            filepath = filepath.substring(index + Global.USERFILES_BASE_URL.length)
        }
        try {
            filepath = UriUtils.decode(filepath, "UTF-8")
        } catch (e1: UnsupportedEncodingException) {
            logger.error(String.format("解释文件路径失败，URL地址为%s", filepath), e1)
        }

        val file = File(Global.getUserfilesBaseDir() + Global.USERFILES_BASE_URL + filepath)
        try {
            //1.设置文件ContentType类型，这样设置，会自动判断下载文件类型
            res.setContentType("multipart/form-data")
            //2.设置文件头：最后一个参数是设置下载文件名(假如我们叫a.pdf)
            res.setHeader("Content-Disposition", "attachment;fileName=" + filename)

            FileCopyUtils.copy(FileInputStream(file), res.getOutputStream())
            return
        } catch (e: FileNotFoundException) {
            req.setAttribute("exception", FileNotFoundException("请求的文件不存在"))
            req.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(req, res)
        }
    }



}