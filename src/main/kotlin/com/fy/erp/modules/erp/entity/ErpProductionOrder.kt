package com.fy.erp.modules.erp.entity

import com.fasterxml.jackson.annotation.JsonFormat
import com.fy.erp.common.persistence.DataEntity
import com.google.common.collect.Lists
import org.hibernate.validator.constraints.Length
import org.springframework.beans.factory.annotation.Required
import java.util.*
import javax.validation.constraints.NotNull

/**
 * 生产订单Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpProductionOrder : DataEntity<ErpProductionOrder> {

    @get:NotNull(message = "销售订单不能为空")
    var erpSalesOrder: ErpSalesOrder? = null        // 销售订单
    @get:Length(min = 0, max = 2, message = "供应商长度必须介于 0 和 2 之间")
    var enmuProvider: String? = null        // 供应商
    @NotNull
    var content: String? = null        // 生产计划
    @get:JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    var orderTime: Date? = null        // 下单日期
    var erpProductionItemsList: List<ErpProductionItems> = Lists.newArrayList()        // 子表列表

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================

    constructor(erpSalesOrder: ErpSalesOrder) : super() {
        this.erpSalesOrder = erpSalesOrder
    }

}