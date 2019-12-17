package com.fy.erp.modules.erp.entity

/**
 * 配件订单流程实例节点主键
 * Created by 尹彬 on 2017/12/27.
 */
enum class PartsOrderTaskID(val flag: String) {
    BEGIN("BEGIN"),
    CREATE_SEND_ITEMS("CREATE_SEND_ITEMS"),
    CHECK_SEND_ITEMS("CHECK_SEND_ITEMS"),
    CREATE_PAYMENT("CREATE_PAYMENT"),
    CHECK_PAYMENT("CHECK_PAYMENT"),
    CREATE_SHIPPING_INFO("CREATE_SHIPPING_INFO"),
    CHECK_SHIPPING_INFO("CHECK_SHIPPING_INFO"),
    END("END")
}