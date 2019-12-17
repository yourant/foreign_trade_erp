<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>快递管理</title>
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
		<li class="active"><a href="${ctx}/erp/erpExpress/">快递列表</a></li>
		<shiro:hasPermission name="erp:erpExpress:edit"><li><a href="${ctx}/erp/erpExpress/form">快递添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="erpExpress" action="${ctx}/erp/erpExpress/" method="post" class="breadcrumb form-search">
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
			<li><label>快递单号：</label>
				<form:input path="expressNo" htmlEscape="false" maxlength="25" class="input-medium"/>
			</li>
			<li><label>快递公司：</label>
				<form:select path="enumExpressCompany" class="input-medium2">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('enum_express_company')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>快递费：</label>
				<form:input path="price" htmlEscape="false" class="input-medium"/>
			</li>
			<li><label>更新日期：</label>
				<input name="updateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${erpExpress.updateDate}" pattern="yyyy-MM-dd"/>"
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
				<th class="sort-column expressNo">快递单号</th>
				<th class="sort-column enumExpressCompany">快递公司</th>
				<th class="sort-column price">快递费</th>
				<th class="sort-column updateDate">更新时间</th>
				<th >备注信息</th>
				<th class="sort-column delFlag">删除标记</th>
				<shiro:hasPermission name="erp:erpExpress:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody id="dndTable">
		<c:forEach items="${page.list}" var="erpExpress">
			<tr>
				<td>
                    <input type="checkbox" class="my-checkbox" name="ids" value="${erpExpress.id}"/>
				</td>
				<td>
				<%-- <a href="javascript:showDialogByUrl('${ctx}/erp/erpExpress/view?id=${erpExpress.id}','查看详情');" target="_blank"> --%>
				<a href="${ctx}/erp/erpExpress/view?id=${erpExpress.id}">
					${erpExpress.expressNo}
				</a></td>
				<td>
					${fns:getDictLabel(erpExpress.enumExpressCompany, 'enum_express_company', '')}
				</td>
				<td>
					${erpExpress.price}
				</td>
				<td>
					<fmt:formatDate value="${erpExpress.updateDate}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
					${erpExpress.remarks}
				</td>
				<td>
					${fns:getDictLabel(erpExpress.delFlag, 'del_flag', '')}
				</td>
				<shiro:hasPermission name="erp:erpExpress:edit"><td>
    				<a href="${ctx}/erp/erpExpress/form?id=${erpExpress.id}">修改</a>
					<a href="${ctx}/erp/erpExpress/delete?id=${erpExpress.id}" onclick="return confirmx('确认要删除该快递吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>