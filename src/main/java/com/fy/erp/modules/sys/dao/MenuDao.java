/**
 *
 */
package com.fy.erp.modules.sys.dao;

import java.util.List;

import com.fy.erp.common.persistence.CrudDao;
import com.fy.erp.common.persistence.annotation.MyBatisDao;
import com.fy.erp.modules.sys.entity.Menu;

/**
 * 菜单DAO接口
 * @author ThinkGem
 * @version 2014-05-16
 */
@MyBatisDao
public interface MenuDao extends CrudDao<Menu> {

	public List<Menu> findByParentIdsLike(Menu menu);

	public List<Menu> findByUserId(Menu menu);
	
	public int updateParentIds(Menu menu);
	
	public int updateSort(Menu menu);
	
}
