package com.fy.erp.common.utils;

import org.jxls.area.XlsArea;
import org.jxls.command.EachCommand;
import org.jxls.common.CellRef;
import org.jxls.common.Context;
import org.jxls.expression.JexlExpressionEvaluator;
import org.jxls.transform.Transformer;
import org.jxls.util.JxlsHelper;
import org.jxls.util.TransformerFactory;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * @author 尹彬
 */
public class ExportXlsUtil {

    private static final String TEMPLATE_PATH = "xls-template";

    public static void exportExcel(InputStream is, OutputStream os, Map<String, Object> model) throws IOException {
        Context context = new Context();
        if (model != null) {
            for (String key : model.keySet()) {
                context.putVar(key, model.get(key));
            }
        }
        JxlsHelper jxlsHelper = JxlsHelper.getInstance();
        Transformer transformer = jxlsHelper.createTransformer(is, os);

        JexlExpressionEvaluator evaluator = (JexlExpressionEvaluator) transformer.getTransformationConfig().getExpressionEvaluator();
        Map<String, Object> funcs = new HashMap<String, Object>();
        funcs.put("utils", new ExportXlsUtil());    //添加自定义功能
        evaluator.getJexlEngine().setFunctions(funcs);

        jxlsHelper.processTemplate(context, transformer);
    }

    public static void exportExcel2(InputStream is, OutputStream os, Map<String, Object> model) throws IOException {
        Context context = new Context();
        if (model != null) {
            for (String key : model.keySet()) {
                context.putVar(key, model.get(key));
            }
        }

        Transformer transformer = TransformerFactory.createTransformer(is, os);
        XlsArea xlsArea = new XlsArea("Template!A1:D4", transformer);
        XlsArea employeeArea = new XlsArea("Template!A4:D4", transformer);
        EachCommand employeeEachCommand = new EachCommand("employee", "employees", employeeArea);
        xlsArea.addCommand("A4:D4", employeeEachCommand);
        xlsArea.applyAt(new CellRef("Result!A1"), context);
        transformer.write();
    }

    public static void exportExcel(File xls, File out, Map<String, Object> model) throws FileNotFoundException, IOException {
        exportExcel(new FileInputStream(xls), new FileOutputStream(out), model);
    }

    public static void exportExcel(String templateName, OutputStream os, Map<String, Object> model) throws FileNotFoundException, IOException {
        File template = getTemplate(templateName);
        if (template != null) {
            exportExcel(new FileInputStream(template), os, model);
        }
    }


    //获取jxls模版文件

    public static File getTemplate(String name) {
        String templatePath = ExportXlsUtil.class.getClassLoader().getResource(TEMPLATE_PATH).getPath();
        File template = new File(templatePath, name);
        if (template.exists()) {
            return template;
        }
        return null;
    }

    // 日期格式化
    public String dateFmt(Date date, String fmt) {
        if (date == null) {
            return "";
        }
        try {
            SimpleDateFormat dateFmt = new SimpleDateFormat(fmt);
            return dateFmt.format(date);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    // if判断
    public Object ifelse(boolean b, Object o1, Object o2) {
        return b ? o1 : o2;
    }

}
