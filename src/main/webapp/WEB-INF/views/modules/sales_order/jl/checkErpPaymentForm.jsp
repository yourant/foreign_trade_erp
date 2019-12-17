<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>查看录入款项</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {
            //$("#name").focus();
            $("#inputForm").validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });
        });

        function addRow(list, idx, tpl, row) {
            $(list).append(Mustache.render(tpl, {
                idx: idx, delBtn: true, row: row
            }));
            $(list + idx).find("select").each(function () {
                $(this).val($(this).attr("data-value"));
            });
            $(list + idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                var ss = $(this).attr("data-value").split(',');
                for (var i = 0; i < ss.length; i++) {
                    if ($(this).val() == ss[i]) {
                        $(this).attr("checked", "checked");
                    }
                }
            });
        }

        function addParentRow(list, idx, tpl, row) {
            $(list).append(Mustache.render(tpl, {
                idx: idx, delBtn: true, row: row
            }));
            $(list + idx).find("select").each(function () {
                $(this).val($(this).attr("data-value"));
            });
            $(list + idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                var ss = $(this).attr("data-value").split(',');
                for (var i = 0; i < ss.length; i++) {
                    if ($(this).val() == ss[i]) {
                        $(this).attr("checked", "checked");
                    }
                }
            });
            $("#inputForm").submit();
        }

        function delRow(obj, prefix) {
            var id = $(prefix + "_id");
            var delFlag = $(prefix + "_delFlag");
            if (id.val() == "") {
                $(obj).parent().parent().remove();
            } else if (delFlag.val() == "0") {
                delFlag.val("1");
                $(obj).html("&divide;").attr("title", "撤销删除");
                $(obj).parent().parent().addClass("error");
            } else if (delFlag.val() == "1") {
                delFlag.val("0");
                $(obj).html("&times;").attr("title", "删除");
                $(obj).parent().parent().removeClass("error");
            }
        }
    </script>
</head>
<body>
<ul class="nav nav-tabs my-nav-tabs">
    <li class="active"><a>查看录入款项</a></li>
