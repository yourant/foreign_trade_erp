<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>车架信息管理</title>
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
		<li><a href="${ctx}/erp/erpVin/">车架信息列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpVin/form?id=${erpVin.id}">车架信息<shiro:hasPermission name="erp:erpVin:edit">${not empty erpVin.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpVin:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="erpVin" action="${ctx}/erp/erpVin/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">集装箱：</label>
                <div class="controls">
                    <pre>
                    ${erpVin.erpDocker.id}
                    </pre>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">生产订单明细：</label>
                <div class="controls">
                    ${erpVin.erpProductionItems.id}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">车架号：</label>
                <div class="controls">
                    ${erpVin.vinNo}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">引擎编号：</label>
                <div class="controls">
                    ${erpVin.engineNo}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">生产人：</label>
                <div class="controls">
                    ${erpVin.productor}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注信息：</label>
                <div class="controls">
                    <pre>
                    ${erpVin.remarks}
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