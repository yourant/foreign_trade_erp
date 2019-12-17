<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>支付类型管理</title>
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
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/erp/erpPayType/">支付类型列表</a></li>
		<shiro:hasPermission name="erp:erpPayType:edit"><li><a href="${ctx}/erp/erpPayType/form">支付类型添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="erpPayType" action="${ctx}/erp/erpPayType/" method="post" class="breadcrumb form-search">
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
			<li><label>销售订单：</label>
				<form:input path="erpSalesOrder.id" htmlEscape="false" maxlength="64" class="input-medium"/>
			</li>
			<li><label>付款方式：</label>
				<form:select path="enmuPaymentType" class="input-medium2">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('enmu_payment_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>付款方式比例：</label>
				<form:input path="scale" htmlEscape="false" class="input-medium"/>
			</li>
			<li><label>订单金额：</label>
				<form:input path="sumPrice" htmlEscape="false" class="input-medium"/>
			</li>
			<li><label>更新日期：</label>
				<input name="updateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${erpPayType.updateDate}" pattern="yyyy-MM-dd"/>"
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
				<th class="sort-column erpSalesOrder.id">销售订单</th>
				<th class="sort-column enmuPaymentType">付款方式</th>
				<th class="sort-column scale">付款方式比例</th>
				<th class="sort-column sumPrice">订单金额</th>
				<th class="sort-column updateDate">更新时间</th>
				<th >备注信息</th>
				<shiro:hasPermission name="erp:erpPayType:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody id="dndTable">
		<c:forEach items="${page.list}" var="erpPayType">
			<tr>
				<td>
                    <input type="checkbox" class="my-checkbox" name="ids" value="${erpPayType.id}"/>
				</td>
				<td>
				<%-- <a href="javascript:showDialogByUrl('${ctx}/erp/erpPayType/view?id=${erpPayType.id}','查看详情');" target="_blank"> --%>
				<a href="${ctx}/erp/erpPayType/view?id=${erpPayType.id}">
					${erpPayType.erpSalesOrder.id}
				</a></td>
				<td>
					${fns:getDictLabel(erpPayType.enmuPaymentType, 'enmu_payment_type', '')}
				</td>
				<td>
					${erpPayType.scale}
				</td>
				<td>
					${erpPayType.sumPrice}
				</td>
				<td>
					<fmt:formatDate value="${erpPayType.updateDate}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
					${erpPayType.remarks}
				</td>
				<shiro:hasPermission name="erp:erpPayType:edit"><td>
    				<a href="${ctx}/erp/erpPayType/form?id=${erpPayType.id}">修改</a>
					<a href="${ctx}/erp/erpPayType/delete?id=${erpPayType.id}" onclick="return confirmx('确认要删除该支付类型吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>