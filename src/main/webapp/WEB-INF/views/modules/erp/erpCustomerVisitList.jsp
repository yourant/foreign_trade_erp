<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户跟踪管理</title>
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
	<ul class="nav nav-tabs my-nav-tabs">
		<li class="active"><a href="${ctx}/erp/erpCustomerVisit/">客户跟踪列表</a></li>
		<shiro:hasPermission name="erp:erpCustomerVisit:edit"><li><a href="${ctx}/erp/erpCustomerVisit/form">客户跟踪添加</a></li></shiro:hasPermission>
	</ul>
	<div class="my-container">
		<form:form id="searchForm" modelAttribute="erpCustomerVisit" action="${ctx}/erp/erpCustomerVisit/" method="post" class="breadcrumb form-search">
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
				<li><label>跟进时间：</label>
					<input name="followUpDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
						value="<fmt:formatDate value="${erpCustomerVisit.followUpDate}" pattern="yyyy-MM-dd"/>"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
				</li>
				<li><label>跟进产品：</label>
					<form:input path="production" htmlEscape="false" maxlength="50" class="input-medium"/>
				</li>
				<li><label>跟进状态文件：</label>
					<form:input path="stateFile" htmlEscape="false" maxlength="255" class="input-medium"/>
				</li>
				<li><label>预计成交时间：</label>
					<input name="intentionDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
						value="<fmt:formatDate value="${erpCustomerVisit.intentionDate}" pattern="yyyy-MM-dd"/>"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
				</li>
				<li><label>客户等级：</label>
					<form:select path="customerLevel" class="input-medium2">
						<form:option value="" label="全部"/>
						<form:options items="${fns:getDictList('enum_customer_level')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</li>
				<%--<li><label>客户外键：</label>--%>
					<%--<sys:treeselect id="erpCustomer" name="erpCustomer.id" value="${erpCustomerVisit.erpCustomer.id}"--%>
								<%--labelName="erpCustomer.name" labelValue="${erpCustomerVisit.erpCustomer.name}"--%>
								<%--title="客户外键" url="/autoComplete/treeData?type=3" viewName="view_customer"--%>
								<%--cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>--%>
				<%--</li>--%>
				<li><label>创建人：</label>
					<sys:treeselect id="createBy" name="createBy.id" value="${erpCustomerVisit.createBy.id}" labelName="createBy.name" labelValue="${erpCustomerVisit.createBy.name}"
						title="用户" url="/sys/office/treeData?type=3" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
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
					<th >跟进时间</th>
					<th >跟进产品</th>
					<th >跟进状态</th>
					<th >预计成交时间</th>
					<th >客户等级</th>
					<%--<th >客户外键</th>--%>
					<th >更新时间</th>
					<th >删除标记</th>
					<shiro:hasPermission name="erp:erpCustomerVisit:edit"><th>操作</th></shiro:hasPermission>
				</tr>
			</thead>
			<tbody id="dndTable">
			<c:forEach items="${page.list}" var="erpCustomerVisit">
				<tr>
					<td>
						<input type="checkbox" class="my-checkbox" name="ids" value="${erpCustomerVisit.id}"/>
					</td>
					<td>
					<%-- <a href="javascript:showDialogByUrl('${ctx}/erp/erpCustomerVisit/view?id=${erpCustomerVisit.id}','查看详情');" target="_blank"> --%>
					<a href="${ctx}/erp/erpCustomerVisit/view?id=${erpCustomerVisit.id}">
						<fmt:formatDate value="${erpCustomerVisit.followUpDate}" pattern="yyyy-MM-dd"/>
					</a></td>
					<td>
						${erpCustomerVisit.production}
					</td>
					<td>
						${erpCustomerVisit.stateFile}
					</td>
					<td>
						<fmt:formatDate value="${erpCustomerVisit.intentionDate}" pattern="yyyy-MM-dd"/>
					</td>
					<td>
						${fns:getDictLabel(erpCustomerVisit.customerLevel, 'enum_customer_level', '')}
					</td>
					<%--<td>--%>
						<%--${erpCustomerVisit.erpCustomer.id}--%>
					<%--</td>--%>
					<td>
						<fmt:formatDate value="${erpCustomerVisit.updateDate}" pattern="yyyy-MM-dd"/>
					</td>
					<td>
						${fns:getDictLabel(erpCustomerVisit.delFlag, 'del_flag', '')}
					</td>
					<shiro:hasPermission name="erp:erpCustomerVisit:edit"><td>
						<a href="${ctx}/erp/erpCustomerVisit/form?id=${erpCustomerVisit.id}">修改</a>
						<a href="${ctx}/erp/erpCustomerVisit/delete?id=${erpCustomerVisit.id}" onclick="return confirmx('确认要删除该客户跟踪吗？', this.href)">删除</a>
					</td></shiro:hasPermission>
				</tr>
			</c:forEach>
			</tbody>
		</table>
		<div class="pagination">${page}</div>
	</div>
</body>
</html>