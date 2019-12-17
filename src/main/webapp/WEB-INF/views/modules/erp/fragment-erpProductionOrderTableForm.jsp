<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>生产订单管理</title>
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
		<li><a href="${ctx}/erp/erpProductionOrder/">生产订单列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpProductionOrder/form?id=${erpProductionOrder.id}">生产订单<shiro:hasPermission name="erp:erpProductionOrder:edit">${not empty erpProductionOrder.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpProductionOrder:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="erpProductionOrder" action="${ctx}/erp/erpProductionOrder/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		

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
								<select id="erpProductionItemsList{{idx}}_erpEngineType" name="erpProductionItemsList[{{idx}}].erpEngineType.id" data-value="{{row.erpEngineType.id}}" class="input-small ">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<select id="erpProductionItemsList{{idx}}_erpCarType" name="erpProductionItemsList[{{idx}}].erpCarType.id" data-value="{{row.erpCarType.id}}" class="input-small ">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<input id="erpProductionItemsList{{idx}}_count" name="erpProductionItemsList[{{idx}}].count" type="text" value="{{row.count}}" maxlength="6" class="input-small "/>
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