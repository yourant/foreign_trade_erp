<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>配件管理</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {
            //全选
            $("#all").click(function () {
                if (this.checked) {
                    $("input[name='ids']").prop("checked", true);
                }
                else {
                    $("input[name='ids']").prop("checked", false);
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
            $("#btnReset").click(function () {
                $("#searchForm")[0].reset();
            });

            // 导出按钮点击事件
            $("#btnExport").click(function () {
                var oldAction = $("#searchForm").attr('action');
                $("#searchForm").attr({'action': oldAction + 'exportXls', 'target': '_blank'}).submit();
                setTimeout(function () {
                    $("#searchForm").attr({'action': oldAction}).removeAttr('target');
                }, 500);
            });

        });

        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }
    </script>
</head>
<body>
<ul class="nav nav-tabs">
    <li class="active"><a href="${ctx}/erp/erpCarParts/">配件列表</a></li>
    <shiro:hasPermission name="erp:erpCarParts:edit">
        <li><a href="${ctx}/erp/erpCarParts/form">配件添加</a></li>
    </shiro:hasPermission>
</ul>
<form:form id="searchForm" modelAttribute="erpCarParts" action="${ctx}/erp/erpCarParts/" method="post"
           class="breadcrumb form-search">
    <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
    <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
    <input id="orderBy" name="orderBy" type="hidden" value="${page.orderBy}">
    <script type="text/javascript">
        $(document).ready(function () {
            var orderBy = $("#orderBy").val().split(" ");
            $(".sort-column").each(function () {
                if ($(this).hasClass(orderBy[0])) {
                    orderBy[1] = orderBy[1] && orderBy[1].toUpperCase() == "DESC" ? "down" : "up";
                    $(this).html($(this).html() + " <i class=\"icon icon-arrow-" + orderBy[1] + "\"></i>");
                }
            });
            $(".sort-column").click(function () {
                var order = $(this).attr("class").split(" ");
                var sort = $("#orderBy").val().split(" ");
                for (var i = 0; i < order.length; i++) {
                    if (order[i] == "sort-column") {
                        order = order[i + 1];
                        break;
                    }
                }
                if (order == sort[0]) {
                    sort = (sort[1] && sort[1].toUpperCase() == "DESC" ? "ASC" : "DESC");
                    $("#orderBy").val(order + " DESC" != order + " " + sort ? "" : order + " " + sort);
                } else {
                    $("#orderBy").val(order + " ASC");
                }
                page();
            });
        });
    </script>
    <ul class="ul-form">
        <li><label>中文名称：</label>
            <form:input path="aname" htmlEscape="false" maxlength="50" class="input-medium"/>
        </li>
        <li><label>英文名称：</label>
            <form:input path="enName" htmlEscape="false" maxlength="50" class="input-medium"/>
        </li>
        <li><label>车型：</label>
            <sys:treeselect id="erpCarType" name="erpCarType.id" value="${erpCarParts.erpCarType.id}"
                            labelName="erpCarType.aname" labelValue="${erpCarParts.erpCarType.aname}"
                            title="车型" url="/autoComplete/treeData?type=3" viewName="view_car_type"
                            cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
        </li>
        <li><label>发动机型号：</label>
            <sys:treeselect id="erpEngineType" name="erpEngineType.id" value="${erpCarParts.erpEngineType.id}"
                            labelName="erpEngineType.aname" labelValue="${erpCarParts.erpEngineType.aname}"
                            title="发动机型号" url="/autoComplete/treeData?type=3" viewName="view_engine_type"
                            cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
        </li>
        <%--<li><label>价格：</label>--%>
            <%--<form:input path="price" htmlEscape="false" class="input-medium"/>--%>
        <%--</li>--%>
        <li><label>更新日期：</label>
            <input name="updateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
                   value="<fmt:formatDate value="${erpCarParts.updateDate}" pattern="yyyy-MM-dd"/>"
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
            <input id="btnExport" class="btn btn-success" type="button" value="导出"/>
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
        <th class="sort-column aname">中文名称</th>
        <th class="sort-column enName">英文名称</th>
        <th class="sort-column ct.aname">车型</th>
        <th class="sort-column et.aname">发动机型号</th>
        <th>配件图片</th>
        <th class="sort-column price">价格</th>
        <th class="sort-column updateDate">更新时间</th>
        <th class="sort-column remarks">备注信息</th>
        <shiro:hasPermission name="erp:erpCarParts:edit">
            <th>操作</th>
        </shiro:hasPermission>
    </tr>
    </thead>
    <tbody id="dndTable">
    <c:forEach items="${page.list}" var="erpCarParts">
        <tr>
            <td>
                <input type="checkbox" class="my-checkbox" name="ids" value="${erpCarParts.id}"/>
            </td>
            <td>
                    <%-- <a href="javascript:showDialogByUrl('${ctx}/erp/erpCarParts/view?id=${erpCarParts.id}','查看详情');" target="_blank"> --%>
                <a href="${ctx}/erp/erpCarParts/view?id=${erpCarParts.id}">
                        ${erpCarParts.aname}
                </a></td>
            <td>
                    ${erpCarParts.enName}
            </td>
            <td>
                    ${erpCarParts.erpCarType.aname}
            </td>
            <td>
                    ${erpCarParts.erpEngineType.aname}
            </td>
            <td>
                <c:forEach items="${fn:split(erpCarParts.image,'||')}" var="img" varStatus="s">
                    <c:if test="${img ne ''}">
                        <a href="${img}" target="_blank">图片${s.index + 1}</a>
                    </c:if>
                </c:forEach>
            </td>
            <td>
                    ${fns:getDictLabel(erpCarParts.unit, 'price_unit', '')}${erpCarParts.price}
            </td>
            <td>
                <fmt:formatDate value="${erpCarParts.updateDate}" pattern="yyyy-MM-dd"/>
            </td>
            <td>
                <span title="${erpCarParts.remarks}">
                    ${fns:abbr(erpCarParts.remarks,15)}
                </span>
            </td>
            <shiro:hasPermission name="erp:erpCarParts:edit">
                <td>
                    <a href="${ctx}/erp/erpCarParts/form?id=${erpCarParts.id}">修改</a>
                    <a href="${ctx}/erp/erpCarParts/delete?id=${erpCarParts.id}"
                       onclick="return confirmx('确认要删除该配件吗？', this.href)">删除</a>
                </td>
            </shiro:hasPermission>
        </tr>
    </c:forEach>
    </tbody>
</table>
<div class="pagination">${page}</div>
</body>
</html>