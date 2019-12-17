package com.fy.erp.tools;

import com.fy.erp.BaseJunit;
import com.fy.erp.common.utils.FileUtils;
import com.fy.erp.modules.sys.dao.MenuDao;
import com.fy.erp.modules.sys.entity.Menu;
import com.fy.erp.modules.sys.service.SystemService;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import javax.annotation.Resource;
import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by 尹彬 on 2017/11/6.
 */
public class GenMenuSql extends BaseJunit {

    private static String webControllerPath = "/Users/fy/workspace/project/erp/erp/src/main/kotlin/com/fy/erp/modules/erp/web";

//    @Resource
//    private SystemService systemService;
//    @Resource
//    private MenuDao menuDao;

    @Test
    public void insertGenMenu() throws IOException {

        Collection<File> files = FileUtils.listFiles(new File(webControllerPath), new String[]{"kt"}, false);

//        List<Menu> allMenu = menuDao.findAllList(new Menu());

        for (File file : files) {
            String code = FileUtils.readFileToString(file);

//            解析模块名称
            Pattern ppp = Pattern.compile("\\* (.*?)Controller");
            Matcher mmm = ppp.matcher(code);
            StringBuffer sbbb = new StringBuffer();
            while (mmm.find()) {
                sbbb.append(mmm.group(1)).append("管理");
            }


//            解析请求地址
            Pattern pp = Pattern.compile("RM\\(\"\\\\\\$\\{adminPath\\}(.*?)\"\\)");
            Matcher mm = pp.matcher(code);
            StringBuffer sbb = new StringBuffer();
            while (mm.find()) {
                sbb.append(mm.group(1));
            }


//            解析权限
            Pattern p = Pattern.compile("PERM\\(\"(.*?)\"\\)");
            Matcher m = p.matcher(code);
            StringBuffer sb = new StringBuffer();
            String permOne = "";
            while (m.find()) {
                permOne = m.group(1);
                sb.append(permOne);
                sb.append(",");
            }
            String editPerm = permOne.substring(0, permOne.lastIndexOf(":")) + ":edit";
            sb.append(editPerm);

//            StringBuffer perm = sb.deleteCharAt(sb.lastIndexOf(","));
            String menuName = sbbb.toString();
            String url = sbb.toString();
            String perm = sb.toString();


            System.out.println(menuName);
            System.out.println(url);
            System.out.println(perm);
            System.out.println();


            /*
//            自动修改数据库
            for (Menu menu : allMenu) {
                String parentIds = menu.getParentIds();
                String name = menu.getName();

//                从数据库中复制出parentsid的值作为比较字符 ---- 注意：这里必须要修改，非常重要
                String dbParentIds = "0,1,5d8456a10da84d508fd0a2267609fa2a,";
                if (dbParentIds.equals(parentIds) && menuName.equals(name)) {
                    menu.setHref(url);
                    menu.setPermission(perm);
                    System.out.println(menu.getPermission());
                    System.out.println(perm);
                    System.out.println();
//                    systemService.saveMenu(menu);
                } else {
                    menu.setParentIds(dbParentIds);
                    menu.setHref(url);
                    menu.setPermission(perm);
                    menu.setIsShow("1");
                    systemService.saveMenu(menu);
                }

            }
*/
        }


    }


}
