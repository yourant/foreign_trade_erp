<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>国家管理</title>
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
		<li><a href="${ctx}/erp/sysCountry/">国家列表</a></li>
		<li class="active"><a href="${ctx}/erp/sysCountry/form?id=${sysCountry.id}">国家<shiro:hasPermission name="erp:sysCountry:edit">${not empty sysCountry.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:sysCountry:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="sysCountry" action="${ctx}/erp/sysCountry/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">英文名称：</label>
			<div class="controls">
				<form:input path="aname" htmlEscape="false" maxlength="50" class="input-xlarge required"/>



				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">中文名称：</label>
			<div class="controls">
				<form:input path="zhName" htmlEscape="false" maxlength="50" class="input-xlarge required"/>



				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">简写：</label>
			<div class="controls">
				<form:input path="code" htmlEscape="false" maxlength="5" class="input-xlarge required"/>



				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>



			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="erp:sysCountry:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>