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
		<li class="active"><a>录入三包订单维修方法</a></li>
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
				<form:select path="enumSolutionType" class="input-xlarge required"  readonly="true" disabled="true">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('enum_solution_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">售后问题：</label>
			<div class="controls">
				<form:textarea path="question" htmlEscape="false" rows="4" maxlength="255"
							   class="input-xxlarge hide" readonly="true" disabled="true"/>
				<sys:ckeditor replace="question" uploadPath="/test" height="200"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255"
							   class="input-xxlarge " />
				<sys:ckeditor replace="remarks" uploadPath="/test" height="200"/>
			</div>
		</div>
		<div class="control-group repair">
			<label class="control-label">维修方法：</label>
			<div class="controls">
				<form:textarea path="repairMethod" htmlEscape="false" rows="4" maxlength="255"
							   class="input-xxlarge hide"/>
				<sys:ckeditor replace="repairMethod" uploadPath="/test" height="200"/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="erp:erpRepairOrder:save">
				<input id="btnSubmit" class="btn btn-default" type="submit" value="保存草稿"/>
				&nbsp;
			</shiro:hasPermission>
			<shiro:hasPermission name="erp:erpRepairOrder:erpRepairMethodForm">
				<input class="btn btn-success" type="submit" value="录入维修方法" onclick="$('#ipt_draft').val(0);"/>&nbsp;
			</shiro:hasPermission>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>