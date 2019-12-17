<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>生产订单管理</title>
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
		function addRow(list, idx, tpl, row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row
			}));
			$(list+idx).find("select").each(function(){
				$(this).val($(this).attr("data-value"));
			});
			$(list+idx).find("input[type='checkbox'], input[type='radio']").each(function(){
				var ss = $(this).attr("data-value").split(',');
				for (var i=0; i<ss.length; i++){
					if($(this).val() == ss[i]){
						$(this).attr("checked","checked");
					}
				}
			});
		}
		function delRow(obj, prefix){
			var id = $(prefix+"_id");
			var delFlag = $(prefix+"_delFlag");
			if (id.val() == ""){
				$(obj).parent().parent().remove();
			}else if(delFlag.val() == "0"){
				delFlag.val("1");
				$(obj).html("&divide;").attr("title", "撤销删除");
				$(obj).parent().parent().addClass("error");
			}else if(delFlag.val() == "1"){
				delFlag.val("0");
				$(obj).html("&times;").attr("title", "删除");
				$(obj).parent().parent().removeClass("error");
			}
		}
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<c:if test="${isForm}">
			<li><a href="${ctx}/erp/erpProductionOrder/">生产订单列表</a></li>
		</c:if>
		<li class="active"><a href="${ctx}/erp/erpProductionOrder/form?id=${erpProductionOrder.id}">生产订单<shiro:hasPermission name="erp:erpProductionOrder:edit">${not empty erpProductionOrder.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpProductionOrder:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="erpProductionOrder" action="${ctx}${action}" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group hide">
			<label class="control-label">销售订单：</label>
			<div class="controls">
				<form:input path="erpSalesOrder.id" htmlEscape="false" maxlength="64" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">供应商：</label>
			<div class="controls">
				<form:select path="enmuProvider" class="input-xlarge required">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('enmu_provider')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">生产计划：</label>
			<div class="controls">
				<form:hidden id="content" path="content" htmlEscape="false" maxlength="255" class="input-xlarge"/>
				<sys:ckfinder input="content" type="files" uploadPath="/ProductionPlain" selectMultiple="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">下单日期：</label>
			<div class="controls">
				<input name="orderTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required"
					value="<fmt:formatDate value="${erpProductionOrder.orderTime}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
			<div class="control-group">
				<label class="control-label">生产明细：</label>
				<div class="controls">
					<table id="contentTable" class="table table-striped table-bordered table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>发动机型号</th>
								<th>车型</th>
								<th>数量</th>
								<th>备注信息</th>
								<shiro:hasPermission name="erp:erpProductionOrder:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="erpProductionItemsList">
						</tbody>
						<shiro:hasPermission name="erp:erpProductionOrder:edit"><tfoot>
							<tr><td colspan="6"><a href="javascript:" onclick="addRow('#erpProductionItemsList', erpProductionItemsRowIdx, erpProductionItemsTpl);erpProductionItemsRowIdx = erpProductionItemsRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="erpProductionItemsTpl">//<!--
						<tr id="erpProductionItemsList{{idx}}">
							<td class="hide">
								<input id="erpProductionItemsList{{idx}}_id" name="erpProductionItemsList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="erpProductionItemsList{{idx}}_delFlag" name="erpProductionItemsList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
									<sys:treeselect id="erpProductionItemsList{{idx}}_erpEngineType" name="erpProductionItemsList[{{idx}}].erpEngineType.id" value="{{row.erpEngineType.id}}"
								labelName="srow.erpEngineType.aname" labelValue="{{row.erpEngineType.aname}}"
								title="发动机型号" url="/autoComplete/treeData?type=3" viewName="view_engine_type"
								cssClass="input-small required" allowClear="true" notAllowSelectParent="true"/>
							</td>
							<td>
									<sys:treeselect id="erpProductionItemsList{{idx}}_erpCarType" name="erpProductionItemsList[{{idx}}].erpCarType.id" value="{{row.erpCarType.id}}"
								labelName="srow.erpCarType.aname" labelValue="{{row.erpCarType.aname}}"
								title="车型" url="/autoComplete/treeData?type=3" viewName="view_car_type"
								cssClass="input-small required" allowClear="true" notAllowSelectParent="true"/>
							</td>
							<td>
								<input id="erpProductionItemsList{{idx}}_count" name="erpProductionItemsList[{{idx}}].count" type="text" value="{{row.count}}" maxlength="6" class="input-small digits required"/>
							</td>
							<td>
								<textarea id="erpProductionItemsList{{idx}}_remarks" name="erpProductionItemsList[{{idx}}].remarks" rows="4" maxlength="255" class="input-small ">{{row.remarks}}</textarea>
							</td>
							<shiro:hasPermission name="erp:erpProductionOrder:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#erpProductionItemsList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var erpProductionItemsRowIdx = 0, erpProductionItemsTpl = $("#erpProductionItemsTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(erpProductionOrder.erpProductionItemsList)};
							for (var i=0; i<data.length; i++){
								addRow('#erpProductionItemsList', erpProductionItemsRowIdx, erpProductionItemsTpl, data[i]);
								erpProductionItemsRowIdx = erpProductionItemsRowIdx + 1;
							}
						});
					</script>
				</div>
			</div>
		<div class="form-actions">
			<shiro:hasPermission name="erp:erpProductionOrder:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>