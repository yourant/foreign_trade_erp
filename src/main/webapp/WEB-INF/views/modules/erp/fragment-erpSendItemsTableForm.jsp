<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>发货明细管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/erp/erpSendItems/">发货明细列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpSendItems/form?id=${erpSendItems.id}">发货明细<shiro:hasPermission name="erp:erpSendItems:edit">${not empty erpSendItems.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpSendItems:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="erpSendItems" action="${ctx}/erp/erpSendItems/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		

		<div class="form-actions">
			<shiro:hasPermission name="erp:erpSendItems:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>

</body>
</html>