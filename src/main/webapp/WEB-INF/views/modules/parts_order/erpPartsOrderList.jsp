<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>配件订单管理</title>
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
		<li class="active"><a href="${ctx}/erp/erpPartsOrder/">配件订单列表</a></li>
		<shiro:hasPermission name="erp:erpPartsOrder:edit"><li><a href="${ctx}/erp/erpPartsOrder/form">配件订单添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="erpPartsOrder" action="${ctx}/erp/erpPartsOrder/" method="post" class="breadcrumb form-search">
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
			<li><label>PI：</label>
				<form:input path="pi" htmlEscape="false" maxlength="25" class="input-medium"/>
			</li>
			<li><label>订单状态：</label>
				<form:select path="status" class="input-medium2">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('status_parts_order')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>更新日期：</label>
				<input name="updateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${erpPartsOrder.updateDate}" pattern="yyyy-MM-dd"/>"
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
				<th class="sort-column pi">PI</th>
				<th >查看配件信息</th>
				<th class="sort-column status">状态</th>
				<th class="sort-column updateDate">更新时间</th>
				<th >备注信息</th>
				<shiro:hasPermission name="erp:erpPartsOrder:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody id="dndTable">
		<c:forEach items="${page.list}" var="erpPartsOrder" varStatus="status">
			<tr>
				<td>
                    <input type="checkbox" class="my-checkbox" name="ids" value="${erpPartsOrder.id}"/>
				</td>
				<td>
				<%-- <a href="javascript:showDialogByUrl('${ctx}/erp/erpPartsOrder/view?id=${erpPartsOrder.id}','查看详情');" target="_blank"> --%>
				<a href="${ctx}/erp/erpPartsOrder/view?id=${erpPartsOrder.id}">
					${erpPartsOrder.pi}
				</a></td>
				<td>
					<c:if test="${erpPartsOrder.status > 1}">
						<a onclick="showItemsDialog('${ctx}/erp/erpPartsOrder/sendItemView?id=${erpPartsOrder.id}','查看配件信息')">
							查看配件信息
						</a>
					</c:if>
				</td>
				<td>
					${fns:getDictLabel(erpPartsOrder.status, 'status_parts_order', '')}
				</td>
				<td>
					<fmt:formatDate value="${erpPartsOrder.updateDate}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
					<textarea id="td-repairMethod-${status.index}" style="display:none;">
							${erpPartsOrder.remarks}
					</textarea>
					<a href="javascript:showDialogByIdVal('td-repairMethod-${status.index}','备注信息');">
							${fns:abbr(fns:replaceHtml(erpPartsOrder.remarks),15)}
					</a>
				</td>
				<%--
							erpPartsOrder.status
							配件状态：（1：新建配件订单；2：录入配件信息；
										3：配件审批通过；4：配件审批未通过；
										5：会计确认收款；6：收款审批通过：7：收款审批未通过；
										8：录入发货信息；9：发货信息审批通过；10：发货信息审批未通过；
										11：配件快递发货；12：录入快递账单：13：配件装箱发货；14：海关放行；
										15：订单完成）
							--%>
				<td>
				<c:if test="${fns:contains(erpPartsOrder.status,'1,2,4')}">
					<shiro:hasPermission name="erp:erpPartsOrder:sendItemForm">
						<a href="${ctx}/erp/erpPartsOrder/sendItemForm?id=${erpPartsOrder.id}">录入配件信息</a>
					</shiro:hasPermission>
				</c:if>
				<c:if test="${fns:contains(erpPartsOrder.status,'3,5,7')}">
					<shiro:hasPermission name="erp:erpPartsOrder:sendItemForm">
						<a href="${ctx}/erp/erpPartsOrder/sendItemForm?id=${erpPartsOrder.id}">录入收款信息</a>
					</shiro:hasPermission>
				</c:if>
				<c:if test="${fns:contains(erpPartsOrder.status,'6,8,10')}">
					<shiro:hasPermission name="erp:erpPartsOrder:sendItemForm">
						<a href="${ctx}/erp/erpPartsOrder/sendItemForm?id=${erpPartsOrder.id}">录入发货信息</a>
					</shiro:hasPermission>
				</c:if>
				<c:if test="${erpPartsOrder.status == null}">
					<shiro:hasPermission name="erp:erpPartsOrder:edit">
						<a href="${ctx}/erp/erpPartsOrder/form?id=${erpPartsOrder.id}">录入配件订单</a>
					</shiro:hasPermission>
				</c:if>
                <shiro:hasPermission name="erp:erpPartsOrder:delete">
                    <a href="${ctx}/erp/erpPartsOrder/delete?id=${erpPartsOrder.id}" onclick="return confirmx('确认要删除该配件订单吗？', this.href)">删除</a>
                </shiro:hasPermission>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>