package com.fy.erp.modules.erp.entity

import com.fy.erp.common.persistence.DataEntity
import com.google.common.collect.Lists
import org.hibernate.validator.constraints.Length
import javax.validation.constraints.NotNull

/**
 * 车架信息Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpVin : DataEntity<ErpVin> {

    var erpDocker: ErpDocker? = null        // 集装箱
    @get:NotNull(message = "生产订单明细不能为空")
    var erpProductionItems: ErpProductionItems? = null        // 生产订单明细
    @get:Length(min = 1, max = 25, message = "车架号长度必须介于 1 和 25 之间")
    var vinNo: String? = null        // 车架号
    @get:Length(min = 0, max = 25, message = "引擎编号长度必须介于 0 和 25 之间")
    var engineNo: String? = null        // 引擎编号
    @get:Length(min = 1, max = 25, message = "生产人长度必须介于 1 和 25 之间")
    var productor: String? = null        // 生产人

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================
    var dockerKey: String? = null        //保存用
    var erpSendItemsList: List<ErpSendItems> = Lists.newArrayList()

    constructor(erpDocker: ErpDocker) : super() {
        this.erpDocker = erpDocker
    }
    constructor(erpProductionItems: ErpProductionItems) : super() {
        this.erpProductionItems = erpProductionItems
    }
}