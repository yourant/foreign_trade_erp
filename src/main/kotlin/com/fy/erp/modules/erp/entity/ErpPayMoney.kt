package com.fy.erp.modules.erp.entity

import com.fasterxml.jackson.annotation.JsonFormat
import com.fy.erp.common.persistence.DataEntity
import java.util.*
import javax.validation.constraints.NotNull

/**
 * 支付金额Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpPayMoney : DataEntity<ErpPayMoney> {

    @get:NotNull(message = "支付类型不能为空")
    var erpPayType: ErpPayType? = null        // 支付类型
    var payableMoney: Double? = null        // 应付款
    var comeMoney: Double? = null        // 实付款
    @get:JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    var time: Date? = null        // 付款时间
    var scale: Double? = null        // 付款比例

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================

    constructor(erpPayType: ErpPayType) : super() {
        this.erpPayType = erpPayType
    }

    var file: String? = null        //付款截图
}