package com.fy.erp.modules.erp.entity

import com.fy.erp.common.persistence.DataEntity
import com.google.common.collect.Lists
import org.hibernate.validator.constraints.Length

/**
 * 集装箱Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpDocker : DataEntity<ErpDocker> {

    var erpShipments: ErpShipments? = null        // 发货单
    @get:Length(min = 0, max = 25, message = "集装箱号长度必须介于 0 和 25 之间")
    var dockerNo: String? = null        // 集装箱号
    @get:Length(min = 0, max = 25, message = "铅封号长度必须介于 0 和 25 之间")
    var sealNo: String? = null        // 铅封号
    var parts: String? = null        // 其余
    var erpVinList: List<ErpVin> = Lists.newArrayList()        // 子表列表

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================

    constructor(erpShipments: ErpShipments) : super() {
        this.erpShipments = erpShipments
    }

}