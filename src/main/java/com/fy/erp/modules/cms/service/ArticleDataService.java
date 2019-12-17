/**
 *
 */
package com.fy.erp.modules.cms.service;

import com.fy.erp.common.service.CrudService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fy.erp.modules.cms.dao.ArticleDataDao;
import com.fy.erp.modules.cms.entity.ArticleData;

/**
 * 站点Service
 * @author ThinkGem
 * @version 2013-01-15
 */
@Service
@Transactional(readOnly = true)
public class ArticleDataService extends CrudService<ArticleDataDao, ArticleData> {

}
