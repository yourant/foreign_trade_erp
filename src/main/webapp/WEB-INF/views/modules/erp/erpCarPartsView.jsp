<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>配件管理</title>
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
		<li><a href="${ctx}/erp/erpCarParts/">配件列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpCarParts/form?id=${erpCarParts.id}">配件<shiro:hasPermission name="erp:erpCarParts:edit">${not empty erpCarParts.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpCarParts:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="erpCarParts" action="${ctx}/erp/erpCarParts/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">中文名称：</label>
                <div class="controls">
                    ${erpCarParts.aname}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">英文名称：</label>
                <div class="controls">
                    ${erpCarParts.enName}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">车型：</label>
                <div class="controls">
                    ${erpCarParts.erpCarType.aname}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">发动机型号：</label>
                <div class="controls">
                    ${erpCarParts.erpEngineType.aname}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">配件图片：</label>
                <div class="controls">
                    <form:hidden id="image" path="image" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                    <sys:ckfinder input="image" type="files" uploadPath="/erp/erpCarParts" selectMultiple="true"   readonly="true"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">价格：</label>
                <div class="controls">
                   ${fns:getDictLabel(erpCarParts.unit, 'price_unit', '')}${erpCarParts.price}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注信息：</label>
                <div class="controls">
                    <pre>
                    ${erpCarParts.remarks}
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