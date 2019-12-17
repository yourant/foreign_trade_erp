package com.fy.erp.modules.erp.entity

import com.fy.erp.common.persistence.DataEntity
import org.hibernate.validator.constraints.Length
import javax.validation.constraints.NotNull

/**
 * 发货明细Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpSendItems : DataEntity<ErpSendItems> {

    @get:Length(min = 0, max = 11, message = "数量长度必须介于 0 和 11 之间")
    var count: Int? = null        // 数量
    @get:Length(min = 0, max = 1, message = "发送配件类型长度必须介于 0 和 1 之间")
    var enumSendItemsType: String? = null        // 发送配件类型
    var erpExpress: ErpExpress? = null        // 快递
    var erpPartsOrder: ErpPartsOrder? = null        // 配件订单
    var erpRepairOrder: ErpRepairOrder? = null        // 三包订单
    var erpDocker: ErpDocker? = null        // 集装箱
    @get:NotNull(message = "配件不能为空")
    var erpCarParts: ErpCarParts? = null        // 配件
    var erpVin: ErpVin? = null        // 车架

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================
    var statusKey: String? = null       //拼箱还是快递  保存用
    var dockerKey: String? = null       //判断哪个集装箱  保存用
    constructor(erpCarParts: ErpCarParts) : super() {
        this.erpCarParts = erpCarParts
    }
    constructor(erpRepairOrder: ErpRepairOrder) : super() {
        this.erpRepairOrder = erpRepairOrder
    }

    constructor(erpPartsOrder: ErpPartsOrder) : super() {
        this.erpPartsOrder = erpPartsOrder
    }

}