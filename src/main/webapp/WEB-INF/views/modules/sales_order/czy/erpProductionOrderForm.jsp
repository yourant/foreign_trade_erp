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

        /**
         * mustache 列表上显示附件列表
         * @param content
         * @returns {*}
         */
        function madeUploadFilesData(content) {
            var contentList = null;
            if (content) {
                contentList = [];
                var ret = content.split('|');
                for (var i = 0; i < ret.length; i++) {
                    var ppFile = ret[i];
                    if (ppFile) {
                        contentList.push({
                            img: ppFile,
                            idx: i + 1
                        })
                    }
                }
            }
            return contentList;
        }

        function addRow(list, idx, tpl, row) {
            row.contentList = madeUploadFilesData(row.content);
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
            showDialogByUrl(ctx + '/erp/erpProductionOrder/childForm?id=' + (itemId || '') + '&orderId=' + $("#id").val(), '生产订单', window);
        }
    </script>
</head>
<body>
<ul class="nav nav-tabs my-nav-tabs">
    <li class="active"><a href="${ctx}/erp/erpSalesOrder/addProductionPlain?id=${erpSalesOrder.id}">生产订单</a></li>
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
                <sys:ckfinder input="piFile" type="files" uploadPath="/PiFile" selectMultiple="true"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">简要生产计划：</label>
            <div class="controls">
                <form:hidden id="productionPlain" path="productionPlain" htmlEscape="false" maxlength="255"
                             class="input-xlarge"/>
                <sys:ckfinder input="productionPlain" type="files" uploadPath="/JianYaoProductionPlain"
                              selectMultiple="true"/>
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
            <label class="control-label">生产订单：</label>
            <div class="controls">
                <table id="contentTable" class="table table-striped table-bordered table-condensed">
                    <thead>
                    <tr>
                        <th class="hide"></th>
                        <th>供应商</th>
                        <th>生产计划</th>
                        <th>下单日期</th>
                        <th>备注信息</th>
                        <shiro:hasPermission name="erp:erpProductionOrder:edit">
                            <th width="10">&nbsp;</th>
                        </shiro:hasPermission>
                    </tr>
                    </thead>
                    <tbody id="erpProductionOrderList">
                    </tbody>
                    <shiro:hasPermission name="erp:erpProductionOrder:edit">
                        <tfoot>
                        <tr>
                            <td colspan="7"><a href="javascript:"
                                               onclick="addParentRow('#erpProductionOrderList', erpProductionOrderRowIdx, erpProductionOrderTpl);erpProductionOrderRowIdx = erpProductionOrderRowIdx + 1;"
                                               class="btn">新增</a></td>
                        </tr>
                        </tfoot>
                    </shiro:hasPermission>
                </table>
                <script type="text/template" id="erpProductionOrderTpl">//<!--
						<tr id="erpProductionOrderList{{idx}}">
							<td class="hide">
								<input id="erpProductionOrderList{{idx}}_id" name="erpProductionOrderList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="erpProductionOrderList{{idx}}_delFlag" name="erpProductionOrderList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td onclick="showItemsDialog('{{row.id}}')">
								<select id="erpProductionOrderList{{idx}}_enmuProvider" name="erpProductionOrderList[{{idx}}].enmuProvider" data-value="{{row.enmuProvider}}" class="input-small ">
									<option value=""></option>
									<c:forEach items="${fns:getDictList('enmu_provider')}" var="dict">
										<option value="${dict.value}">${dict.label}</option>
									</c:forEach>
								</select>
							</td>
							<td>
                                {{#row.contentList}}
                                    <a href="{{img}}" target="_blank">生产计划附件{{idx}}</a>
                                {{/row.contentList}}
							</td>
							<td onclick="showItemsDialog('{{row.id}}')">
								<input id="erpProductionOrderList{{idx}}_orderTime" name="erpProductionOrderList[{{idx}}].orderTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
									value="{{row.orderTime}}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
							</td>
							<td onclick="showItemsDialog('{{row.id}}')">
								<textarea id="erpProductionOrderList{{idx}}_remarks" name="erpProductionOrderList[{{idx}}].remarks" rows="4" maxlength="255" class="input-small ">{{row.remarks}}</textarea>
							</td>
							<shiro:hasPermission name="erp:erpProductionOrder:edit">
							<td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#erpProductionOrderList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td>
                            </shiro:hasPermission>
						</tr>//-->
                </script>
                <script type="text/javascript">
                    var erpProductionOrderRowIdx = 0,
                        erpProductionOrderTpl = $("#erpProductionOrderTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                    $(document).ready(function () {
                        var data = ${fns:toJson(erpSalesOrder.erpProductionOrderList)};
                        for (var i = 0; i < data.length; i++) {
                            addRow('#erpProductionOrderList', erpProductionOrderRowIdx, erpProductionOrderTpl, data[i]);
                            erpProductionOrderRowIdx = erpProductionOrderRowIdx + 1;
                        }
                    });
                </script>
            </div>
        </div>
        <div class="form-actions my-form-actions">
            <shiro:hasPermission name="erp:erpSalesOrder:save">
                <input id="btnSubmit" class="btn btn-default" type="submit" value="保存草稿"/>
                &nbsp;
            </shiro:hasPermission>
            <c:if test="${erpSalesOrder.act.taskId != null && erpSalesOrder.act.taskId != ''}">
                <shiro:hasPermission name="erp:erpSalesOrder:oa:addProductionOrder">
                    <input class="btn btn-success" type="submit" value="下生产订单" onclick="$('#ipt_draft').val(0);"/>&nbsp;
                </shiro:hasPermission>
            </c:if>
            <input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </form:form>
</div>
</body>
</html>