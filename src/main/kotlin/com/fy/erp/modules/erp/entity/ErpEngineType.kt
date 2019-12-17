package com.fy.erp.modules.erp.entity

import com.fy.erp.common.persistence.DataEntity
import org.hibernate.validator.constraints.Length

/**
 * 发动机型号Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpEngineType : DataEntity<ErpEngineType> {

    @get:Length(min = 1, max = 100, message = "发动机名称长度必须介于 1 和 100 之间")
    var aname: String? = null        // 发动机名称

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================

}