/**
 *
 */
package com.fy.erp.modules.sys.service;

import java.util.List;

import com.fy.erp.common.service.TreeService;
import com.fy.erp.modules.sys.entity.Area;
import com.fy.erp.modules.sys.utils.UserUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fy.erp.modules.sys.dao.AreaDao;

/**
 * 区域Service
 * @author ThinkGem
 * @version 2014-05-16
 */
@Service
@Transactional(readOnly = true)
public class AreaService extends TreeService<AreaDao, Area> {

	public List<Area> findAll(){
		return UserUtils.getAreaList();
	}

	@Transactional(readOnly = false)
	public int save(Area area) {
		super.save(area);
		UserUtils.removeCache(UserUtils.CACHE_AREA_LIST);
		return 0;
	}
	
	@Transactional(readOnly = false)
	public int delete(Area area) {
		super.delete(area);
		UserUtils.removeCache(UserUtils.CACHE_AREA_LIST);
		return 0;
	}
	
}
