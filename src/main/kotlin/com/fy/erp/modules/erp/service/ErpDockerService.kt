package com.fy.erp.modules.erp.service;

import com.fy.erp.common.persistence.Page
import com.fy.erp.common.service.CrudService
import com.fy.erp.common.service.enu.NextOperation
import com.fy.erp.modules.erp.dao.ErpDockerDao
import com.fy.erp.modules.erp.dao.ErpVinDao
import com.fy.erp.modules.erp.entity.ErpDocker
import com.fy.erp.modules.erp.entity.ErpVin
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

/**
 * 集装箱Service
 * @author 尹彬
 * @version 2017-11-06
 */
@Service
@Transactional(readOnly = true)
open class ErpDockerService : CrudService<ErpDockerDao, ErpDocker>() {

    @Autowired
    lateinit var erpVinDao: ErpVinDao

    override fun get(id: String): ErpDocker {
        val erpDocker = super.get(id)
        erpDocker.erpVinList = erpVinDao.findList(ErpVin(erpDocker))
        return erpDocker
    }

    override fun findList(erpDocker: ErpDocker): List<ErpDocker> {
        return super.findList(erpDocker)
    }

    override fun findPage(page: Page<ErpDocker>, erpDocker: ErpDocker): Page<ErpDocker> {
        return super.findPage(page, erpDocker)
    }

    @Transactional(readOnly = false)
    override fun save(erpDocker: ErpDocker): Int {
        super.save(erpDocker)
        return erpDocker.erpVinList.map { child ->
            when (getNextOperation(child)!!) {
                NextOperation.INSERT -> { // 插入的情况
                    child.erpDocker = erpDocker
                    child.preInsert()
                    erpVinDao.insert(child)
                }
                NextOperation.UPDATE -> {  // 更新的情况
                    child.preUpdate()
                    erpVinDao.update(child)
                }
                NextOperation.DELETE -> { //删除的情况
                    erpVinDao.delete(child)
                }
            }
        }.sumBy { it } /* */
    }

    @Transactional(readOnly = false)
    override fun delete(erpDocker: ErpDocker): Int {
        super.delete(erpDocker)
        return erpVinDao.delete(ErpVin(erpDocker))
    }

    // ========================================================================================

}