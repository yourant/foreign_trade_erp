package com.fy.erp.modules.erp.entity

import com.fy.erp.common.persistence.ActEntity
import com.fy.erp.common.persistence.DataEntity
import com.google.common.collect.Lists
import org.hibernate.validator.constraints.Length

/**
 * 三包订单Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpRepairOrder : ActEntity<ErpRepairOrder> {

    @get:Length(min = 1, max = 1, message = "解决方案类型长度必须介于 1 和 1 之间")
    var enumSolutionType: String? = null        // 解决方案类型
    var question: String? = null        // 售后问题
    var repairMethod: String? = null        // 维修方法
    var requireParts: String? = null        // 维修配件
    @get:Length(min = 1, max = 2, message = "三包状态长度必须介于 1 和 2 之间")
    var status: String? = null        // 三包状态

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================

    var erpSendItemsList: List<ErpSendItems> = Lists.newArrayList()
    var erpExpress: ErpExpress? = null
    var erpShipments: ErpShipments? = null
    var erpVinDTOList: List<ErpVinDTO> = Lists.newArrayList()

}