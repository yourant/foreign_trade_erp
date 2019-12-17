/**
 *
 */
package com.fy.erp.modules.oa.dao;

import com.fy.erp.common.persistence.CrudDao;
import com.fy.erp.common.persistence.annotation.MyBatisDao;
import com.fy.erp.modules.oa.entity.OaNotify;

/**
 * 通知通告DAO接口
 * @author ThinkGem
 * @version 2014-05-16
 */
@MyBatisDao
public interface OaNotifyDao extends CrudDao<OaNotify> {
	
	/**
	 * 获取通知数目
	 * @param oaNotify
	 * @return
	 */
	public Long findCount(OaNotify oaNotify);
	
}