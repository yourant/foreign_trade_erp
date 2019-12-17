<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>三包订单管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//全选
            $("#all").click(function(){
                if(this.checked) {
                    $("input[name='ids']").prop("checked",true);
                }
                else {
                    $("input[name='ids']").prop("checked",false);
                }
            });
            //单选
            $("input[name='ids']").click(function () {
                isall = $("input[name='ids']").length == $("input[name='ids']:checked").length;
                $('#all').prop('checked', isall);
            });
            //表格样式
            $("#dndTable").children("tr").hover(function () {
                $(this.cells).css('background', '#E4E4E4').eq(0).addClass('showDragHandle');
            }, function () {
                $(this.cells).css('background', '').eq(0).removeClass('showDragHandle');
            }).click(function () {//点击背景变色
                if (window._preCells) $(window._preCells).removeClass('my-text-shadow');
                $(window._preCells = this.cells).addClass('my-text-shadow');
            });
            //重置表单
            $("#btnReset").click(function(){
                $("#searchForm")[0].reset();
            });
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
        function showItemsDialog(url, title) {
            showDialogByUrl(url, title, window);
        }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/erp/erpRepairOrder/">三包订单列表</a></li>
		<shiro:hasPermission name="erp:erpRepairOrder:edit"><li><a href="${ctx}/erp/erpRepairOrder/form">三包订单添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="erpRepairOrder" action="${ctx}/erp/erpRepairOrder/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<input id="orderBy" name="orderBy" type="hidden" value="${page.orderBy}">
		<script type="text/javascript">
            $(document).ready(function() {
                var orderBy = $("#orderBy").val().split(" ");
                $(".sort-column").each(function(){
                    if ($(this).hasClass(orderBy[0])){
                        orderBy[1] = orderBy[1]&&orderBy[1].toUpperCase()=="DESC"?"down":"up";
                        $(this).html($(this).html()+" <i class=\"icon icon-arrow-"+orderBy[1]+"\"></i>");
                    }
                });
                $(".sort-column").click(function(){
                    var order = $(this).attr("class").split(" ");
                    var sort = $("#orderBy").val().split(" ");
                    for(var i=0; i<order.length; i++){
                        if (order[i] == "sort-column"){order = order[i+1]; break;}
                    }
                    if (order == sort[0]){
                        sort = (sort[1]&&sort[1].toUpperCase()=="DESC"?"ASC":"DESC");
                        $("#orderBy").val(order+" DESC"!=order+" "+sort?"":order+" "+sort);
                    }else{
                        $("#orderBy").val(order+" ASC");
                    }
                    page();
                });
            });
		</script>
		<ul class="ul-form">
			<li><label>解决类型：</label>
				<form:select path="enumSolutionType" class="input-medium2">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('enum_solution_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>售后问题：</label>
				<form:input path="question" htmlEscape="false" class="input-medium"/>
			</li>
			<li><label>维修方法：</label>
				<form:input path="repairMethod" htmlEscape="false" class="input-medium"/>
			</li>
			<li><label>维修配件：</label>
				<form:input path="requireParts" htmlEscape="false" class="input-medium"/>
			</li>
			<li><label>三包状态：</label>
				<form:select path="status" class="input-medium2">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('status_repair_order')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>更新日期：</label>
				<input name="updateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${erpRepairOrder.updateDate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</li>
			<li><label>备注信息：</label>
				<form:input path="remarks" htmlEscape="false" maxlength="255" class="input-medium"/>
			</li>
			<li><label>删除标记：</label>
				<form:select path="delFlag" class="input-medium2">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('del_flag')}" itemLabel="label" itemValue="value"
								  htmlEscape="false"/>
				</form:select>
			</li>
			<li class="btns">
				<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
				<input id="btnReset" class="btn btn-default" type="reset" value="重置"/>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th class="checkbox-width"><input type="checkbox" class="my-checkbox" name="all" id="all"/>全选</th>
				<th class="sort-column enumSolutionType">解决方案类型</th>
				<shiro:hasPermission name="erp:erpRepairOrder:sendItemView"><th >查看发货信息</th></shiro:hasPermission>
				<th >售后问题</th>
				<th >维修方法</th>
				<th >维修配件</th>
				<th class="sort-column status">三包状态</th>
				<th class="sort-column updateDate">更新时间</th>
				<th >备注信息</th>
				<shiro:hasPermission name="erp:erpRepairOrder:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody id="dndTable">
		<c:forEach items="${page.list}" var="erpRepairOrder" varStatus="status">
			<tr>
				<td>
                    <input type="checkbox" class="my-checkbox" name="ids" value="${erpRepairOrder.id}"/>
				</td>
				<td>
				<%-- <a href="javascript:showDialogByUrl('${ctx}/erp/erpRepairOrder/view?id=${erpRepairOrder.id}','查看详情');" target="_blank"> --%>
				<a onclick="showItemsDialog('${ctx}/erp/erpRepairOrder/view?id=${erpRepairOrder.id}','查看三包订单')">
					${fns:getDictLabel(erpRepairOrder.enumSolutionType, 'enum_solution_type', '')}
				</a></td>
				<shiro:hasPermission name="erp:erpRepairOrder:sendItemView">
					<td>
						<c:if test="${erpRepairOrder.status > 2}">
							<a onclick="showItemsDialog('${ctx}/erp/erpRepairOrder/sendItemView?id=${erpRepairOrder.id}','查看发货信息')">
								查看发货信息
							</a>
						</c:if>
					</td>
				</shiro:hasPermission>
				<td>
					<textarea id="td-question-${status.index}" style="display:none;">
							${erpRepairOrder.question}
					</textarea>
					<a href="javascript:showDialogByIdVal('td-question-${status.index}','售后问题');">
							${fns:abbr(fns:replaceHtml(erpRepairOrder.question),20)}
					</a>
				</td>
				<td>
					<textarea id="td-repairMethod-${status.index}" style="display:none;">
							${erpRepairOrder.repairMethod}
					</textarea>
					<a href="javascript:showDialogByIdVal('td-repairMethod-${status.index}','维修方法');">
							${fns:abbr(fns:replaceHtml(erpRepairOrder.repairMethod),20)}
					</a>
				</td>
				<td>
					<textarea id="td-requireParts-${status.index}" style="display:none;">
							${erpRepairOrder.requireParts}
					</textarea>
					<a href="javascript:showDialogByIdVal('td-requireParts-${status.index}','维修配件');">
							${fns:abbr(fns:replaceHtml(erpRepairOrder.requireParts),20)}
					</a>
				</td>
				<td>
					${fns:getDictLabel(erpRepairOrder.status, 'status_repair_order', '')}
				</td>
				<td>
					<fmt:formatDate value="${erpRepairOrder.updateDate}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
					<textarea id="td-remarks-${status.index}" style="display:none;">
							${erpRepairOrder.remarks}
					</textarea>
					<a href="javascript:showDialogByIdVal('td-remarks-${status.index}','备注信息');">
							${fns:abbr(fns:replaceHtml(erpRepairOrder.remarks),15)}
					</a>
				</td>
					<%--
                            erpRepairOrder.status
                            三包状态：（ 1：新建三包；2：维修结束；3：录入配件信息；4：配件审批通过；5：配件审批未通过；
										6：录入发货信息；7：发货信息审批通过；8：发货信息审批未通过；
										9：配件快递发货；10：录入快递账单：11：配件装箱发货；12：海关放行；13：订单完成）
							erpRepairOrder.enumSolutionType
							解决方案类型：（1：维修；2：发配件）
                            --%>
				<td>
					<c:if test="${fns:contains(erpRepairOrder.status,'1,5') && erpRepairOrder.enumSolutionType == '2'}">
						<shiro:hasPermission name="erp:erpRepairOrder:sendItemForm">
							<a href="${ctx}/erp/erpRepairOrder/sendItemForm?id=${erpRepairOrder.id}">录入配件信息</a>
						</shiro:hasPermission>
					</c:if>
					<c:if test="${fns:contains(erpRepairOrder.status,'1') && erpRepairOrder.enumSolutionType == '1'}">
						<shiro:hasPermission name="erp:erpRepairOrder:erpRepairMethodForm">
							<a href="${ctx}/erp/erpRepairOrder/erpRepairMethodForm?id=${erpRepairOrder.id}">录入维修方法</a>
						</shiro:hasPermission>
					</c:if>
					<c:if test="${fns:contains(erpRepairOrder.status,'4,6,8') && erpRepairOrder.enumSolutionType == '2'}">
						<shiro:hasPermission name="erp:erpRepairOrder:sendItemForm">
							<a href="${ctx}/erp/erpRepairOrder/sendItemForm?id=${erpRepairOrder.id}">录入发货信息</a>
						</shiro:hasPermission>
					</c:if>
					<c:if test="${erpRepairOrder.status == null}">
						<shiro:hasPermission name="erp:erpRepairOrder:edit">
							<a href="${ctx}/erp/erpRepairOrder/form?id=${erpRepairOrder.id}">录入三包订单</a>
						</shiro:hasPermission>
					</c:if>
					<shiro:hasPermission name="erp:erpRepairOrder:delete">
						<a href="${ctx}/erp/erpRepairOrder/delete?id=${erpRepairOrder.id}" onclick="return confirmx('确认要删除该三包订单吗？', this.href)">删除</a>
					</shiro:hasPermission>
				</td>

			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>