package com.fy.erp.modules.erp.dao

import com.fy.erp.common.persistence.CrudDao
import com.fy.erp.common.persistence.annotation.MyBatisDao
import com.fy.erp.modules.erp.entity.ErpSalesOrderShipments
import com.fy.erp.modules.erp.entity.ErpShipments

/**
 * 发货单DAO接口
 * @author 尹彬
 * @version 2017-11-06
 */
@MyBatisDao
interface ErpShipmentsDao : CrudDao<ErpShipments> {

// ========================================================================================
   fun insertSalesOrderShipments (erpSalesOrderShipments: ErpSalesOrderShipments): Int
   fun updateSalesOrderShipments(erpSalesOrderShipments: ErpSalesOrderShipments): Int
   fun selectSalesOrderShipments (erpSalesOrderShipments: ErpSalesOrderShipments): ErpSalesOrderShipments
}