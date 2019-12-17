<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>生产明细管理</title>
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
		<li><a href="${ctx}/erp/erpProductionItems/">生产明细列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpProductionItems/form?id=${erpProductionItems.id}">生产明细<shiro:hasPermission name="erp:erpProductionItems:edit">${not empty erpProductionItems.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpProductionItems:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="erpProductionItems" action="${ctx}/erp/erpProductionItems/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">生产订单：</label>
                <div class="controls">
                    ${erpProductionItems.erpProductionOrder.id}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">发动机型号：</label>
                <div class="controls">
                    <form:select path="erpEngineType.id" class="input-xlarge "  readonly="true" disabled="true">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">车型：</label>
                <div class="controls">
                    <form:select path="erpCarType.id" class="input-xlarge "  readonly="true" disabled="true">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">数量：</label>
                <div class="controls">
                    ${erpProductionItems.count}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注信息：</label>
                <div class="controls">
                    <pre>
                    ${erpProductionItems.remarks}
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