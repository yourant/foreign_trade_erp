package com.fy.erp.modules.erp.entity

import com.fasterxml.jackson.annotation.JsonFormat
import com.fy.erp.common.persistence.ActEntity
import com.fy.erp.common.persistence.DataEntity
import com.google.common.collect.Lists
import org.hibernate.validator.constraints.Length
import java.util.*

/**
 * 发货单Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpShipments : ActEntity<ErpShipments> {

    @get:Length(min=0, max=25, message="提单号长度必须介于 0 和 25 之间")
    var blno: String? = null 		// 提单号
    @get:Length(min=0, max=255, message="入货通知附件长度必须介于 0 和 255 之间")
    var noticeFile: String? = null 		// 入货通知附件
    @get:Length(min=0, max=1, message="提单类型长度必须介于 0 和 1 之间")
    var enumBillType: String? = null 		// 提单类型
    @get:JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    var deliveryTime: Date? = null 		// 发货时间
    @get:Length(min=0, max=255, message="报关单号长度必须介于 0 和 255 之间")
    var billManifestNo: String? = null 		// 报关单号
    @get:Length(min=0, max=255, message="报关单附件长度必须介于 0 和 255 之间")
    var billManifestFile: String? = null 		// 报关单附件
    @get:Length(min=0, max=255, message="提单附件长度必须介于 0 和 255 之间")
    var billLadingFile: String? = null 		// 提单附件
    @get:Length(min=0, max=255, message="海运账单附件长度必须介于 0 和 255 之间")
    var priceManifestFile: String? = null 		// 海运账单附件
    @get:JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    var sendTime: Date? = null 		// 离港时间
    @get:JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    var preComeTime: Date? = null 		// 预计到达时间
    @get:Length(min=0, max=2, message="快递公司长度必须介于 0 和 2 之间")
    var enumExpressCompany: String? = null 		// 快递公司
    @get:Length(min=0, max=25, message="文件寄送单号长度必须介于 1 和 25 之间")
    var expressNum: String? = null 		// 文件寄送单号
    @get:Length(min=0, max=255, message="快递单据附件长度必须介于 0 和 255 之间")
    var expressFile: String? = null 		// 快递单据附件
    @get:Length(min=0, max=1, message="货物类型长度必须介于 0 和 1 之间")
    var enumShipmentsType: String? = null 		// 货物类型
    @get:Length(min=0, max=1, message="发货状态长度必须介于 0 和 1 之间")
    var status: String? = null 		// 发货状态
    var erpDockerList: List<ErpDocker> = Lists.newArrayList()		// 子表列表


    constructor() : super() {}

    constructor(id: String) : super(id) {}


// ========================================================================================

    var erpVinList: List<ErpVin> = Lists.newArrayList()		// 子表列表 保存用

    var erpRepairOrder: ErpRepairOrder? = null
    var erpPartsOrder: ErpPartsOrder? = null
    var expressDate: Date? = null  //快递时间
}