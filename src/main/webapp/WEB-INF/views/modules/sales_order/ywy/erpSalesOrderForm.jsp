<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>新建销售订单</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {
            //$("#name").focus();
            $("#inputForm").validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });
        });

        function addRow(list, idx, tpl, row) {
            $(list).append(Mustache.render(tpl, {
                idx: idx, delBtn: true, row: row
            }));
            $(list + idx).find("select").each(function () {
                $(this).val($(this).attr("data-value"));
            });
            $(list + idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                var ss = $(this).attr("data-value").split(',');
                for (var i = 0; i < ss.length; i++) {
                    if ($(this).val() == ss[i]) {
                        $(this).attr("checked", "checked");
                    }
                }
            });
        }

        function delRow(obj, prefix) {
            var id = $(prefix + "_id");
            var delFlag = $(prefix + "_delFlag");
            if (id.val() == "") {
                $(obj).parent().parent().remove();
            } else if (delFlag.val() == "0") {
                delFlag.val("1");
                $(obj).html("&divide;").attr("title", "撤销删除");
                $(obj).parent().parent().addClass("error");
            } else if (delFlag.val() == "1") {
                delFlag.val("0");
                $(obj).html("&times;").attr("title", "删除");
                $(obj).parent().parent().removeClass("error");
            }
        }
    </script>
</head>
<body>
<ul class="nav nav-tabs my-nav-tabs">
    <li class="active"><a href="${ctx}/erp/erpSalesOrder/form?id=${erpSalesOrder.id}">销售订单<shiro:hasPermission
            name="erp:erpSalesOrder:edit">${not empty erpSalesOrder.id?'修改':'添加'}</shiro:hasPermission></a></li>
</ul>
<br/>
<div class="my-container">
    <form:form id="inputForm" modelAttribute="erpSalesOrder" action="${ctx}/erp/erpSalesOrder/save" method="post"
               class="form-horizontal">
        <form:hidden path="id"/>
        <form:hidden path="act.taskId"/>
        <form:hidden path="act.taskName"/>
        <form:hidden path="act.taskDefKey"/>
        <form:hidden path="act.procInsId"/>
        <form:hidden path="act.procDefId"/>
        <form:hidden path="draft" value="1" id="ipt_draft"/>
        <form:hidden id="flag" path="act.flag"/>
        <sys:message content="${message}"/>
        <div class="control-group">
            <label class="control-label">客户：</label>
            <div class="controls">
                <sys:treeselect id="erpCustomer" name="erpCustomer.id" value="${erpSalesOrder.erpCustomer.id}"
                                labelName="erpCustomer.aname" labelValue="${erpSalesOrder.erpCustomer.aname}"
                                title="客户" url="/autoComplete/findCustomerBySessionUser?type=3"
                                cssClass="required" allowClear="true" notAllowSelectParent="true"/>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">人员名称：</label>
            <div class="controls">
                <form:input path="user.name" value="${fns:getUser().name}" htmlEscape="false" maxlength="25" class="input-xlarge required readonly" readonly="true" disabled="true"/>
                <form:hidden path="user.id" value="${fns:getUser().id}" htmlEscape="false" maxlength="25" class="input-xlarge required"/>
                <%--<sys:treeselect id="user" name="user.id" value="${erpSalesOrder.user.id}" labelName="user.name"
                                labelValue="${erpSalesOrder.user.name}"
                                title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true"
                                notAllowSelectParent="true"/>--%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">贸易形式：</label>
            <div class="controls">
                <form:select path="enmuTradingType" class="input-xlarge required">
                    <form:option value="" label=""/>
                    <form:options items="${fns:getDictList('enmu_trading_type')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">PI 编号：</label>
            <div class="controls">
                <form:input path="piNo" htmlEscape="false" maxlength="25" class="input-xlarge required"/>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">PI 附件：</label>
            <div class="controls">
                <form:hidden id="piFile" path="piFile" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                <sys:ckfinder input="piFile" type="files" uploadPath="/PiFile" selectMultiple="true"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">下单日期：</label>
            <div class="controls">
                <input name="orderTime" type="text" readonly="readonly" maxlength="20"
                       class="input-medium Wdate required"
                       value="<fmt:formatDate value="${erpSalesOrder.orderTime}" pattern="yyyy-MM-dd"/>"
                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">简要生产计划：</label>
            <div class="controls">
                <form:hidden id="productionPlain" path="productionPlain" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                <sys:ckfinder input="productionPlain" type="files" uploadPath="/JianYaoProductionPlain" selectMultiple="true"/>
                    <%--<form:textarea path="productionPlain" htmlEscape="false" rows="4" maxlength="255"--%>
                    <%--class="input-xxlarge required hide"/>--%>
                    <%--<sys:ckeditor replace="productionPlain" uploadPath="/test" height="200"/>--%>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">备注信息：</label>
            <div class="controls">
                <form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255"
                               class="input-xxlarge "/>
                <sys:ckeditor replace="remarks" uploadPath="/test" height="200"/>
            </div>
        </div>
        <div class="form-actions my-form-actions">
            <shiro:hasPermission name="erp:erpSalesOrder:save">
                <input id="btnSubmit" class="btn btn-default" type="submit" value="保存草稿"/>
                &nbsp;
            </shiro:hasPermission>
            <%--<c:if test="${erpSalesOrder.act.taskId != null && erpSalesOrder.act.taskId != ''}">--%>
                <shiro:hasPermission name="erp:erpSalesOrder:oa:create">
                    <input class="btn btn-success" type="submit" value="新建整机销售订单" onclick="$('#ipt_draft').val(0);"/>&nbsp;
                </shiro:hasPermission>
            <%--</c:if>--%>
            <input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </form:form>
</div>
</body>
</html>