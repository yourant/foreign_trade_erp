<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>配件管理</title>
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
		<li><a href="${ctx}/erp/erpCarParts/">配件列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpCarParts/form?id=${erpCarParts.id}">配件<shiro:hasPermission name="erp:erpCarParts:edit">${not empty erpCarParts.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpCarParts:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="erpCarParts" action="${ctx}/erp/erpCarParts/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">中文名称：</label>
			<div class="controls">
				<form:input path="aname" htmlEscape="false" maxlength="50" class="input-xlarge required zhValidator"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">英文名称：</label>
			<div class="controls">
				<form:input path="enName" htmlEscape="false" maxlength="50" class="input-xlarge required enValidator"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">车型：</label>
			<div class="controls">
				<sys:treeselect id="erpCarType" name="erpCarType.id" value="${erpCarParts.erpCarType.id}"
								labelName="erpCarType.aname" labelValue="${erpCarParts.erpCarType.aname}"
								title="车型" url="/autoComplete/treeData?type=3" viewName="view_car_type"
								cssClass="" allowClear="true" notAllowSelectParent="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">发动机型号：</label>
			<div class="controls">
				<sys:treeselect id="erpEngineType" name="erpEngineType.id" value="${erpCarParts.erpEngineType.id}"
								labelName="erpEngineType.aname" labelValue="${erpCarParts.erpEngineType.aname}"
								title="发动机型号" url="/autoComplete/treeData?type=3" viewName="view_engine_type"
								cssClass="" allowClear="true" notAllowSelectParent="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">配件图片：</label>
			<div class="controls">
				<form:hidden id="image" path="image" htmlEscape="false" maxlength="255" class="input-xlarge"/>
				<sys:ckfinder input="image" type="files" uploadPath="/erp/erpCarParts" selectMultiple="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">价格：</label>
			<div class="controls">
				<form:input path="price" htmlEscape="false" class="input-xlarge required price"/>
				<form:select path="unit" class="input-small">
					<form:options items="${fns:getDictList('unit_name')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">  `
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="erp:erpCarParts:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>