<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>发货单管理</title>
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
		<li><a href="${ctx}/erp/erpShipments/">发货单列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpShipments/form?id=${erpShipments.id}">发货单<shiro:hasPermission name="erp:erpShipments:edit">${not empty erpShipments.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpShipments:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="erpShipments" action="${ctx}/erp/erpShipments/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">提单号：</label>
			<div class="controls">
				<form:input path="blno" htmlEscape="false" maxlength="25" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">入货通知附件：</label>
			<div class="controls">
				<form:hidden id="noticeFile" path="noticeFile" htmlEscape="false" maxlength="11" class="input-xlarge"/>
				<sys:ckfinder input="noticeFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">提单类型：</label>
			<div class="controls">
				<form:select path="enumBillType" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('enum_bill_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">发货日期：</label>
			<div class="controls">
				<input name="deliveryTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
					value="<fmt:formatDate value="${erpShipments.deliveryTime}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">报关单号：</label>
			<div class="controls">
				<form:input path="billManifestNo" htmlEscape="false" maxlength="255" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">报关单附件：</label>
			<div class="controls">
				<form:hidden id="billManifestFile" path="billManifestFile" htmlEscape="false" maxlength="11" class="input-xlarge"/>
				<sys:ckfinder input="billManifestFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">提单附件：</label>
			<div class="controls">
				<form:hidden id="billLadingFile" path="billLadingFile" htmlEscape="false" maxlength="11" class="input-xlarge"/>
				<sys:ckfinder input="billLadingFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">海运账单附件：</label>
			<div class="controls">
				<form:hidden id="priceManifestFile" path="priceManifestFile" htmlEscape="false" maxlength="255" class="input-xlarge"/>
				<sys:ckfinder input="priceManifestFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">离港日期：</label>
			<div class="controls">
				<input name="sendTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
					value="<fmt:formatDate value="${erpShipments.sendTime}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">预计到达日期：</label>
			<div class="controls">
				<input name="preComeTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
					value="<fmt:formatDate value="${erpShipments.preComeTime}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">快递公司：</label>
			<div class="controls">
				<form:select path="enumExpressCompany" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('enum_express_company')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">文件寄送单号：</label>
			<div class="controls">
				<form:input path="expressNum" htmlEscape="false" maxlength="25" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">快递单据附件：</label>
			<div class="controls">
				<form:hidden id="expressFile" path="expressFile" htmlEscape="false" maxlength="255" class="input-xlarge"/>
				<sys:ckfinder input="expressFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">货物类型：</label>
			<div class="controls">
				<form:input path="enumShipmentsType" htmlEscape="false" maxlength="1" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">发货状态：</label>
			<div class="controls">
				<form:select path="status" class="input-xlarge ">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('status_shipments')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
			<div class="control-group">
				<label class="control-label">集装箱：</label>
				<div class="controls">
					<table id="contentTable" class="table table-striped table-bordered table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>集装箱号</th>
								<th>铅封号</th>
								<th>其余</th>
								<th>备注信息</th>
								<shiro:hasPermission name="erp:erpShipments:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="erpDockerList">
						</tbody>
						<shiro:hasPermission name="erp:erpShipments:edit"><tfoot>
							<tr><td colspan="6"><a href="javascript:" onclick="addRow('#erpDockerList', erpDockerRowIdx, erpDockerTpl);erpDockerRowIdx = erpDockerRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="erpDockerTpl">//<!--
						<tr id="erpDockerList{{idx}}">
							<td class="hide">
								<input id="erpDockerList{{idx}}_id" name="erpDockerList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="erpDockerList{{idx}}_delFlag" name="erpDockerList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="erpDockerList{{idx}}_dockerNo" name="erpDockerList[{{idx}}].dockerNo" type="text" value="{{row.dockerNo}}" maxlength="25" class="input-small "/>
							</td>
							<td>
								<input id="erpDockerList{{idx}}_sealNo" name="erpDockerList[{{idx}}].sealNo" type="text" value="{{row.sealNo}}" maxlength="25" class="input-small "/>
							</td>
							<td>
								<input id="erpDockerList{{idx}}_parts" name="erpDockerList[{{idx}}].parts" type="text" value="{{row.parts}}" class="input-small "/>
							</td>
							<td>
								<textarea id="erpDockerList{{idx}}_remarks" name="erpDockerList[{{idx}}].remarks" rows="4" maxlength="255" class="input-small ">{{row.remarks}}</textarea>
							</td>
							<shiro:hasPermission name="erp:erpShipments:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#erpDockerList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var erpDockerRowIdx = 0, erpDockerTpl = $("#erpDockerTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(erpShipments.erpDockerList)};
							for (var i=0; i<data.length; i++){
								addRow('#erpDockerList', erpDockerRowIdx, erpDockerTpl, data[i]);
								erpDockerRowIdx = erpDockerRowIdx + 1;
							}
						});
					</script>
				</div>
			</div>
		<div class="form-actions">
			<shiro:hasPermission name="erp:erpShipments:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>