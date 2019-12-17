package com.fy.erp.modules.gen.service;

import com.fy.erp.BaseJunit;
import org.apache.commons.io.FileUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.springframework.test.annotation.Rollback;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.io.File;
import java.net.URL;

/**
 * 生成alert sql，为表添加固定的一些字段
 * Created by 尹彬 on 2017/10/24.
 */
public class GenAddColumnSqlServiceTest extends BaseJunit {

    @Resource
    private GenAddColumnSqlService genAddColumnSqlService;

    @Test
    @Transactional(readOnly = true)   //标明此方法需使用事务
    @Rollback(false)  //标明使用完此方法后事务不回滚,true时为回滚
    public void genAddColumnSql() throws Exception {
        String schema = "erp";
        String tablePrefix = "erp";

        String sql = genAddColumnSqlService.genAddColumnSql(tablePrefix, schema);
//        尹彬的
        String pathname = "/Users/fy/workspace/project/erp/erp/db/addColumnSql/alter.sql";
//       尹彬生成sql配置
//        pathname = "C:/Users/Administrator/Desktop/alter.sql";
        FileUtils.writeStringToFile(new File(pathname), sql);
    }

}