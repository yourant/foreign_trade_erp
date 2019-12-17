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
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/erp/erpProductionItems/">生产明细列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpProductionItems/form?id=${erpProductionItems.id}">生产明细<shiro:hasPermission name="erp:erpProductionItems:edit">${not empty erpProductionItems.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpProductionItems:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="erpProductionItems" action="${ctx}/erp/erpProductionItems/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">生产订单：</label>
			<div class="controls">
				<form:input path="erpProductionOrder.id" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">车型：</label>
			<div class="controls">
				<sys:treeselect id="erpCarType" name="erpCarType.id" value="${erpProductionItems.erpCarType.id}"
								labelName="erpCarType.aname" labelValue="${erpProductionItems.erpCarType.aname}"
								title="车型" url="/autoComplete/treeData?type=3" viewName="view_car_type"
								cssClass="" allowClear="true" notAllowSelectParent="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">发动机型号：</label>
			<div class="controls">
				<sys:treeselect id="erpEngineType" name="erpEngineType.id" value="${erpProductionItems.erpEngineType.id}"
								labelName="erpEngineType.aname" labelValue="${erpProductionItems.erpEngineType.aname}"
								title="发动机型号" url="/autoComplete/treeData?type=3" viewName="view_engine_type"
								cssClass="" allowClear="true" notAllowSelectParent="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">数量：</label>
			<div class="controls">
				<form:input path="count" htmlEscape="false" maxlength="6" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="erp:erpProductionItems:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>