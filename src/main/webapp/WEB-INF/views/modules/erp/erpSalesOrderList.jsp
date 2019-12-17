<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售订单管理</title>
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
        function showItemsDialog(url,title) {
            showDialogByUrl(url, title, window);
        }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/erp/erpSalesOrder/">销售订单列表</a></li>
		<shiro:hasPermission name="erp:erpSalesOrder:edit"><li><a href="${ctx}/erp/erpSalesOrder/form">销售订单添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="erpSalesOrder" action="${ctx}/erp/erpSalesOrder/" method="post" class="breadcrumb form-search">
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
			<li><label>客户：</label>
				<form:input path="erpCustomer.id" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li><label>人员名称：</label>
				<sys:treeselect id="user" name="user.id" value="${erpSalesOrder.user.id}" labelName="user.name" labelValue="${erpSalesOrder.user.name}"
					title="用户" url="/sys/office/treeData?type=3" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li><label>贸易形式：</label>
				<form:select path="enmuTradingType" class="input-medium2">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('enmu_trading_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>PI：</label>
				<form:input path="piNo" htmlEscape="false" maxlength="25" class="input-medium"/>
			</li>
			<li><label>简要生产计划：</label>
				<form:input path="productionPlain" htmlEscape="false" class="input-medium"/>
			</li>
			<li><label>下单日期：</label>
				<input name="orderTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${erpSalesOrder.orderTime}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</li>
			<li><label>销售提成：</label>
				<form:input path="commission" htmlEscape="false" class="input-medium"/>
			</li>
			<li><label>发放月份：</label>
				<input name="commissionMonth" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${erpSalesOrder.commissionMonth}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</li>
			<li><label>订单状态：</label>
				<form:select path="status" class="input-medium2">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('status_sales_order')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>更新日期：</label>
				<input name="updateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${erpSalesOrder.updateDate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</li>
			<li><label>备注信息：</label>
				<form:input path="remarks" htmlEscape="false" maxlength="255" class="input-medium"/>
			</li>
			<li><label>删除标记：</label>
				<form:select path="delFlag" class="input-medium2">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('del_flag')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
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
				<th class="sort-column piNo">PI</th>
				<th >客户</th>
				<th class="sort-column user.id">人员名称</th>
				<th class="sort-column enmuTradingType">贸易形式</th>
				<th >简要生产计划</th>
				<th class="sort-column orderTime">下单时间</th>
				<th class="sort-column commission">销售提成</th>
				<th class="sort-column commissionMonth">发放月份</th>
				<th class="sort-column status">订单状态</th>
				<th class="sort-column updateDate">更新时间</th>
				<th >备注信息</th>
				<shiro:hasPermission name="erp:erpSalesOrder:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody id="dndTable">
		<c:forEach items="${page.list}" var="erpSalesOrder">
			<tr>
				<td>
                    <input type="checkbox" class="my-checkbox" name="ids" value="${erpSalesOrder.id}"/>
				</td>
				<td>
					<a onclick="showItemsDialog('${ctx}/erp/erpSalesOrder/view?id=${erpSalesOrder.id}','销售订单查看')">
							${erpSalesOrder.piNo}
					</a>
				</td>
				<td>
					<a onclick="showItemsDialog('${ctx}/erp/erpCustomer/view?id=${erpSalesOrder.erpCustomer.id}','查看客户信息')">
						${erpSalesOrder.erpCustomer.aname}
					</a>
				</td>
				<td>
					${erpSalesOrder.user.name}
				</td>
				<td>
					${fns:getDictLabel(erpSalesOrder.enmuTradingType, 'enmu_trading_type', '')}
				</td>



				<td>
					${erpSalesOrder.productionPlain}
				</td>
				<td>
					<fmt:formatDate value="${erpSalesOrder.orderTime}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
					${erpSalesOrder.commission}
				</td>
				<td>
					<fmt:formatDate value="${erpSalesOrder.commissionMonth}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
					${fns:getDictLabel(erpSalesOrder.status, 'status_sales_order', '')}
				</td>
				<td>
					<fmt:formatDate value="${erpSalesOrder.updateDate}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
					${erpSalesOrder.remarks}
				</td>
				<shiro:hasPermission name="erp:erpSalesOrder:edit"><td>
					<a href="${ctx}/erp/erpSalesOrder/addProductionPlain?id=${erpSalesOrder.id}">新建生产计划</a>
					<a href="${ctx}/erp/erpSalesOrder/addPayType?id=${erpSalesOrder.id}">会计录入</a>
					<a href="${ctx}/erp/erpShipments/shipmentForm?salesOrderId=${erpSalesOrder.id}">发货</a>
					<a href="${ctx}/erp/erpSalesOrder/settlementWage?id=${erpSalesOrder.id}">结算工资</a>
    				<a href="${ctx}/erp/erpSalesOrder/form?id=${erpSalesOrder.id}">修改</a>
					<a href="${ctx}/erp/erpSalesOrder/delete?id=${erpSalesOrder.id}" onclick="return confirmx('确认要删除该销售订单吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>