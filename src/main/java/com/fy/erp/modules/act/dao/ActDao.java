/**
 *
 */
package com.fy.erp.modules.act.dao;

import com.fy.erp.common.persistence.CrudDao;
import com.fy.erp.modules.act.entity.Act;
import com.fy.erp.common.persistence.annotation.MyBatisDao;

/**
 * 审批DAO接口
 * @author thinkgem
 * @version 2014-05-16
 */
@MyBatisDao
public interface ActDao extends CrudDao<Act> {

	public int updateProcInsIdByBusinessId(Act act);
	
}
