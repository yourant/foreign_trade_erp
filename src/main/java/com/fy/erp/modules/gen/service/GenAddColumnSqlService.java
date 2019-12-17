/**
 *
 */
package com.fy.erp.modules.gen.service;

import com.fy.erp.common.service.BaseService;
import com.fy.erp.modules.gen.dao.GenAddColumnSqlDao;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

/**
 * @author 青岛前途软件
 * @version 2017-10-24
 */
@Service
@Transactional(readOnly = true)
public class GenAddColumnSqlService extends BaseService {

    @Resource
    private GenAddColumnSqlDao genAddColumnSqlDao;

    public static final String TEMPLATE = "ALTER TABLE `{SCHEMA}`.`{TABLE}` \n" +
            "ADD COLUMN `create_by` VARCHAR(64) NULL comment '创建人' AFTER `{LAST_COLUMN}`;\n" +
            "\n" +
            "ALTER TABLE `{SCHEMA}`.`{TABLE}` \n" +
            "ADD COLUMN `create_date` datetime NULL comment '创建时间' AFTER `create_by`;\n" +
            "\n" +
            "ALTER TABLE `{SCHEMA}`.`{TABLE}` \n" +
            "ADD COLUMN `update_by` VARCHAR(64) NULL comment '更新人' AFTER `create_date`;\n" +
            "\n" +
            "ALTER TABLE `{SCHEMA}`.`{TABLE}` \n" +
            "ADD COLUMN `update_date` datetime NULL comment '更新时间' AFTER `update_by`;\n" +
            "\n" +
            "ALTER TABLE `{SCHEMA}`.`{TABLE}` \n" +
            "ADD COLUMN `remarks` VARCHAR(255) NULL comment '备注信息' AFTER `update_date`;\n" +
            "\n" +
            "ALTER TABLE `{SCHEMA}`.`{TABLE}` \n" +
            "ADD COLUMN `del_flag` CHAR(1) NULL comment '删除标记' AFTER `remarks`;\n";


    public String genAddColumnSql(String tablePrefix, final String schema) {

        final StringBuffer cacheStr = new StringBuffer();
        List<Map> list = genAddColumnSqlDao.getTables(schema, tablePrefix);
        list.forEach(new Consumer<Map>() {
            @Override
            public void accept(Map map) {
                String tableName = String.valueOf(map.get("TABLE_NAME"));
                Map columnMap = genAddColumnSqlDao.getColumns(schema, tableName);
                String columnName = String.valueOf(columnMap.get("COLUMN_NAME"));

                String sql = TEMPLATE.replaceAll("\\{SCHEMA\\}", schema).replaceAll("\\{TABLE\\}", tableName).replaceAll("\\{LAST_COLUMN\\}", columnName);
                cacheStr.append(sql);
            }
        });

        System.out.println("========================================================");
        System.out.println("========================================================");
        System.out.println("========================================================");

        System.out.println(cacheStr);

        System.out.println("========================================================");
        System.out.println("========================================================");
        System.out.println("========================================================");
        return cacheStr.toString();
    }


}
