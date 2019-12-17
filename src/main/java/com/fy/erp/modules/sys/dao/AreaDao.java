/**
 *
 */
package com.fy.erp.modules.sys.dao;

import com.fy.erp.common.persistence.annotation.MyBatisDao;
import com.fy.erp.common.persistence.TreeDao;
import com.fy.erp.modules.sys.entity.Area;

/**
 * 区域DAO接口
 * @author ThinkGem
 * @version 2014-05-16
 */
@MyBatisDao
public interface AreaDao extends TreeDao<Area> {
	
}
