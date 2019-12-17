<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>发货单管理</title>
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
		<li class="active"><a href="${ctx}/erp/erpShipments/">发货单列表</a></li>
		<shiro:hasPermission name="erp:erpShipments:edit"><li><a href="${ctx}/erp/erpShipments/form">发货单添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="erpShipments" action="${ctx}/erp/erpShipments/" method="post" class="breadcrumb form-search">
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
			<li><label>提单号：</label>
				<form:input path="blno" htmlEscape="false" maxlength="25" class="input-medium"/>
			</li>
			<li><label>提单类型：</label>
				<form:select path="enumBillType" class="input-medium2">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('enum_bill_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>发货日期：</label>
				<input name="deliveryTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${erpShipments.deliveryTime}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</li>
			<li><label>报关单号：</label>
				<form:input path="billManifestNo" htmlEscape="false" maxlength="255" class="input-medium"/>
			</li>
			<li><label>离港日期：</label>
				<input name="sendTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${erpShipments.sendTime}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</li>
			<li><label>预计到达日期：</label>
				<input name="preComeTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${erpShipments.preComeTime}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</li>
			<li><label>快递公司：</label>
				<form:select path="enumExpressCompany" class="input-medium2">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('enum_express_company')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>文件寄送单号：</label>
				<form:input path="expressNum" htmlEscape="false" maxlength="25" class="input-medium"/>
			</li>
			<li><label>货物类型：</label>
				<form:input path="enumShipmentsType" htmlEscape="false" maxlength="1" class="input-medium"/>
			</li>
			<li><label>发货状态：</label>
				<form:select path="status" class="input-medium2">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('status_shipments')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>更新日期：</label>
				<input name="updateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${erpShipments.updateDate}" pattern="yyyy-MM-dd"/>"
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
				<th class="sort-column blno">提单号</th>
				<th >入货通知附件</th>
				<th class="sort-column enumBillType">提单类型</th>
				<th class="sort-column deliveryTime">发货时间</th>
				<th class="sort-column billManifestNo">报关单号</th>
				<th >报关单附件</th>
				<th >提单附件</th>
				<th >海运账单附件</th>
				<th class="sort-column sendTime">离港时间</th>
				<th class="sort-column preComeTime">预计到达时间</th>
				<th class="sort-column enumExpressCompany">快递公司</th>
				<th class="sort-column expressNum">文件寄送单号</th>
				<th >快递单据附件</th>
				<th class="sort-column enumShipmentsType">货物类型</th>
				<th class="sort-column status">发货状态</th>
				<th class="sort-column updateDate">更新时间</th>
				<th >备注信息</th>
				<shiro:hasPermission name="erp:erpShipments:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody id="dndTable">
		<c:forEach items="${page.list}" var="erpShipments">
			<tr>
				<td>
                    <input type="checkbox" class="my-checkbox" name="ids" value="${erpShipments.id}"/>
				</td>
				<td>
				<%-- <a href="javascript:showDialogByUrl('${ctx}/erp/erpShipments/view?id=${erpShipments.id}','查看详情');" target="_blank"> --%>
				<a href="${ctx}/erp/erpShipments/view?id=${erpShipments.id}">
					${erpShipments.blno}
				</a></td>
				<td>
					${erpShipments.noticeFile}
				</td>
				<td>
					${fns:getDictLabel(erpShipments.enumBillType, 'enum_bill_type', '')}
				</td>
				<td>
					<fmt:formatDate value="${erpShipments.deliveryTime}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
					${erpShipments.billManifestNo}
				</td>
				<td>
					${erpShipments.billManifestFile}
				</td>
				<td>
					${erpShipments.billLadingFile}
				</td>
				<td>
					${erpShipments.priceManifestFile}
				</td>
				<td>
					<fmt:formatDate value="${erpShipments.sendTime}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
					<fmt:formatDate value="${erpShipments.preComeTime}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
					${fns:getDictLabel(erpShipments.enumExpressCompany, 'enum_express_company', '')}
				</td>
				<td>
					${erpShipments.expressNum}
				</td>
				<td>
					${erpShipments.expressFile}
				</td>
				<td>
					${erpShipments.enumShipmentsType}
				</td>
				<td>
					${fns:getDictLabel(erpShipments.status, 'status_shipments', '')}
				</td>
				<td>
					<fmt:formatDate value="${erpShipments.updateDate}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
					${erpShipments.remarks}
				</td>
				<shiro:hasPermission name="erp:erpShipments:edit"><td>
    				<a href="${ctx}/erp/erpShipments/form?id=${erpShipments.id}">修改</a>
					<a href="${ctx}/erp/erpShipments/delete?id=${erpShipments.id}" onclick="return confirmx('确认要删除该发货单吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>