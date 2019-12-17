/**
 *
 */
package com.fy.erp.modules.gen.dao;

import com.fy.erp.common.persistence.CrudDao;
import com.fy.erp.common.persistence.annotation.MyBatisDao;
import com.fy.erp.modules.gen.entity.GenTable;
import org.apache.ibatis.annotations.Param;
import org.springframework.security.access.method.P;

import java.util.List;
import java.util.Map;

/**
 * 业务表DAO接口
 *
 * @author ThinkGem
 * @version 2013-10-15
 */
@MyBatisDao
public interface GenAddColumnSqlDao extends CrudDao<GenTable> {

    public List<Map> getTables(@Param("schema") String schema, @Param("tablePrefix") String tablePrefix);

    public Map getColumns(@Param("schema") String schema, @Param("tableName") String tableName);

}