</ul>
<br/>
<div class="my-container">
    <form:form id="inputForm" modelAttribute="erpSalesOrder" action="${ctx}/erp/erpSalesOrder/save" method="post"
               class="form-horizontal">
        <form:hidden path="id"/>
        <form:hidden path="act.taskId"/>
        <form:hidden path="act.taskName"/>
        <form:hidden path="act.taskDefKey"/>
        <form:hidden path="act.procInsId"/>
        <form:hidden path="act.procDefId"/>
        <form:hidden path="draft" value="1" id="ipt_draft"/>
        <sys:message content="${message}"/>
        <div class="control-group">
            <label class="control-label">人员名称：</label>
            <div class="controls">
                    ${erpSalesOrder.user.name}
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">贸易形式：</label>
            <div class="controls">
                <form:select path="enmuTradingType" class="input-xlarge " readonly="true" disabled="true">
                    <form:option value="" label=""/>
                    <form:options items="${fns:getDictList('enmu_trading_type')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">PI：</label>
            <div class="controls">
                    ${erpSalesOrder.piNo}
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">PI 附件：</label>
            <div class="controls">
                <form:hidden id="piFile" path="piFile" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                <sys:ckfinder input="piFile" type="files" uploadPath="/PiFile" selectMultiple="true"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">简要生产计划：</label>
            <div class="controls">
                <form:hidden id="productionPlain" path="productionPlain" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                <sys:ckfinder input="productionPlain" type="files" uploadPath="/JianYaoProductionPlain" selectMultiple="true"/>
                    <%--<form:textarea path="productionPlain" htmlEscape="false" rows="4" maxlength="255"--%>
                    <%--class="input-xxlarge required hide"/>--%>
                    <%--<sys:ckeditor replace="productionPlain" uploadPath="/test" height="200"/>--%>
                <span class="help-inline"><font color="red">*</font> </span>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">下单日期：</label>
            <div class="controls">
                <fmt:formatDate value="${erpSalesOrder.orderTime}" pattern="yyyy-MM-dd"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">备注信息：</label>
            <div class="controls">
                <form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255"
                               class="input-xxlarge " />
                <sys:ckeditor replace="remarks" uploadPath="/test" height="200"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">支付类型：</label>
            <div class="controls">
                <table class="table table-striped table-bordered table-condensed">
                    <thead>
                    <tr>
                        <th class="hide"></th>
                        <th>付款方式</th>
                        <th>付款方式比例</th>
                        <th>应付总金额</th>
                        <th>实收总金额</th>
                        <%--<th>备注信息</th>--%>
                    </tr>
                    </thead>
                    <tbody id="erpPayTypeList">
                    </tbody>
                </table>
                <script type="text/template" id="erpPayTypeTpl">//<!--
						<tr id="erpPayTypeList{{idx}}">
							<td class="hide">
								<input id="erpPayTypeList{{idx}}_id" name="erpPayTypeList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="erpPayTypeList{{idx}}_delFlag" name="erpPayTypeList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td>
								<select data-value="{{row.enmuPaymentType}}" class="input-small" readonly="true" disabled="true">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('enmu_payment_type')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								{{row.scale}}%
							</td>
							<td>
								{{row.sumPrice}}
							</td>
							<td>
								{{row.totalPrice}}
							</td>
							<%--<td>
								{{row.remarks}}
							</td>--%>
						</tr>//-->
                </script>
                <script type="text/javascript">
                    var erpPayTypeRowIdx = 0,
                        erpPayTypeTpl = $("#erpPayTypeTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                    $(document).ready(function () {
                        var data = ${fns:toJson(erpSalesOrder.erpPayTypeList)};
                        for (var i = 0; i < data.length; i++) {
                            addRow('#erpPayTypeList', erpPayTypeRowIdx, erpPayTypeTpl, data[i]);
                            erpPayTypeRowIdx = erpPayTypeRowIdx + 1;
                        }

                        // .tab-content
                        var tabs = $('#erpPayTypeList').children();
                        tabs.click(function () {
                            $('.tab-content').removeClass('info').eq(tabs.removeClass('info').index($(this).addClass('info'))).addClass('info');
                        });
                    });

                </script>
            </div>
        </div>
        <script type="text/template" id="erpPayMoneyTpl">//<!--
		<tr id="erpPayMoneyList{{idx}}">
			<td class="hide">
				<input id="erpPayMoneyList{{idx}}_id" name="erpPayTypeList[{{row.statusIdx}}].erpPayMoneyList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
				<input id="erpPayMoneyList{{idx}}_delFlag" name="erpPayTypeList[{{row.statusIdx}}].erpPayMoneyList[{{idx}}].delFlag" type="hidden" value="0"/>
			</td>
			<td>
				{{row.payableMoney}}
			</td>
			<td>
				{{row.comeMoney}}
			</td>
			<td>
			    <input id="erpPayMoneyList{{idx}}_time" name="erpPayTypeList[{{row.statusIdx}}].erpPayMoneyList[{{idx}}].time" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
					value="{{row.time}}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" readonly="true"/>
			</td>
			<td>
			    {{row.scale}}%
			</td>
			<td>
                <input id="erpPayMoneyList{{idx}}_file" name="erpPayMoneyList[{{idx}}].file" type="hidden" value="{{row.file}}" maxlength="255"/>
                <sys:ckfinder input="erpPayMoneyList{{idx}}_file" type="files"  uploadPath="/payMoneyFile" selectMultiple="true" readonly="true"/>
            </td>
			<%--<td>
				{{row.remarks}}
			</td>--%>
		</tr>//-->
        </script>
        <c:forEach items="${erpSalesOrder.erpPayTypeList}" var="erpPayType" varStatus="status">
            <div class="control-group tab-content">
                <label class="control-label">${fns:getDictLabel(erpPayType.enmuPaymentType, 'enmu_payment_type', '')}支付金额：</label>
                <div class="controls">
                    <table class="table table-striped table-bordered table-condensed">
                        <thead>
                        <tr>
                            <th class="hide"></th>
                            <th>应收款</th>
                            <th>实收款</th>
                            <th>付款时间</th>
                            <th>付款比例</th>
                            <th>支付截图</th>
                            <%--<th>备注信息</th>--%>
                        </tr>
                        </thead>
                        <tbody id="erpPayMoney${status.index}">
                        </tbody>
                    </table>

                    <script type="text/javascript">
                        var erpPayType${status.index}erpPayMoneyRowIdx = 0,
                            erpPayMoneyTpl = $("#erpPayMoneyTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                        $(document).ready(function () {
                            var data = ${fns:toJson(erpPayType.erpPayMoneyList)};
                            for (var i = 0; i < data.length; i++) {
                                data[i].statusIdx = ${status.index};
                                addRow('#erpPayMoney${status.index}', erpPayType${status.index}erpPayMoneyRowIdx, erpPayMoneyTpl, data[i]);
                                erpPayType${status.index}erpPayMoneyRowIdx = erpPayType${status.index}erpPayMoneyRowIdx + 1;
                            }
                        });
                    </script>
                </div>
            </div>
        </c:forEach>
        <%@ include file="../../../include/approve.jspf" %>
        <div class="form-actions my-form-actions">
            <c:if test="${erpSalesOrder.act.taskId != null && erpSalesOrder.act.taskId != ''}">
                <shiro:hasPermission name="erp:erpSalesOrder:oa:checkPayType">
                    <input class="btn btn-success" type="submit" value="审批打款信息" onclick="$('#ipt_draft').val(0);"/>&nbsp;
                </shiro:hasPermission>
            </c:if>
            <input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </form:form>
</div>
</body>
</html>