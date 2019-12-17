package com.fy.erp.modules.erp.entity

import com.fy.erp.common.persistence.DataEntity
import com.google.common.collect.Lists
import org.hibernate.validator.constraints.Length
import java.util.*

/**
 * 快递Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpExpress : DataEntity<ErpExpress> {

    @get:Length(min = 0, max = 25, message = "快递单号长度必须介于 0 和 25 之间")
    var expressNo: String? = null        // 快递单号
    @get:Length(min = 0, max = 2, message = "快递公司长度必须介于 0 和 2 之间")
    var enumExpressCompany: String? = null        // 快递公司
    var price: Double? = null        // 快递费

    constructor() : super() {}

    constructor(id: String) : super(id) {}


    // ========================================================================================

    var erpSendItemsList: List<ErpSendItems> = Lists.newArrayList()

    var erpRepairOrder: ErpRepairOrder? = null
    var erpPartsOrder: ErpPartsOrder? = null

    var expressDate: Date? = null  //快递时间

}