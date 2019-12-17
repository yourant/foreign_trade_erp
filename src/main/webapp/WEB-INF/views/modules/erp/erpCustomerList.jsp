<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户管理</title>
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
		<li class="active"><a href="${ctx}/erp/erpCustomer/">客户列表</a></li>
		<shiro:hasPermission name="erp:erpCustomer:edit"><li><a href="${ctx}/erp/erpCustomer/form">客户添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="erpCustomer" action="${ctx}/erp/erpCustomer/" method="post" class="breadcrumb form-search">
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
			<li><label>所属员工：</label>
				<sys:treeselect id="user" name="user.id" value="${erpCustomer.user.id}" labelName="user.name" labelValue="${erpCustomer.user.name}"
					title="用户" url="/sys/office/treeData?type=3" cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li><label>名称：</label>
				<form:input path="aname" htmlEscape="false" maxlength="25" class="input-medium"/>
			</li>
			<li><label>公司：</label>
				<form:input path="company" htmlEscape="false" maxlength="50" class="input-medium"/>
			</li>
			<li><label>邮箱：</label>
				<form:input path="email" htmlEscape="false" maxlength="25" class="input-medium"/>
			</li>
			<li><label>电话：</label>
				<form:input path="phone" htmlEscape="false" maxlength="12" class="input-medium"/>
			</li>
			<li><label>地址：</label>
				<form:input path="address" htmlEscape="false" maxlength="100" class="input-medium"/>
			</li>
			<li><label>国家：</label>
			 	<sys:treeselect id="sysCountry" name="sysCountry.id" value="${erpCustomer.sysCountry.id}"
                            labelName="sysCountry.name" labelValue="${erpCustomer.sysCountry.name}"
                            title="国家" url="/autoComplete/treeData?type=3" viewName="view_country"
                            cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li><label>客户来源：</label>
				<form:select path="enmuCustomerSource" class="input-medium2">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('enmu_customer_source')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>客户类型：</label>
				<form:select path="enmuCustomerType" class="input-medium2">
					<form:option value="" label="全部"/>
					<form:options items="${fns:getDictList('enmu_customer_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>是否删除：</label>
				<form:select path="delFlag" class="input-medium2">
					<form:option value="" label="全部"/>
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
				<th class="sort-column u2.name">所属员工</th>
				<th class="sort-column aname">联系人</th>
				<th class="sort-column o3.name">公司</th>
				<th class="sort-column email">邮箱</th>
				<th class="sort-column phone">电话</th>
				<th class="sort-column address">地址</th>
				<th class="sort-column sc.aname">国家</th>
				<th class="sort-column enmu_customer_source">客户来源</th>
				<th class="sort-column enmu_customer_type">客户类型</th>
				<th class="sort-column updateDate"> 最后跟踪时间</th>
				<th >备注信息</th>
				<%--<th class="sort-column delFlag">是否删除</th>--%>
				<shiro:hasPermission name="erp:erpCustomer:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody id="dndTable">
		<c:forEach items="${page.list}" var="erpCustomer">
			<tr>
				<td>
                    <input type="checkbox" class="my-checkbox" name="ids" value="${erpCustomer.id}"/>
				</td>
				<td>
				<%-- <a href="javascript:showDialogByUrl('${ctx}/erp/erpCustomer/view?id=${erpCustomer.id}','查看详情');" target="_blank"> --%>
				<a href="${ctx}/erp/erpCustomer/view?id=${erpCustomer.id}">
					${erpCustomer.user.name}
				</a></td>
				<td>
					${erpCustomer.aname}
				</td>
				<td>
					<a href="javascript:showDialogByUrl('${ctx}/erp/erpCustomerVisit?erpCustomerId=${erpCustomer.id}','跟踪管理 - ${erpCustomer.company}',null,1000,500);">
                        ${erpCustomer.company}
					</a>
				</td>
				<td>
					${erpCustomer.email}
				</td>
				<td>
					${erpCustomer.phone}
				</td>
				<td>
					${erpCustomer.address}
				</td>
				<td>
					${erpCustomer.sysCountry.aname}
				</td>
				<td>
					${fns:getDictLabel(erpCustomer.enmuCustomerSource, 'enmu_customer_source', '')}
				</td>
				<td>
					${fns:getDictLabel(erpCustomer.enmuCustomerType, 'enmu_customer_type', '')}
				</td>
				<td>
					<fmt:formatDate value="${erpCustomer.updateDate}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
					${erpCustomer.remarks}
				</td>
				<%--<td>--%>
					<%--${fns:getDictLabel(erpCustomer.delFlag, 'del_flag', '')}--%>
				<%--</td>--%>
				<shiro:hasPermission name="erp:erpCustomer:edit"><td>
    				<a href="${ctx}/erp/erpCustomer/form?id=${erpCustomer.id}">修改</a>
					<a href="${ctx}/erp/erpCustomer/delete?id=${erpCustomer.id}" onclick="return confirmx('确认要删除该客户吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>