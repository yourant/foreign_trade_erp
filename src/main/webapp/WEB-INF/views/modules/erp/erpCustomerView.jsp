<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户管理</title>
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
		<li><a href="${ctx}/erp/erpCustomer/">客户列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpCustomer/form?id=${erpCustomer.id}">客户<shiro:hasPermission name="erp:erpCustomer:edit">${not empty erpCustomer.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpCustomer:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="erpCustomer" action="${ctx}/erp/erpCustomer/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">所属员工：</label>
                <div class="controls">
                    ${erpCustomer.user.name}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">名称：</label>
                <div class="controls">
                    ${erpCustomer.aname}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">公司：</label>
                <div class="controls">
                    ${erpCustomer.company}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">邮箱：</label>
                <div class="controls">
                    ${erpCustomer.email}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">电话：</label>
                <div class="controls">
                    ${erpCustomer.phone}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">地址：</label>
                <div class="controls">
                    ${erpCustomer.address}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">国家：</label>
                <div class="controls">
                    ${erpCustomer.sysCountry.aname}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">客户来源：</label>
                <div class="controls">
                    ${fns:getDictLabel(erpCustomer.enmuCustomerSource,'enmu_customer_source','')}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">客户类型：</label>
                <div class="controls">
                    ${fns:getDictLabel(erpCustomer.enmuCustomerType,'enmu_customer_type','')}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注信息：</label>
                <div class="controls">
                    <pre>
                    ${erpCustomer.remarks}
                    </pre>
                </div>
            </div>
            <div class="form-actions my-form-actions hide">
                <shiro:hasPermission name="erp:erpCustomer:save"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
                <input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
            </div>
        </form:form>
    </div>
</body>
</html>