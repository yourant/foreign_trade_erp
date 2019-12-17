/**
 *
 */
package com.fy.erp.modules.cms.dao;

import com.fy.erp.common.persistence.CrudDao;
import com.fy.erp.common.persistence.annotation.MyBatisDao;
import com.fy.erp.modules.cms.entity.Site;

/**
 * 站点DAO接口
 * @author ThinkGem
 * @version 2013-8-23
 */
@MyBatisDao
public interface SiteDao extends CrudDao<Site> {

}
