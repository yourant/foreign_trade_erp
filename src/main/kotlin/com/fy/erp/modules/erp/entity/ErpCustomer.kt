package com.fy.erp.modules.erp.entity

import com.fy.erp.common.persistence.DataEntity
import com.fy.erp.modules.sys.entity.User
import org.hibernate.validator.constraints.Length
import javax.validation.constraints.NotNull

/**
 * 客户Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpCustomer : DataEntity<ErpCustomer> {

    var user: User? = null        // 所属员工
    @get:Length(min = 1, max = 25, message = "名称长度必须介于 1 和 30 之间")
    var aname: String? = null        // 名称
    @get:Length(min = 1, max = 50, message = "公司长度必须介于 1 和 50 之间")
    var company: String? = null        // 公司
    @get:Length(min = 1, max = 25, message = "邮箱长度必须介于 1 和 50 之间")
    var email: String? = null        // 邮箱
    @get:Length(min = 1, max = 12, message = "电话长度必须介于 1 和 50 之间")
    var phone: String? = null        // 电话
    @get:Length(min = 1, max = 100, message = "地址长度必须介于 1 和 150 之间")
    var address: String? = null        // 地址
    @get:NotNull(message = "国家不能为空")
    var sysCountry: SysCountry? = null        // 国家
    @get:Length(min = 0, max = 2, message = "客户来源长度必须介于 0 和 2 之间")
    var enmuCustomerSource: String? = null        // 客户来源
    @get:Length(min = 0, max = 1, message = "客户类型长度必须介于 0 和 1 之间")
    var enmuCustomerType: String? = null        // 客户类型

    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================

}