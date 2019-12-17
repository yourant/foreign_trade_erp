<%@ page import="com.fy.erp.modules.sys.utils.UserUtils" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>销售订单管理</title>
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
        });
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }
        //重新刷新某个子页面的问题
        function showItemsDialog(url, title) {
            showDialogByUrl(url, title, window);
        }
    </script>
</head>
<body>
<ul class="nav nav-tabs my-nav-tabs">
    <li class="active"><a href="${ctx}/erp/erpSalesOrder/">销售订单列表</a></li>
    <shiro:hasPermission name="erp:erpSalesOrder:edit">
        <li><a href="${ctx}/erp/erpSalesOrder/form">销售订单添加</a></li>
    </shiro:hasPermission>
</ul>
<div class="my-container">
    <form:form id="searchForm" modelAttribute="erpSalesOrder" action="${ctx}/erp/erpSalesOrder/" method="post"
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
            <shiro:hasPermission name="erp:erpSalesOrder:seachErpCustomer">
                <li><label>客户：</label>
                    <sys:treeselect id="erpCustomer" name="erpCustomer.id" value="${erpSalesOrder.erpCustomer.id}"
                                    labelName="erpCustomer.aname" labelValue="${erpSalesOrder.erpCustomer.aname}"
                                    title="客户" url="/autoComplete/treeData?type=3"
                                    viewName="view_customer v WHERE v.enmuCustomerType =2 OR v.userId = '${fns:getUser().id}'"
                                    cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:seachUser">
                <li><label>人员名称：</label>
                    <sys:treeselect id="user" name="user.id" value="${erpSalesOrder.user.id}" labelName="user.name"
                                    labelValue="${erpSalesOrder.user.name}"
                                    title="用户" url="/sys/office/treeData?type=3" cssClass="input-small"
                                    allowClear="true" notAllowSelectParent="true"/>
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:seachTradingType">
                <li><label>贸易形式：</label>
                    <form:select path="enmuTradingType" class="input-medium2">
                        <form:option value="" label="全部"/>
                        <form:options items="${fns:getDictList('enmu_trading_type')}" itemLabel="label"
                                      itemValue="value" htmlEscape="false"/>
                    </form:select>
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:seachPiNo">
                <li><label>PI：</label>
                    <form:input path="piNo" htmlEscape="false" maxlength="25" class="input-medium"/>
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:seachProductionOrder">
                <li><label>简要生产计划：</label>
                    <form:input path="productionPlain" htmlEscape="false" class="input-medium"/>
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:seachOrderTime">
                <li><label>下单日期：</label>
                    <input name="orderTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
                           value="<fmt:formatDate value="${erpSalesOrder.orderTime}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:seachCommission">
                <li><label>销售提成：</label>
                    <form:input path="commission" htmlEscape="false" class="input-medium"/>
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:seachCommissionMonth">
                <li><label>发放月份：</label>
                    <input name="commissionMonth" type="text" readonly="readonly" maxlength="20"
                           class="input-medium Wdate"
                           value="<fmt:formatDate value="${erpSalesOrder.commissionMonth}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM',isShowClear:false});"/>
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:seachStatus">
                <li><label>订单状态：</label>
                    <form:select path="status" class="input-medium2">
                        <form:option value="" label="全部"/>
                        <form:options items="${fns:getDictList('status_sales_order')}" itemLabel="label"
                                      itemValue="value" htmlEscape="false"/>
                    </form:select>
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:seachUpdateDate">
                <li><label>更新日期：</label>
                    <input name="updateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
                           value="<fmt:formatDate value="${erpSalesOrder.updateDate}" pattern="yyyy-MM-dd"/>"
                           onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:seachRemarks">
                <li><label>备注信息：</label>
                    <form:input path="remarks" htmlEscape="false" maxlength="255" class="input-medium"/>
                </li>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:seachDelFlag">
                <li><label>删除标记：</label>
                    <form:select path="delFlag" class="input-medium2">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('del_flag')}" itemLabel="label" itemValue="value"
                                      htmlEscape="false"/>
                    </form:select>
                </li>
            </shiro:hasPermission>
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
            <th class="checkbox-width"><input type="checkbox" class="my-checkbox" name="all" id="all"/></th>
            <shiro:hasPermission name="erp:erpSalesOrder:tablePiNo">
                <th class="sort-column piNo">PI</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tableCustomer">
                <th class="sort-column ec.company">客户公司</th>
                <th class="sort-column ec.aname">客户联系人</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tableProductionPlain">
                <th>查看生产计划</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tableProductionOrder">
                <th>查看生产订单</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tablePayType">
                <th>查看录入款项</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tableShipment">
                <th>查看发货单</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tableSettlementWage">
                <th>查看销售提成</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tableUser">
                <th class="sort-column u3.name"> 业务员姓名</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tableTradingType">
                <th class="sort-column enmu_trading_type">贸易形式</th>
            </shiro:hasPermission>
            <%--<th >简要生产计划</th>--%>
            <shiro:hasPermission name="erp:erpSalesOrder:tableOrderTime">
                <th class="sort-column order_time">下单时间</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tableCommission">
                <th class="sort-column commission">销售提成</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tableCommissionMonth">
                <th class="sort-column commission_month">发放月份</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tableSumPayableMoney">
                <th class="sort-column sumPayableMoney">应付款合计</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tableSumComeMoney">
                <th class="sort-column sumComeMoney">实收款合计</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tableArrearage">
                <th class="sort-column arrearage">欠款</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tableStatus">
                <th class="sort-column status">订单状态</th>
            </shiro:hasPermission>
            <shiro:hasPermission name="erp:erpSalesOrder:tableUpdateDate">
                <th class="sort-column updateDate">更新时间</th>
            </shiro:hasPermission>
            <%--<th >备注信息</th>--%>
            <th width="100">操作</th>
        </tr>
        </thead>
        <tbody id="dndTable">
        <c:forEach items="${page.list}" var="erpSalesOrder">
            <tr>
                <td>
                    <input type="checkbox" class="my-checkbox" name="ids" value="${erpSalesOrder.id}"/>
                </td>
                <shiro:hasPermission name="erp:erpSalesOrder:tablePiNo">
                    <td>
                        <a onclick="showItemsDialog('${ctx}/erp/erpSalesOrder/view?id=${erpSalesOrder.id}','销售订单查看')">
                                ${erpSalesOrder.piNo}
                        </a>
                    </td>
                </shiro:hasPermission>
                <shiro:hasPermission name="erp:erpSalesOrder:tableCustomer">
                    <td>
                        <a onclick="showItemsDialog('${ctx}/erp/erpCustomer/view?id=${erpSalesOrder.erpCustomer.id}','查看客户信息')">
                            ${erpSalesOrder.erpCustomer.company}
                        </a>
                    </td>
                    <td>
                        ${erpSalesOrder.erpCustomer.aname}
                    </td>
                </shiro:hasPermission>

				<shiro:hasPermission name="erp:erpSalesOrder:tableProductionPlain">
					<td>
						<c:if test="${erpSalesOrder.status > 1}">
							<a onclick="showItemsDialog('${ctx}/erp/erpSalesOrder/showProductionPlain?id=${erpSalesOrder.id}','查看生产计划')">
								查看生产计划
							</a>
						</c:if>
					</td>
				</shiro:hasPermission>

				<shiro:hasPermission name="erp:erpSalesOrder:tableProductionOrder">
					<td>
						<c:if test="${erpSalesOrder.status >= 8}">
							<a onclick="showItemsDialog('${ctx}/erp/erpSalesOrder/showProductionOrder?id=${erpSalesOrder.id}','查看生产订单')">
								查看生产订单
							</a>
						</c:if>
					</td>
				</shiro:hasPermission>

				<shiro:hasPermission name="erp:erpSalesOrder:tablePayType">
					<td>
						<c:if test="${erpSalesOrder.status >= 5}">
							<a onclick="showItemsDialog('${ctx}/erp/erpSalesOrder/showPayType?id=${erpSalesOrder.id}','查看录入款项')">
								查看录入款项
							</a>
						</c:if>
					</td>
				</shiro:hasPermission>

                <shiro:hasPermission name="erp:erpSalesOrder:tableShipment">
                    <td>
						<c:if test="${erpSalesOrder.status >= 12}">
							<a onclick="showItemsDialog('${ctx}/erp/erpShipments/shipmentView?salesOrderId=${erpSalesOrder.id}','查看发货单')">
								查看发货单
							</a>
						</c:if>
                    </td>
                </shiro:hasPermission>

				<shiro:hasPermission name="erp:erpSalesOrder:tableSettlementWage">
					<td>
						<c:if test="${erpSalesOrder.status == 14 || erpSalesOrder.status == 16}">
							<a onclick="showItemsDialog('${ctx}/erp/erpSalesOrder/settlementWageView?id=${erpSalesOrder.id}','查看销售提成')">
								查看销售提成
							</a>
						</c:if>
					</td>
				</shiro:hasPermission>

                <shiro:hasPermission name="erp:erpSalesOrder:tableUser">
                    <td>
                            ${erpSalesOrder.user.name}
                    </td>
                </shiro:hasPermission>
                <shiro:hasPermission name="erp:erpSalesOrder:tableTradingType">
                    <td>
                            ${fns:getDictLabel(erpSalesOrder.enmuTradingType, 'enmu_trading_type', '')}
                    </td>
                </shiro:hasPermission>
                    <%--<td>
                        ${erpSalesOrder.productionPlain}
                    </td>--%>
                <shiro:hasPermission name="erp:erpSalesOrder:tableOrderTime">
                    <td>
                        <fmt:formatDate value="${erpSalesOrder.orderTime}" pattern="yyyy-MM-dd"/>
                    </td>
                </shiro:hasPermission>
                <shiro:hasPermission name="erp:erpSalesOrder:tableCommission">
                    <td>
                            ${erpSalesOrder.commission}
                    </td>
                </shiro:hasPermission>
                <shiro:hasPermission name="erp:erpSalesOrder:tableCommissionMonth">
                    <td>
                        <fmt:formatDate value="${erpSalesOrder.commissionMonth}" pattern="yyyy-MM-dd"/>
                    </td>
                </shiro:hasPermission>
                <shiro:hasPermission name="erp:erpSalesOrder:tableSumPayableMoney">
                    <td>
                            ${erpSalesOrder.sumPayableMoney}
                    </td>
                </shiro:hasPermission>
                <shiro:hasPermission name="erp:erpSalesOrder:tableSumComeMoney">
                    <td>
                            ${erpSalesOrder.sumComeMoney}
                    </td>
                </shiro:hasPermission>
                <shiro:hasPermission name="erp:erpSalesOrder:tableArrearage">
                    <td>
                            ${erpSalesOrder.arrearage}
                    </td>
                </shiro:hasPermission>
                <shiro:hasPermission name="erp:erpSalesOrder:tableStatus">
                    <td>
                            ${fns:getDictLabel(erpSalesOrder.status, 'status_sales_order', '')}
                    </td>
                </shiro:hasPermission>
                <shiro:hasPermission name="erp:erpSalesOrder:tableUpdateDate">
                    <td>
                        <fmt:formatDate value="${erpSalesOrder.updateDate}" pattern="yyyy-MM-dd"/>
                    </td>
                </shiro:hasPermission>
                    <%--<td>
                        ${erpSalesOrder.remarks}
                    </td>--%>
                <td>
                        <%--
                        erpSalesOrder.status
                        0	废弃订单
                        1	新建订单
                        2	新建生产计划
                        3	生产计划审批通过
                        4	生产计划审批未通过
                        5	首付款已付
                        6	首付款审批通过
                        7	首付款审批未通过
                        8	开始生产
                        9	尾款已付
                        10	尾款审批通过
                        11	尾款审批未通过
                        12	发货
                        13	工资结算
                        14	工资结算审批通过
                        15	工资结算审批未通过
                        16	订单完成
                        --%>
                    <c:if test="${fns:contains(erpSalesOrder.status,'1,4')}">
                        <shiro:hasPermission name="erp:erpSalesOrder:addProductionPlain">
                            <a href="${ctx}/erp/erpSalesOrder/addProductionPlain?id=${erpSalesOrder.id}">录入生产计划</a>
                            <br>
                        </shiro:hasPermission>
                    </c:if>

                    <%
                        String enname = UserUtils.getUser().getLoginName();
                        if ("gary_wang".equalsIgnoreCase(enname)) {  // 经理角色特殊处理
                    %>
                    <a href="${ctx}/erp/erpSalesOrder/addPayType?id=${erpSalesOrder.id}">录入款项</a>
                            <br>
                    <%
                        } else { //非经理的角色，正常权限和流程处理即可
                    %>
                        <c:if test="${fns:contains(erpSalesOrder.status,'3,7,8,11')}">
                            <shiro:hasPermission name="erp:erpSalesOrder:addPayType">
                                <a href="${ctx}/erp/erpSalesOrder/addPayType?id=${erpSalesOrder.id}">录入款项</a>
                                <br>
                            </shiro:hasPermission>
                        </c:if>
                    <%
                        }
                    %>

					<c:if test="${fns:contains(erpSalesOrder.status,'6')}">
						<shiro:hasPermission name="erp:erpSalesOrder:addProductionOrder">
							<a href="${ctx}/erp/erpSalesOrder/addProductionOrder?id=${erpSalesOrder.id}">录入生产订单</a>
                            <br>
						</shiro:hasPermission>
					</c:if>

					<c:if test="${fns:contains(erpSalesOrder.status,'10')}">
						<shiro:hasPermission name="erp:erpSalesOrder:shipmentForm">
							<a href="${ctx}/erp/erpShipments/shipmentForm?salesOrderId=${erpSalesOrder.id}">录入发货信息</a>
                            <br>
                        </shiro:hasPermission>
					</c:if>

					<c:if test="${fns:contains(erpSalesOrder.status,'12,15')}">
						<shiro:hasPermission name="erp:erpSalesOrder:settlementWageForm">
							<a href="${ctx}/erp/erpSalesOrder/settlementWageForm?id=${erpSalesOrder.id}">核算提成</a>
                            <br>
                        </shiro:hasPermission>
					</c:if>

					<c:if test="${erpSalesOrder.status == null}">
						<shiro:hasPermission name="erp:erpSalesOrder:edit">
							<a href="${ctx}/erp/erpSalesOrder/form?id=${erpSalesOrder.id}">录入销售订单</a>
                            <br>
                        </shiro:hasPermission>
					</c:if>

                    <shiro:hasPermission name="erp:erpSalesOrder:delete">
                        <a href="${ctx}/erp/erpSalesOrder/delete?id=${erpSalesOrder.id}"
                           onclick="return confirmx('确认要删除该销售订单以及订单下的支付款项信息、生产信息、发货信息吗？', this.href)"
                        >删除</a>
                        <br>
                    </shiro:hasPermission>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<div class="pagination">${page}</div>
</body>
</html>