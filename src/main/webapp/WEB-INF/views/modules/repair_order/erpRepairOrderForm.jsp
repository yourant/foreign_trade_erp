<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>三包订单管理</title>
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
            $("#enumSolutionType").on("change", function (data) {
                if (data.val == 1) {// 如果是维修则显示：售后问题、维修方法
                    $(".repair").show();
                    $(".replace").hide();
                } else {// 如果是配件则显示：维修配件
                    $(".repair").hide();
                    $(".replace").show();
                }
            })
		});
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/erp/erpRepairOrder/">三包订单列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpRepairOrder/form?id=${erpRepairOrder.id}">三包订单<shiro:hasPermission name="erp:erpRepairOrder:edit">${not empty erpRepairOrder.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpRepairOrder:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="erpRepairOrder" action="${ctx}/erp/erpRepairOrder/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<form:hidden path="act.taskId"/>
		<form:hidden path="act.taskName"/>
		<form:hidden path="act.taskDefKey"/>
		<form:hidden path="act.procInsId"/>
		<form:hidden path="act.procDefId"/>
		<form:hidden path="draft" value="1" id="ipt_draft"/>
		<form:hidden id="flag" path="act.flag"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">解决方案类型：</label>
			<div class="controls">
				<form:select id="enumSolutionType" path="enumSolutionType" class="input-xlarge required">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('enum_solution_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group repair">
			<label class="control-label">售后问题：</label>
			<div class="controls">
				<form:textarea path="question" htmlEscape="false" rows="4" maxlength="255"
							   class="input-xxlarge hide"/>
				<sys:ckeditor replace="question" uploadPath="/test" height="200"/>
			</div>
		</div>
		<div class="control-group replace">
			<label class="control-label">维修配件：</label>
			<div class="controls">
				<form:textarea path="requireParts" htmlEscape="false" rows="4" maxlength="255"
							   class="input-xxlarge hide"/>
				<sys:ckeditor replace="requireParts" uploadPath="/test" height="200"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255"
							   class="input-xxlarge "/>
				<sys:ckeditor replace="remarks" uploadPath="/test" height="200"/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="erp:erpRepairOrder:save">
				<input id="btnSubmit" class="btn btn-default" type="submit" value="保存草稿"/>
				&nbsp;
			</shiro:hasPermission>
			<shiro:hasPermission name="erp:erpRepairOrder:oa:create">
				<input class="btn btn-success" type="submit" value="新建三包订单" onclick="$('#ipt_draft').val(0);"/>&nbsp;
			</shiro:hasPermission>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>