<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>生产明细管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
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

		<div class="form-actions">
			<shiro:hasPermission name="erp:erpProductionItems:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>

</body>
</html>