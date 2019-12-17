package com.fy.erp.modules.erp.entity


/**
 * 三包订单显示用的vin
 * @author 尹彬
 * @version 2017-11-21
 */
class ErpVinDTO {
    var id: String? = null        // ErpVin的id 保存用
    var engineNo: String? = null        // 引擎号 以后可能用
    var vinNo: String? = null        // 车架号 显示用
    var erpCarType: ErpCarType? = null        // 车型
    var erpEngineType: ErpEngineType? = null        // 发动机型号
    var pi: String? = null        // pi 显示用

    constructor()

    constructor(id: String){
        this.id = id
    }


    // ========================================================================================

}

