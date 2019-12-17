<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户跟踪管理</title>
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
	<ul class="nav nav-tabs  my-nav-tabs ">
		<li><a href="${ctx}/erp/erpCustomerVisit/">客户跟踪列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpCustomerVisit/form?id=${erpCustomerVisit.id}">客户跟踪<shiro:hasPermission name="erp:erpCustomerVisit:edit">${not empty erpCustomerVisit.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpCustomerVisit:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="erpCustomerVisit" action="${ctx}/erp/erpCustomerVisit/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">跟进时间：</label>
                <div class="controls">
                    <fmt:formatDate value="${erpCustomerVisit.followUpDate}" pattern="yyyy-MM-dd" />
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">跟进产品：</label>
                <div class="controls">
                    ${erpCustomerVisit.production}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">跟进状态文件：</label>
                <div class="controls">
                    ${erpCustomerVisit.stateFile}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">预计成交时间：</label>
                <div class="controls">
                    <fmt:formatDate value="${erpCustomerVisit.intentionDate}" pattern="yyyy-MM-dd" />
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">客户等级：</label>
                <div class="controls">
                    ${fns:getDictLabel(erpCustomerVisit.customerLevel,'enum_customer_level','')}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注信息：</label>
                <div class="controls">
                    <pre>
                    ${erpCustomerVisit.remarks}
                    </pre>
                </div>
            </div>
            <div class="form-actions my-form-actions hide">
                <shiro:hasPermission name="erp:erpCustomerVisit:save"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
                <input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
            </div>
        </form:form>
    </div>
</body>
</html>