<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>支付金额管理</title>
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
		<li><a href="${ctx}/erp/erpPayMoney/">支付金额列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpPayMoney/form?id=${erpPayMoney.id}">支付金额<shiro:hasPermission name="erp:erpPayMoney:edit">${not empty erpPayMoney.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpPayMoney:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="erpPayMoney" action="${ctx}/erp/erpPayMoney/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">支付类型：</label>
                <div class="controls">
                    ${erpPayMoney.erpPayType.id}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">应付款：</label>
                <div class="controls">
                    ${erpPayMoney.payableMoney}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">实付款：</label>
                <div class="controls">
                    ${erpPayMoney.comeMoney}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">付款日期：</label>
                <div class="controls">
                    <fmt:formatDate value="${erpPayMoney.time}" pattern="yyyy-MM-dd" />
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">付款比例：</label>
                <div class="controls">
                    ${erpPayMoney.scale}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注信息：</label>
                <div class="controls">
                    <pre>
                    ${erpPayMoney.remarks}
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