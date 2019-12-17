/**
 *
 */
package com.fy.erp.modules.gen.dao;

import com.fy.erp.common.persistence.CrudDao;
import com.fy.erp.common.persistence.annotation.MyBatisDao;
import com.fy.erp.modules.gen.entity.GenTable;

/**
 * 业务表DAO接口
 * @author ThinkGem
 * @version 2013-10-15
 */
@MyBatisDao
public interface GenTableDao extends CrudDao<GenTable> {
	
}
