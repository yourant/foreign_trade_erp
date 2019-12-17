package com.fy.erp.alias

import com.fy.erp.common.web.BaseController
import org.apache.shiro.authz.annotation.RequiresPermissions
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.ModelAttribute
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.web.servlet.mvc.support.RedirectAttributes
import javax.annotation.Resource
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

/**
 * Created by 尹彬 on 2017/10/28.
 */

// 类型别名
typealias C = Controller
typealias BC = BaseController
typealias RP = RequestParam
typealias RA = RedirectAttributes
typealias REQ = HttpServletRequest
typealias RES = HttpServletResponse
typealias MA = ModelAttribute
typealias RM = RequestMapping
typealias M = Model
typealias R = Resource
typealias A = Autowired
typealias RB = ResponseBody
/**
 * 权限
 * RequiresPermissions
 */
typealias PERM = RequiresPermissions

public open class Typealias {
}