<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>销售订单管理</title>
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

        function addParentRow(list, idx, tpl, row) {
            showItemsDialog()
        }

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

        function showItemsDialog(itemId) {
            showDialogByUrl(ctx + '/erp/erpPayType/childForm?id=' + (itemId || '') + '&orderId=' + $("#id").val(), '支付金额', window);
        }


    </script>
</head>
<body>
<ul class="nav nav-tabs my-nav-tabs">
    <li class="active"><a href="${ctx}/erp/erpSalesOrder/addPayType?id=${erpSalesOrder.id}">录入款项</a></li>
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
        <form:hidden id="flag" path="act.flag"/>
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
                <sys:ckfinder input="piFile" type="files" uploadPath="/PiFile" selectMultiple="true" readonly="true"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">简要生产计划：</label>
            <div class="controls">
                <form:hidden id="productionPlain" path="productionPlain" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                <sys:ckfinder input="productionPlain" type="files" uploadPath="/JianYaoProductionPlain" selectMultiple="true" readonly="true"/>
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
            <label class="control-label">是否全款：</label>
            <div class="controls">
                <form:select path="moneyPass" class="input-xlarge ">
                    <form:option value="0" label="非全款"/>
                    <form:option value="1" label="全款"/>
                </form:select>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">支付类型：</label>
            <div class="controls">
                <table id="contentTable" class="table table-striped table-bordered table-condensed">
                    <thead>
                    <tr>
                        <th class="hide"></th>
                        <th>付款方式</th>
                        <th>付款方式比例</th>
                        <th>应付总金额</th>
                        <th>实收总金额</th>
                        <%--<th>备注信息</th>--%>
                        <shiro:hasPermission name="erp:erpPayType:edit">
                            <th width="10">&nbsp;</th>
                        </shiro:hasPermission>
                    </tr>
                    </thead>
                    <tbody id="erpPayTypeList">
                    </tbody>
                    <shiro:hasPermission name="erp:erpPayType:edit">
                        <tfoot>
                        <tr>
                            <td colspan="6"><a href="javascript:"
                                               onclick="addParentRow('#erpPayTypeList', erpPayTypeRowIdx, erpPayTypeTpl);erpPayTypeRowIdx = erpPayTypeRowIdx + 1;"
                                               class="btn">新增</a></td>
                        </tr>
                        </tfoot>
                    </shiro:hasPermission>
                </table>
                <script type="text/template" id="erpPayTypeTpl">//<!--
						<tr id="erpPayTypeList{{idx}}">
							<td class="hide">
								<input id="erpPayTypeList{{idx}}_id" name="erpPayTypeList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="erpPayTypeList{{idx}}_delFlag" name="erpPayTypeList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td onclick="showItemsDialog('{{row.id}}')">
								<select id="erpPayTypeList{{idx}}_enmuPaymentType" name="erpPayTypeList[{{idx}}].enmuPaymentType" data-value="{{row.enmuPaymentType}}" class="input-small required">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('enmu_payment_type')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td onclick="showItemsDialog('{{row.id}}')">
								<input id="erpPayTypeList{{idx}}_scale" name="erpPayTypeList[{{idx}}].scale" type="number" value="{{row.scale}}" class="input-small "/>%
							</td>
							<td onclick="showItemsDialog('{{row.id}}')">
								<input id="erpPayTypeList{{idx}}_sumPrice" name="erpPayTypeList[{{idx}}].sumPrice" type="text" value="{{row.sumPrice}}" class="input-small  number"/>
							</td>
							<td onclick="showItemsDialog('{{row.id}}')">

								<input id="erpPayTypeList{{idx}}_totalPrice" name="erpPayTypeList[{{idx}}].totalPrice" type="text" value="{{row.totalPrice}}" class="input-small  number"/>
							</td>
							<%--<td onclick="showItemsDialog('{{row.id}}')">
								<textarea id="erpPayTypeList{{idx}}_remarks" name="erpPayTypeList[{{idx}}].remarks" rows="4" maxlength="255" class="input-small ">{{row.remarks}}</textarea>
							</td>--%>
							<shiro:hasPermission name="erp:erpPayType:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#erpPayTypeList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
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


                    });
                </script>
            </div>
        </div>
        <%@ include file="../../../include/approveInfo.jspf" %>
        <div class="form-actions my-form-actions">
            <shiro:hasPermission name="erp:erpSalesOrder:save">
                <input id="btnSubmit" class="btn btn-default" type="submit" value="保存草稿"/>
                &nbsp;
            </shiro:hasPermission>
            <c:if test="${erpSalesOrder.act.taskId != null && erpSalesOrder.act.taskId != ''}">
                <shiro:hasPermission name="erp:erpSalesOrder:oa:addPayType">
                    <input class="btn btn-success" type="submit" value="提交经理审批" onclick="$('#ipt_draft').val(0);"/>&nbsp;
                </shiro:hasPermission>
            </c:if>
            <input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </form:form>
</div>
</body>
</html>