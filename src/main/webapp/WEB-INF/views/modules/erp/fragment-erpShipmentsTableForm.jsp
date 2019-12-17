<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>发货单管理</title>
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
		<li><a href="${ctx}/erp/erpShipments/">发货单列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpShipments/form?id=${erpShipments.id}">发货单<shiro:hasPermission name="erp:erpShipments:edit">${not empty erpShipments.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpShipments:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="erpShipments" action="${ctx}/erp/erpShipments/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		

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