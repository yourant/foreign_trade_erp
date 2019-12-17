package com.fy.erp.modules.erp.entity

import com.fy.erp.common.persistence.DataEntity
import org.hibernate.validator.constraints.Length

/**
 * 国家Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class SysCountry : DataEntity<SysCountry> {

    @get:Length(min = 1, max = 50, message = "英文名称长度必须介于 1 和 50 之间")
    var aname: String? = null        // 英文名称
    @get:Length(min = 1, max = 50, message = "中文名称长度必须介于 1 和 50 之间")
    var zhName: String? = null        // 中文名称
    @get:Length(min = 1, max = 5, message = "简写长度必须介于 1 和 5 之间")
    var code: String? = null        // 简写

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================

}