/**
 *
 */
package com.fy.erp.modules.sys.web;

import javax.servlet.http.HttpServletRequest;

import com.fy.erp.common.config.Global;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fy.erp.common.web.BaseController;

/**
 * 标签Controller
 *
 * @author ThinkGem
 * @version 2013-3-23
 */
@Controller
@RequestMapping(value = "${adminPath}/tag")
public class TagController extends BaseController {

    /**
     * 树结构选择标签（treeselect.tag）
     */
    @RequiresPermissions("user")
    @RequestMapping(value = "treeselect")
    public String treeselect(HttpServletRequest request, Model model) {
        model.addAttribute("extId", request.getParameter("extId")); // 排除的编号ID
        model.addAttribute("checked", request.getParameter("checked")); // 是否可复选
        model.addAttribute("selectIds", request.getParameter("selectIds")); // 指定默认选中的ID
        model.addAttribute("isAll", request.getParameter("isAll"));    // 是否读取全部数据，不进行权限过滤
        model.addAttribute("module", request.getParameter("module"));    // 过滤栏目模型（仅针对CMS的Category树）

        String viewName = request.getParameter("viewName");
//        if (StringUtils.isNotBlank(viewName)) {// 青岛前途软件 增加自动完成的实现
            model.addAttribute("viewName", viewName);
//            String contextPath = request.getContextPath() + Global.getAdminPath();
//            model.addAttribute("url", "/autoComplete?type=3&viewName=" + viewName);
//        } else {
            model.addAttribute("url", request.getParameter("url"));    // 树结构数据URL
//        }

        return "modules/sys/tagTreeselect";
    }

    /**
     * 图标选择标签（iconselect.tag）
     */
    @RequiresPermissions("user")
    @RequestMapping(value = "iconselect")
    public String iconselect(HttpServletRequest request, Model model) {
        model.addAttribute("value", request.getParameter("value"));
        return "modules/sys/tagIconselect";
    }

}
