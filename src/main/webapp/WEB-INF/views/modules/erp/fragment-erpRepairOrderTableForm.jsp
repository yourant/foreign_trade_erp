<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>三包订单管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/erp/erpRepairOrder/">三包订单列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpRepairOrder/form?id=${erpRepairOrder.id}">三包订单<shiro:hasPermission name="erp:erpRepairOrder:edit">${not empty erpRepairOrder.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpRepairOrder:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="erpRepairOrder" action="${ctx}/erp/erpRepairOrder/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		

		<div class="form-actions">
			<shiro:hasPermission name="erp:erpRepairOrder:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>

</body>
</html>