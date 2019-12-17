<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>配件订单管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/erp/erpPartsOrder/">配件订单列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpPartsOrder/form?id=${erpPartsOrder.id}">配件订单<shiro:hasPermission name="erp:erpPartsOrder:edit">${not empty erpPartsOrder.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpPartsOrder:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="erpPartsOrder" action="${ctx}/erp/erpPartsOrder/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		

		<div class="form-actions">
			<shiro:hasPermission name="erp:erpPartsOrder:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>

</body>
</html>