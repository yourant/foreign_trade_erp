package com.fy.erp.modules.erp.service

import com.fy.erp.BaseJunit
import com.fy.erp.common.utils.StringUtils
import com.fy.erp.modules.act.entity.Act
import com.fy.erp.modules.act.service.ActTaskService
import com.fy.erp.modules.erp.entity.SalesOrderTaskID
import com.fy.erp.modules.sys.utils.UserUtils
import org.activiti.engine.history.HistoricVariableInstance
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.springframework.beans.factory.annotation.Autowired
import java.util.ArrayList
import javax.annotation.Resource

class ProcessInsTest : BaseJunit() {

    @Resource
    lateinit var actTaskService: ActTaskService


    @Before
    fun setUp() {
    }

    @After
    fun tearDown() {
    }

    @Test
    fun createHistoricProcessInstanceQuery() {
        val listPage = actTaskService.historyService.createHistoricProcessInstanceQuery()
                .finished()
                .processDefinitionId("")
                .orderByProcessInstanceDuration().desc()
                .listPage(0, 10)
    }

    @Test
    fun createHistoricActivityInstanceQuery() {
        val listPage = actTaskService.historyService.createHistoricActivityInstanceQuery()
                .activityType("userTask").processInstanceId("6b59b2bca8694f7aa18c54da98f3bb7a")
                .orderByHistoricActivityInstanceEndTime().desc()
                .listPage(0, 1)
        println(listPage)
    }


    @Test
    fun createHistoricActivityInstanceQuer2y() {
        val listPage = actTaskService.historyService.createHistoricTaskInstanceQuery()
                .processInstanceId("6b59b2bca8694f7aa18c54da98f3bb7a")
                .list().last()
        println(listPage)
    }



    @Test
    fun taskService() {
        println(SalesOrderTaskID.CHECK_BEGIN_PAYMENT.name)
//
        val lastTask = actTaskService.historyService.createHistoricTaskInstanceQuery()
                .processInstanceId("6b59b2bca8694f7aa18c54da98f3bb7a").taskDefinitionKey(SalesOrderTaskID.CHECK_PRODUCTION_PLAN.name)
                .list().last()

//        val value = actTaskService.taskService.getVariable(lastTask.id,"pass")
//
        val lastTaskVari = actTaskService.historyService.createHistoricVariableInstanceQuery()
                .processInstanceId("6b59b2bca8694f7aa18c54da98f3bb7a")
                .variableName("pass")
                .taskId(lastTask.id)
                .list()
        println()
//        val value = lastTaskVari.value
//        println(value)
    }

    @Test
    fun taskService3() {
        val passList = actTaskService.historyService.createHistoricVariableInstanceQuery()
                .processInstanceId("6b59b2bca8694f7aa18c54da98f3bb7a")
                .variableName("pass")
                .list()
        if(passList.size>0) {
            var pass2: HistoricVariableInstance = passList[0]
            for (pass in passList) {
                if (pass.createTime.time > pass2.createTime.time)
                    pass2 = pass
            }
            val value = pass2.value
            println(value)
        }
    }

    @Test
    fun taskService2() {
        val list = actTaskService.taskService.createTaskQuery().processInstanceId("6b59b2bca8694f7aa18c54da98f3bb7a")
//                .taskDefinitionKey(SalesOrderTaskID.CHECK_PRODUCTION_PLAN.name)
                .list()
        println(list)
    }


    @Test
    fun taskService66() {
        val lastTask = actTaskService.historyService.createHistoricTaskInstanceQuery()
                .processInstanceId("6b59b2bca8694f7aa18c54da98f3bb7a").orderByHistoricTaskInstanceEndTime().desc().list().first()


        val lastTaskVari = actTaskService.historyService.createHistoricVariableInstanceQuery()
//                .processInstanceId("6b59b2bca8694f7aa18c54da98f3bb7a")
                .variableName("pass")
                .taskId(lastTask.id)
                .singleResult()
        val value = lastTaskVari.value
        println(value)
    }

    @Test
    fun taskService666() {
        val lastTask = actTaskService.historyService.createHistoricTaskInstanceQuery()
                .processInstanceId("6b59b2bca8694f7aa18c54da98f3bb7a").orderByHistoricTaskInstanceEndTime().desc().list().first()

        val comment = actTaskService.taskService.getTaskComments(lastTask.id)
        println(comment)

//        val historicProcessInstance = actTaskService.historyService.createHistoricProcessInstanceQuery().singleResult()
    }

    @Test
    fun test1() {
        val userId = "caozuoyuan" // czy

        val todoTaskQuery = actTaskService.taskService.createTaskQuery().taskAssignee(userId).active()
                .includeProcessVariables().orderByTaskCreateTime().desc()

        val todoList = todoTaskQuery.list()
        for (task in todoList) {
            val bKey = task.processVariables["businessId"]
            println(bKey)
        }
    }


    @Test
    fun test12() {
        val userId = "caozuoyuan" // czy

        val histTaskQuery = actTaskService.historyService.createHistoricTaskInstanceQuery().taskAssignee(userId)//.finished()
                .includeProcessVariables().orderByHistoricTaskInstanceEndTime().desc()

        // 查询列表
        val histList = histTaskQuery.list()
        val businessIdSet = hashSetOf<String>()
        histList.forEach { businessIdSet.add(it.processVariables["businessId"].toString()) }
        val businessIds = businessIdSet.joinToString("', '","'","'")
        println(businessIds)
        for (s in businessIdSet) {
            println(s)
        }
    }

    @Test
    fun test13() {

        val businessIdSet = hashSetOf<String>()

        val businessIds = businessIdSet.joinToString("', '","'","'")
        println(businessIds)

    }


}