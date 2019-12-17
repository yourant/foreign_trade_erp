package com.fy.erp.modules.erp.entity

import com.fasterxml.jackson.annotation.JsonFormat
import com.fy.erp.common.persistence.DataEntity
import com.fy.erp.modules.sys.entity.User
import com.google.common.collect.Lists
import org.hibernate.validator.constraints.Length
import java.util.*
import javax.validation.constraints.NotNull

/**
 * 销售订单发货单Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpSalesOrderShipments : DataEntity<ErpSalesOrderShipments> {

    var erpSalesOrderId: String? = null        // 销售订单号
    var erpShipmentsId: String? = null        // 发货单号

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================

}