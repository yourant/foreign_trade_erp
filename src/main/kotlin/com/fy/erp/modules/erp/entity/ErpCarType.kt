package com.fy.erp.modules.erp.entity

import com.fy.erp.common.persistence.DataEntity
import org.hibernate.validator.constraints.Length

/**
 * 车型Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpCarType : DataEntity<ErpCarType> {

    @get:Length(min = 0, max = 100, message = "车型名称长度必须介于 0 和 100 之间")
    var aname: String? = null        // 车型名称

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================

}