package com.fy.erp.modules.erp.entity

import com.fy.erp.common.persistence.ActEntity
import com.google.common.collect.Lists
import org.hibernate.validator.constraints.Length

/**
 * 配件订单Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpPartsOrder : ActEntity<ErpPartsOrder> {

    @get:Length(min = 1, max = 25, message = "PI长度必须介于 1 和 25 之间")
    var pi: String? = null        // PI
    @get:Length(min=0, max=255, message="报关单附件长度必须介于 0 和 255 之间")
    var piFile: String? = null 		// PI附件
    @get:Length(min = 1, max = 2, message = "状态长度必须介于 1 和 2 之间")
    var status: String? = null        // 状态

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================

    var erpSendItemsList: List<ErpSendItems> = Lists.newArrayList()
    var erpExpress: ErpExpress? = null
    var erpShipments: ErpShipments? = null
    var erpVinDTOList: List<ErpVinDTO> = Lists.newArrayList()
    var price: Double = 0.0

}