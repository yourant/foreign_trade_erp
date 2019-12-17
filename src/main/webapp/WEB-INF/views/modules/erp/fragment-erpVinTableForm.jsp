<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>车架信息管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/erp/erpVin/">车架信息列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpVin/form?id=${erpVin.id}">车架信息<shiro:hasPermission name="erp:erpVin:edit">${not empty erpVin.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpVin:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="erpVin" action="${ctx}/erp/erpVin/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		

		<div class="form-actions">
			<shiro:hasPermission name="erp:erpVin:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>

</body>
</html>