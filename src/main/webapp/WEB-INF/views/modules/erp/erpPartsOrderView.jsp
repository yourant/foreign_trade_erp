<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>配件订单管理</title>
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
		<li><a href="${ctx}/erp/erpPartsOrder/">配件订单列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpPartsOrder/form?id=${erpPartsOrder.id}">配件订单<shiro:hasPermission name="erp:erpPartsOrder:edit">${not empty erpPartsOrder.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpPartsOrder:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="erpPartsOrder" action="${ctx}/erp/erpPartsOrder/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">PI：</label>
                <div class="controls">
                    ${erpPartsOrder.pi}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">车架号：</label>
                <div class="controls">
                    ${erpPartsOrder.vin}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">发送方式：</label>
                <div class="controls">
                    <form:select path="enumPartsOrderType" class="input-xlarge required"  readonly="true" disabled="true">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('enum_parts_order_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">状态：</label>
                <div class="controls">
                    <form:select path="status" class="input-xlarge required"  readonly="true" disabled="true">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('status_parts_order')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注信息：</label>
                <div class="controls">
                    <pre>
                    ${erpPartsOrder.remarks}
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