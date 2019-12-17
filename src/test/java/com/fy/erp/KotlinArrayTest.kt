package com.fy.erp

import java.util.*

/**
 * Created by 尹彬 on 2017/11/17.
 */
object KotlinArrayTest {

    @JvmStatic
    fun main(args: Array<String>) {
        val status: String = "2"
        val checkStatusList: Array<String> = arrayOf("2","3","1","53")

        val isShow: Boolean = checkStatusList.any { it == status }

        println(isShow)

        val contains = checkStatusList.contains(status)
        println(contains)

    }
}