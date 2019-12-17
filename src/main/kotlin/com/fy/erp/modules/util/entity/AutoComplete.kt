package com.fy.erp.modules.util.entity

import com.fy.erp.common.persistence.DataEntity
import org.hibernate.validator.constraints.Length

/**
 * 国家管理Entity
 * @author 尹彬
 * @version 2017-10-31
 */
class AutoComplete : DataEntity<AutoComplete> {

	var value: String? = null 		// 英文名称
	var data: String? = null 		// 中文名称

	constructor() : super() {}

    constructor(id: String) : super(id) {}

}