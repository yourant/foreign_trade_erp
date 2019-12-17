/**
 *
 */
package com.fy.erp.modules.sys.service;

import java.util.List;

import com.fy.erp.modules.sys.dao.DictDao;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fy.erp.common.service.CrudService;
import com.fy.erp.common.utils.CacheUtils;
import com.fy.erp.modules.sys.entity.Dict;
import com.fy.erp.modules.sys.utils.DictUtils;

/**
 * 字典Service
 *
 * @author ThinkGem
 * @version 2014-05-16
 */
@Service
@Transactional(readOnly = true)
public class DictService extends CrudService<DictDao, Dict> {

    /**
     * 查询字段类型列表
     *
     * @return
     */
    public List<String> findTypeList() {
        return dao.findTypeList(new Dict());
    }

    @Transactional(readOnly = false)
    public int save(Dict dict) {
        super.save(dict);
        CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
        return 0;
    }

    @Transactional(readOnly = false)
    public int delete(Dict dict) {
        super.delete(dict);
        CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
        return 0;
    }

}
