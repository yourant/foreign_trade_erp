package com.fy.erp.modules.erp.entity

/**
 * 三包订单流程实例节点主键
 * Created by 尹彬 on 2017/11/22.
 */
enum class RepairOrderTaskID(val flag: String) {
    BEGIN("BEGIN"),
    CREATE_SEND_ITEMS("CREATE_SEND_ITEMS"),
    CHECK_SEND_ITEMS("CHECK_SEND_ITEMS"),
    CREATE_SHIPPING_INFO("CREATE_SHIPPING_INFO"),
    CHECK_SHIPPING_INFO("CHECK_SHIPPING_INFO"),
    CREATE_REPAIR_METHOD("CREATE_REPAIR_METHOD"),
    END("END")
}