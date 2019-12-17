<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>配件管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
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
		<li><a href="${ctx}/erp/erpCarParts/">配件列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpCarParts/form?id=${erpCarParts.id}">配件<shiro:hasPermission name="erp:erpCarParts:edit">${not empty erpCarParts.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpCarParts:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="erpCarParts" action="${ctx}/erp/erpCarParts/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		

			<div class="control-group">
				<label class="control-label">发货明细：</label>
				<div class="controls">
					<table id="contentTable" class="table table-striped table-bordered table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>数量</th>
								<th>发送配件类型</th>
								<th>快递</th>
								<th>配件订单</th>
								<th>三包订单</th>
								<th>发货单</th>
								<th>车架</th>
								<th>备注信息</th>
								<shiro:hasPermission name="erp:erpCarParts:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="erpSendItemsList">
						</tbody>
						<shiro:hasPermission name="erp:erpCarParts:edit"><tfoot>
							<tr><td colspan="10"><a href="javascript:" onclick="addRow('#erpSendItemsList', erpSendItemsRowIdx, erpSendItemsTpl);erpSendItemsRowIdx = erpSendItemsRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="erpSendItemsTpl">//<!--
						<tr id="erpSendItemsList{{idx}}">
							<td class="hide">
								<input id="erpSendItemsList{{idx}}_id" name="erpSendItemsList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="erpSendItemsList{{idx}}_delFlag" name="erpSendItemsList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="erpSendItemsList{{idx}}_count" name="erpSendItemsList[{{idx}}].count" type="text" value="{{row.count}}" maxlength="11" class="input-small "/>
							</td>
							<td>
								<select id="erpSendItemsList{{idx}}_enumSendItemsType" name="erpSendItemsList[{{idx}}].enumSendItemsType" data-value="{{row.enumSendItemsType}}" class="input-small ">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('enum_send_items_type')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<input id="erpSendItemsList{{idx}}_erpExpress" name="erpSendItemsList[{{idx}}].erpExpress.id" type="text" value="{{row.erpExpress.id}}" maxlength="64" class="input-small "/>
							</td>
							<td>
								<input id="erpSendItemsList{{idx}}_erpPartsOrder" name="erpSendItemsList[{{idx}}].erpPartsOrder.id" type="text" value="{{row.erpPartsOrder.id}}" maxlength="64" class="input-small "/>
							</td>
							<td>
								<input id="erpSendItemsList{{idx}}_erpRepairOrder" name="erpSendItemsList[{{idx}}].erpRepairOrder.id" type="text" value="{{row.erpRepairOrder.id}}" maxlength="64" class="input-small "/>
							</td>
							<td>
								<input id="erpSendItemsList{{idx}}_erpShipments" name="erpSendItemsList[{{idx}}].erpShipments.id" type="text" value="{{row.erpShipments.id}}" maxlength="64" class="input-small "/>
							</td>
							<td>
								<input id="erpSendItemsList{{idx}}_erpVin" name="erpSendItemsList[{{idx}}].erpVin.id" type="text" value="{{row.erpVin.id}}" maxlength="64" class="input-small "/>
							</td>
							<td>
								<textarea id="erpSendItemsList{{idx}}_remarks" name="erpSendItemsList[{{idx}}].remarks" rows="4" maxlength="255" class="input-small ">{{row.remarks}}</textarea>
							</td>
							<shiro:hasPermission name="erp:erpCarParts:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#erpSendItemsList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var erpSendItemsRowIdx = 0, erpSendItemsTpl = $("#erpSendItemsTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(erpCarParts.erpSendItemsList)};
							for (var i=0; i<data.length; i++){
								addRow('#erpSendItemsList', erpSendItemsRowIdx, erpSendItemsTpl, data[i]);
								erpSendItemsRowIdx = erpSendItemsRowIdx + 1;
							}
						});
					</script>
				</div>
			</div>
		<div class="form-actions">
			<shiro:hasPermission name="erp:erpCarParts:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>

</body>
</html>