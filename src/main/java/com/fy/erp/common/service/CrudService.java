/**
 *
 */
package com.fy.erp.common.service;

import java.lang.reflect.Field;
import java.util.List;

import com.fy.erp.common.persistence.CrudDao;
import com.fy.erp.common.persistence.Page;
import com.fy.erp.common.service.enu.NextOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.fy.erp.common.persistence.DataEntity;

import static com.fy.erp.common.persistence.BaseEntity.DEL_FLAG_NORMAL;
import static org.apache.commons.lang3.StringUtils.isBlank;

/**
 * Service基类
 *
 * @author ThinkGem
 * @version 2014-05-16
 */
@Transactional(readOnly = true)
public abstract class CrudService<D extends CrudDao<T>, T extends DataEntity<T>> extends BaseService {

    /**
     * 持久层对象
     */
    @Autowired
    protected D dao;

    /**
     * 获取单条数据
     *
     * @param id
     * @return
     */
    public T get(String id) {
        return dao.get(id);
    }

    /**
     * 获取单条数据
     *
     * @param entity
     * @return
     */
    public T get(T entity) {
        return dao.get(entity);
    }

    /**
     * 查询列表数据
     *
     * @param entity
     * @return
     */
    public List<T> findList(T entity) {
        return dao.findList(entity);
    }


    /**
     * 查询分页数据
     *
     * @param page   分页对象
     * @param entity
     * @return
     */
    public Page<T> findPage(Page<T> page, T entity) {
        entity.setPage(page);
        page.setList(dao.findList(entity));
        return page;
    }

    /**
     * 保存数据（插入或更新）
     *
     * @param entity
     */
    @Transactional(readOnly = false)
    public int save(T entity) {
        if (entity.getIsNewRecord()) {
            entity.preInsert();
            return dao.insert(entity);
        } else {
            entity.preUpdate();
            return dao.update(entity);
        }
    }

    /**
     * 删除数据
     *
     * @param entity
     */
    @Transactional(readOnly = false)
    public int delete(T entity) {
        return dao.delete(entity);
    }

    /**
     * 实体类属性不为空的生成插入语句
     *
     * @param entity
     * @return
     */
    public int insertSelective(T entity) {
        return dao.insertSelective(entity);
    }

    /**
     * 实体类属性不为空的生成update set语句
     *
     * @param entity
     * @return
     */
    public int updateSelective(T entity) {
        return dao.updateSelective(entity);
    }


    /**
     * 循环向上转型, 获取对象的 DeclaredField
     *
     * @param clazz     : 子类对象
     * @param fieldName : 父类中的属性名
     * @return 父类中的属性对象
     */

    protected static Field getDeclaredField(Class<?> clazz, String fieldName) {
        Field field = null;
        for (; clazz != Object.class; clazz = clazz.getSuperclass()) {
            try {
                field = clazz.getDeclaredField(fieldName);
                field.setAccessible(true);
                return field;
            } catch (Exception e) {
                //这里甚么都不要做！并且这里的异常必须这样写，不能抛出去。
                //如果这里的异常打印或者往外抛，则就不会执行clazz = clazz.getSuperclass(),最后就不会进入到父类中了
            }
        }
        return null;
    }

    public NextOperation getNextOperation(Object child) throws NoSuchFieldException, IllegalAccessException {
        Class<?> aClass = child.getClass();

        Field idField = getDeclaredField(aClass, "id");
        String id = String.valueOf(idField.get(child));

        Field delFlagField = getDeclaredField(aClass, "delFlag");
        String delFlag = String.valueOf(delFlagField.get(child));

        if (DEL_FLAG_NORMAL.equals(delFlag)) {
            if (isBlank(id)) { // 插入的情况
                return NextOperation.INSERT;
            } else {  // 更新的情况
                return NextOperation.UPDATE;
            }
        } else {
            //删除的情况
            return NextOperation.DELETE;
        }
    }

}
