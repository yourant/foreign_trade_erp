package com.fy.erp.modules.erp.entity

import com.fy.erp.common.persistence.DataEntity
import com.google.common.collect.Lists
import org.hibernate.validator.constraints.Length
import javax.validation.constraints.Max
import javax.validation.constraints.Min
import javax.validation.constraints.NotNull

/**
 * 支付类型Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpPayType : DataEntity<ErpPayType> {

    @get:NotNull(message = "销售订单不能为空")
    var erpSalesOrder: ErpSalesOrder? = null        // 销售订单
    @get:Length(min = 1, max = 1, message = "付款方式长度必须介于 1 和 1 之间")
    var enmuPaymentType: String? = null        // 付款方式
    @get:NotNull(message = "销售订单不能为空")
    @get:Min(0)
    @get:Max(100)
    var scale: String? = null        // 付款方式比例
    var sumPrice: Double? = null        // 订单金额
    var erpPayMoneyList: List<ErpPayMoney> = Lists.newArrayList()        // 子表列表

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================

    constructor(erpSalesOrder: ErpSalesOrder) : super() {
        this.erpSalesOrder = erpSalesOrder
    }

    var totalPrice: Double? = null      // 实付款金额

}