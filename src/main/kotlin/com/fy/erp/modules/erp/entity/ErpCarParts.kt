package com.fy.erp.modules.erp.entity

import com.fy.erp.common.persistence.DataEntity
import com.google.common.collect.Lists
import org.hibernate.validator.constraints.Length

/**
 * 配件Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpCarParts : DataEntity<ErpCarParts> {

    @get:Length(min = 0, max = 50, message = "中文名称长度必须介于 0 和 50 之间")
    var aname: String? = null        // 中文名称
    @get:Length(min = 1, max = 50, message = "英文名称长度必须介于 1 和 50 之间")
    var enName: String? = null        // 英文名称
    var erpCarType: ErpCarType? = null        // 车型
    var erpEngineType: ErpEngineType? = null        // 发动机型号
    @get:Length(min = 0, max = 255, message = "配件图片长度必须介于 0 和 255 之间")
    var image: String? = null        // 配件图片
    @get:Length(min = 0, max = 1, message = "单位长度必须介于 0 和 1 之间")
    var unit: String? = null        // 单位
    var erpSendItemsList: List<ErpSendItems> = Lists.newArrayList()        // 子表列表

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================
    var price: Double? = null       // 总价

    var seqNo:Int = 0 // 导出 excel 的序号

}