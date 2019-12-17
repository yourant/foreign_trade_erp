package com.fy.erp.modules.erp.dao

import com.fy.erp.common.persistence.CrudDao
import com.fy.erp.common.persistence.annotation.MyBatisDao
import com.fy.erp.modules.erp.entity.ErpPayMoney

/**
 * 支付金额DAO接口
 * @author 尹彬
 * @version 2017-11-06
 */
@MyBatisDao
interface ErpPayMoneyDao : CrudDao<ErpPayMoney> {

// ========================================================================================
}