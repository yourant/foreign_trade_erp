package com.fy.erp.modules.erp.entity

import com.fasterxml.jackson.annotation.JsonFormat
import com.fy.erp.common.persistence.ActEntity
import com.fy.erp.common.persistence.DataEntity
import com.fy.erp.modules.sys.entity.User
import com.google.common.collect.Lists
import org.hibernate.validator.constraints.Length
import java.util.*
import javax.validation.constraints.NotNull

/**
 * 销售订单Entity
 * @author 尹彬
 * @version 2017-11-06
 */
class ErpSalesOrder : ActEntity<ErpSalesOrder> {

    @get:NotNull(message = "客户不能为空")
    var erpCustomer: ErpCustomer? = null        // 客户
    var user: User? = null        // 人员名称
    @get:Length(min = 0, max = 1, message = "贸易形式长度必须介于 0 和 1 之间")
    var enmuTradingType: String? = null        // 贸易形式
    @get:Length(min = 0, max = 25, message = "PI长度必须介于 0 和 25 之间")
    var piNo: String? = null        // PI
    var productionPlain: String? = null        // 简要生产计划
    @get:JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    var orderTime: Date? = null        // 下单时间
    var commission: Double? = null        // 销售提成
    @get:JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    var commissionMonth: Date? = null        // 发放月份
    @get:Length(min = 0, max = 2, message = "订单状态长度必须介于 0 和 2 之间")
    var status: String? = null        // 订单状态
    var erpPayTypeList: List<ErpPayType> = Lists.newArrayList()        // 子表列表
    var erpProductionOrderList: List<ErpProductionOrder> = Lists.newArrayList()        // 子表列表

    constructor() : super() {}

    constructor(id: String) : super(id) {}


    // ========================================================================================
    var sumPayableMoney: Double? = null        // 应收款统计
    var sumComeMoney: Double? = null            //实付款统计
    var arrearage: Double? = null            //欠款


    var piFile: String? = null           // PI 附件

    var moneyPass: Int = 0  // 是否全款

    var isSavePiFile:Boolean = false // 是否是仅仅保存pi附件

}