<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售订单管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
        /**
         * mustache 列表上显示附件列表
         * @param content
         * @returns {*}
         */
        function madeUploadFilesData(content) {
            var contentList = null;
            if (content) {
                contentList = [];
                var ret = content.split('|');
                for (var i = 0; i < ret.length; i++) {
                    var ppFile = ret[i];
                    if (ppFile) {
                        contentList.push({
                            img: ppFile,
                            idx: i + 1
                        })
                    }
                }
            }
            return contentList;
        }

        function addRow(list, idx, tpl, row) {
            row.contentList = madeUploadFilesData(row.content);
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
		<li><a href="${ctx}/erp/erpSalesOrder/">销售订单列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpSalesOrder/form?id=${erpSalesOrder.id}">销售订单<shiro:hasPermission name="erp:erpSalesOrder:edit">${not empty erpSalesOrder.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpSalesOrder:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="erpSalesOrder" action="${ctx}/erp/erpSalesOrder/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		

			<div class="control-group">
				<label class="control-label">支付类型：</label>
				<div class="controls">
					<table id="contentTable" class="table table-striped table-bordered table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>付款方式</th>
								<th>付款方式比例</th>
								<th>订单金额</th>
								<th>备注信息</th>
								<shiro:hasPermission name="erp:erpSalesOrder:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="erpPayTypeList">
						</tbody>
						<shiro:hasPermission name="erp:erpSalesOrder:edit"><tfoot>
							<tr><td colspan="6"><a href="javascript:" onclick="addRow('#erpPayTypeList', erpPayTypeRowIdx, erpPayTypeTpl);erpPayTypeRowIdx = erpPayTypeRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="erpPayTypeTpl">//<!--
						<tr id="erpPayTypeList{{idx}}">
							<td class="hide">
								<input id="erpPayTypeList{{idx}}_id" name="erpPayTypeList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="erpPayTypeList{{idx}}_delFlag" name="erpPayTypeList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<select id="erpPayTypeList{{idx}}_enmuPaymentType" name="erpPayTypeList[{{idx}}].enmuPaymentType" data-value="{{row.enmuPaymentType}}" class="input-small required">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('enmu_payment_type')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<input id="erpPayTypeList{{idx}}_scale" name="erpPayTypeList[{{idx}}].scale" type="text" value="{{row.scale}}" class="input-small "/>
							</td>
							<td>
								<input id="erpPayTypeList{{idx}}_sumPrice" name="erpPayTypeList[{{idx}}].sumPrice" type="text" value="{{row.sumPrice}}" class="input-small  number"/>
							</td>
							<td>
								<textarea id="erpPayTypeList{{idx}}_remarks" name="erpPayTypeList[{{idx}}].remarks" rows="4" maxlength="255" class="input-small ">{{row.remarks}}</textarea>
							</td>
							<shiro:hasPermission name="erp:erpSalesOrder:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#erpPayTypeList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var erpPayTypeRowIdx = 0, erpPayTypeTpl = $("#erpPayTypeTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(erpSalesOrder.erpPayTypeList)};
							for (var i=0; i<data.length; i++){
								addRow('#erpPayTypeList', erpPayTypeRowIdx, erpPayTypeTpl, data[i]);
								erpPayTypeRowIdx = erpPayTypeRowIdx + 1;
							}
						});
					</script>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">生产订单：</label>
				<div class="controls">
					<table id="contentTable" class="table table-striped table-bordered table-condensed">
						<thead>
							<tr>
								<th class="hide"></th>
								<th>销售订单</th>
								<th>供应商</th>
								<th>生产计划</th>
								<th>下单日期</th>
								<th>备注信息</th>
								<shiro:hasPermission name="erp:erpSalesOrder:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
							</tr>
						</thead>
						<tbody id="erpProductionOrderList">
						</tbody>
						<shiro:hasPermission name="erp:erpSalesOrder:edit"><tfoot>
							<tr><td colspan="7"><a href="javascript:" onclick="addRow('#erpProductionOrderList', erpProductionOrderRowIdx, erpProductionOrderTpl);erpProductionOrderRowIdx = erpProductionOrderRowIdx + 1;" class="btn">新增</a></td></tr>
						</tfoot></shiro:hasPermission>
					</table>
					<script type="text/template" id="erpProductionOrderTpl">//<!--
						<tr id="erpProductionOrderList{{idx}}">
							<td class="hide">
								<input id="erpProductionOrderList{{idx}}_id" name="erpProductionOrderList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="erpProductionOrderList{{idx}}_delFlag" name="erpProductionOrderList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<input id="erpProductionOrderList{{idx}}_erpSalesOrder" name="erpProductionOrderList[{{idx}}].erpSalesOrder.id" type="text" value="{{row.erpSalesOrder.id}}" maxlength="64" class="input-small required"/>
							</td>
							<td>
								<select id="erpProductionOrderList{{idx}}_enmuProvider" name="erpProductionOrderList[{{idx}}].enmuProvider" data-value="{{row.enmuProvider}}" class="input-small ">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('enum_provider')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								{{#row.contentList}}
                                    <a href="{{img}}" target="_blank">生产计划附件{{idx}}</a>
                                {{/row.contentList}}
							</td>
							<td>
								<input id="erpProductionOrderList{{idx}}_orderTime" name="erpProductionOrderList[{{idx}}].orderTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
									value="{{row.orderTime}}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
							</td>
							<td>
								<textarea id="erpProductionOrderList{{idx}}_remarks" name="erpProductionOrderList[{{idx}}].remarks" rows="4" maxlength="255" class="input-small ">{{row.remarks}}</textarea>
							</td>
							<shiro:hasPermission name="erp:erpSalesOrder:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#erpProductionOrderList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var erpProductionOrderRowIdx = 0, erpProductionOrderTpl = $("#erpProductionOrderTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(erpSalesOrder.erpProductionOrderList)};
							for (var i=0; i<data.length; i++){
								addRow('#erpProductionOrderList', erpProductionOrderRowIdx, erpProductionOrderTpl, data[i]);
								erpProductionOrderRowIdx = erpProductionOrderRowIdx + 1;
							}
						});
					</script>
				</div>
			</div>
		<div class="form-actions">
			<shiro:hasPermission name="erp:erpSalesOrder:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>

</body>
</html>