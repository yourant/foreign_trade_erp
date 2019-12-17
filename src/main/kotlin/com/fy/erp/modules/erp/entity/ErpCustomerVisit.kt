package com.fy.erp.modules.erp.entity

import java.util.Date
import com.fasterxml.jackson.annotation.JsonFormat
import org.hibernate.validator.constraints.Length
import com.fy.erp.modules.erp.entity.ErpCustomerVisit
import com.fy.erp.common.persistence.DataEntity

/**
 * 客户跟踪Entity
 * @author 尹彬
 * @version 2017-12-26
 */
class ErpCustomerVisit: DataEntity<ErpCustomerVisit> {

	@get:JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	var followUpDate: Date? = null 		// 跟进时间
	@get:Length(min=0, max=50, message="跟进产品长度必须介于 0 和 50 之间")
	var production: String? = null 		// 跟进产品
	@get:Length(min=0, max=255, message="跟进状态文件长度必须介于 0 和 255 之间")
	var stateFile: String? = null 		// 跟进状态文件
	@get:JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	var intentionDate: Date? = null 		// 预计成交时间
	var customerLevel: String? = null 		// 客户等级
	var erpCustomer: ErpCustomer? = null 		// 客户外键

	constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================

}