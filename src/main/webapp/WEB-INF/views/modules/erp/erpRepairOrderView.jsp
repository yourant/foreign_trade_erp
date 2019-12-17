<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>三包订单管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
	</script>
</head>
<body>
	<ul class="nav nav-tabs my-nav-tabs">
		<li><a href="${ctx}/erp/erpRepairOrder/">三包订单列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpRepairOrder/form?id=${erpRepairOrder.id}">三包订单<shiro:hasPermission name="erp:erpRepairOrder:edit">${not empty erpRepairOrder.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpRepairOrder:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="erpRepairOrder" action="${ctx}/erp/erpRepairOrder/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">解决方案类型：</label>
                <div class="controls">
                    <form:select path="enumSolutionType" class="input-xlarge required"  readonly="true" disabled="true">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('enum_solution_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">售后问题：</label>
                <div class="controls">
                    <pre>
                    ${erpRepairOrder.question}
                    </pre>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">维修方法：</label>
                <div class="controls">
                    <pre>
                    ${erpRepairOrder.repairMethod}
                    </pre>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">维修配件：</label>
                <div class="controls">
                    <pre>
                    ${erpRepairOrder.requireParts}
                    </pre>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">三包状态：</label>
                <div class="controls">
                    <form:select path="status" class="input-xlarge required"  readonly="true" disabled="true">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('status_repair_order')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注信息：</label>
                <div class="controls">
                    <pre>
                    ${erpRepairOrder.remarks}
                    </pre>
                </div>
            </div>
            <div class="form-actions my-form-actions">
                <input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
            </div>
        </form:form>
    </div>
</body>
</html>