package com.fy.erp.modules.erp.service

import com.fy.erp.BaseJunit
import org.junit.After
import org.junit.Before
import org.junit.Test

import javax.annotation.Resource

class ErpProductionItemsServiceTest : BaseJunit() {

    @Resource
    lateinit var erpProductionItemsService: ErpProductionItemsService


    @Before
    fun setUp() {
    }

    @After
    fun tearDown() {
    }

    @Test
    fun findList() {
        val findList = erpProductionItemsService.findList(erpSalesOrderId = "237dfd60c3f94aae856ed6d23b45b52c")
        assert(findList.isNotEmpty())
    }

    @Test
    fun findBoxList() {
        val boxList = erpProductionItemsService.findBoxList(erpSalesOrderId = "237dfd60c3f94aae856ed6d23b45b52c")
        assert(boxList.isNotEmpty())
    }

}