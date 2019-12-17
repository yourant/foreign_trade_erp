package com.fy.erp.modules.erp.entity

import com.fy.erp.common.persistence.DataEntity
import org.hibernate.validator.constraints.Length
import javax.validation.constraints.NotNull

/**
 * 生产明细Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpProductionItems : DataEntity<ErpProductionItems> {

    @get:NotNull(message = "生产订单不能为空")
    var erpProductionOrder: ErpProductionOrder? = null        // 生产订单
    var erpEngineType: ErpEngineType? = null        // 发动机型号
    var erpCarType: ErpCarType? = null        // 车型
    @get:Length(min = 0, max = 6, message = "数量长度必须介于 0 和 6 之间")
    var count: String? = null        // 数量

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================

    var erpVinList:MutableList<ErpVin> = mutableListOf()        // 子表列表

    constructor(erpProductionOrder: ErpProductionOrder) : super() {
        this.erpProductionOrder = erpProductionOrder
    }
}