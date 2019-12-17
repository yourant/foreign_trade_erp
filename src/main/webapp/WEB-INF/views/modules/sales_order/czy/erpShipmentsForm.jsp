<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>发货单管理</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {
            //$("#name").focus();
            $("#inputForm").validate({
                submitHandler: function (form) {
                    mappingDocterVin();
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
            $("#enumBillType").on("change", function (data) {
                if (data.val == 1) {//正本显示，电放不显示快递
                    $("#express").show();
                    $("#expressNum").addClass("required");
                } else {
                    $("#express").hide();
                    $("#expressNum").removeClass("required");
                }
            })
        });

        function addRow(list, idx, tpl, row) {
            $(list).append(Mustache.render(tpl, {
                idx: idx, delBtn: true, row: row
            }));
            $(list + idx).find("select").each(function () {
                $(this).val($(this).attr("data-value"));
            });
            $(list + idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                try {
                    var ss = $(this).attr("data-value").split(',');
                    for (var i = 0; i < ss.length; i++) {
                        if ($(this).val() == ss[i]) {
                            $(this).attr("checked", "checked");
                        }
                    }
                } catch (e) {
                }
            });
        }

        function delRow(obj, prefix) {
            var dockerKey = $(prefix + "_id").parent().next().find('input:radio').data('dockerKey');
            var length = $('.my-vin-checkbox').filter(':checked').filter(function () {
                return dockerKey !== $(this).data('dockerKey')
            }).length;
            if (length > 0) {
                alertx('请清空该集装箱里面的，才能删除');
                return;
            }
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
    <li class="active"><a>发货单<shiro:hasPermission
            name="erp:erpShipments:edit">${not empty erpShipments.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission
            name="erp:erpShipments:edit">查看</shiro:lacksPermission></a></li>
</ul>
<br/>
<div class="my-container">
    <form:form id="inputForm" modelAttribute="erpShipments" action="${ctx}/erp/erpShipments/save" method="post"
               class="form-horizontal">
        <form:hidden path="id"/>
        <form:hidden path="act.taskId"/>
        <form:hidden path="act.taskName"/>
        <form:hidden path="act.taskDefKey"/>
        <form:hidden path="act.procInsId"/>
        <form:hidden path="act.procDefId"/>
        <form:hidden path="act.businessId"/>
        <form:hidden path="draft" value="1" id="ipt_draft"/>
        <form:hidden id="flag" path="act.flag"/>
        <input type="hidden" name="salesOrderId" value="${salesOrderId}">
        <sys:message content="${message}"/>
        <fieldset>
            <legend>
                发货信息
            </legend>
            <table class="table-form">
                <tr>
                    <td class="tit">提单号:</td>
                    <td>
                        <form:input path="blno" htmlEscape="false" maxlength="25" class="input-xlarge "/>
                    </td>
                    <td class="tit">提单类型:</td>
                    <td>
                        <form:select path="enumBillType" id="enumBillType" class="input-xlarge ">
                            <form:option value="" label=""/>
                            <form:options items="${fns:getDictList('enum_bill_type')}" itemLabel="label"
                                          itemValue="value" htmlEscape="false"/>
                        </form:select>
                    </td>
                </tr>
                <tr>
                    <td class="tit">货物类型:</td>
                    <td>
                        <form:select path="enumShipmentsType" class="input-xlarge ">
                            <form:option value="" label=""/>
                            <form:options items="${fns:getDictList('enum_shipments_type')}" itemLabel="label"
                                          itemValue="value" htmlEscape="false"/>
                        </form:select>
                    </td>
                    <td class="tit">发货时间:</td>
                    <td>
                        <input name="deliveryTime" type="text" readonly="readonly" maxlength="20"
                               class="input-medium Wdate "
                               value="<fmt:formatDate value="${erpShipments.deliveryTime}" pattern="yyyy-MM-dd"/>"
                               onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                    </td>
                </tr>
                <tr>
                    <td class="tit">入货通知附件:</td>
                    <td colspan="3">
                        <form:hidden id="noticeFile" path="noticeFile" htmlEscape="false" maxlength="11"
                                     class="input-xlarge"/>
                        <sys:ckfinder input="noticeFile" type="files" uploadPath="/erp/erpShipments"
                                      selectMultiple="true"/>
                    </td>
                </tr>
                <tr>
                    <td class="tit">备注信息:</td>
                    <td colspan="3">
                        <form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255"
                                       class="input-xxlarge "/>
                        <sys:ckeditor replace="remarks" uploadPath="/test" height="200"/>
                    </td>
                </tr>
            </table>
        </fieldset>
        <fieldset>
            <legend>
                装箱信息
            </legend>
            <fieldset>
                <legend>
                    集装箱
                </legend>
                <div class="control-group">
                    <div>
                        <table id="contentTable" class="table table-striped table-bordered table-condensed">
                            <thead>
                            <tr>
                                <th class="hide"></th>
                                <th width="15"></th>
                                <th>集装箱号</th>
                                <th>铅封号</th>
                                <%--<th>其余</th>--%>
                                <th>备注信息</th>
                                <shiro:hasPermission name="erp:erpShipments:edit">
                                    <th width="10">&nbsp;</th>
                                </shiro:hasPermission>
                            </tr>
                            </thead>
                            <tbody id="erpDockerList">
                            </tbody>
                            <shiro:hasPermission name="erp:erpShipments:edit">
                                <tfoot>
                                <tr>
                                    <td colspan="6"><a href="javascript:"
                                                       onclick="addRow('#erpDockerList', erpDockerRowIdx, erpDockerTpl);erpDockerRowIdx = erpDockerRowIdx + 1;"
                                                       class="btn">新增</a></td>
                                </tr>
                                </tfoot>
                            </shiro:hasPermission>
                        </table>
                        <script type="text/template" id="erpDockerTpl">//<!--
						<tr id="erpDockerList{{idx}}">
							<td class="hide">
								<input id="erpDockerList{{idx}}_id" name="erpDockerList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="erpDockerList{{idx}}_delFlag" name="erpDockerList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td width="15">
								<input type="radio" name="myRadio" data-docker-key="{{row.dockerNo}}-{{row.sealNo}}" class="my-checkbox my-docker-radio"  value="" />
							</td>
							<td>
								<input id="erpDockerList{{idx}}_dockerNo" name="erpDockerList[{{idx}}].dockerNo" type="text" value="{{row.dockerNo}}" maxlength="25" class="input-small my-dockerNo"/>
							</td>
							<td>
								<input id="erpDockerList{{idx}}_sealNo" name="erpDockerList[{{idx}}].sealNo" type="text" value="{{row.sealNo}}" maxlength="25" class="input-small my-sealNo"/>
							</td>
							<%--<td>
								<input id="erpDockerList{{idx}}_parts" name="erpDockerList[{{idx}}].parts" type="text" value="{{row.parts}}" class="input-small "/>
							</td>--%>
							<td>
								<textarea id="erpDockerList{{idx}}_remarks" name="erpDockerList[{{idx}}].remarks" rows="4" maxlength="255" class="input-small ">{{row.remarks}}</textarea>
							</td>
							<shiro:hasPermission name="erp:erpShipments:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#erpDockerList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
                        </script>
                        <script type="text/javascript">
                            var erpDockerRowIdx = 0,
                                erpDockerTpl = $("#erpDockerTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                            $(document).ready(function () {
                                var data = ${fns:toJson(erpShipments.erpDockerList)};
                                for (var i = 0; i < data.length; i++) {
                                    addRow('#erpDockerList', erpDockerRowIdx, erpDockerTpl, data[i]);
                                    erpDockerRowIdx = erpDockerRowIdx + 1;
                                }
                            });
                        </script>
                    </div>
                </div>
            </fieldset>

            <script type="text/template" id="erpVinTpl">//<!--
				<tr id="erpVinList{{idx}}">

					<td class="hide">
						<input id="erpVinList{{idx}}_id" name="erpVinList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
						<input id="erpVinList{{idx}}_delFlag" name="erpVinList[{{idx}}].delFlag" type="hidden" value="0"/>
						<input id="erpVinList{{idx}}_erpProductionItems" name="erpVinList[{{idx}}].erpProductionItems.id" type="hidden" value="{{row.erpProductionItemsId}}"/>
					</td>
					<td width="15">
					{{#row.erpDocker.id}}
						<input type="checkbox" data-docker-key="{{row.erpDocker.dockerNo}}-{{row.erpDocker.sealNo}}" checked="checked" class="my-checkbox hide my-vin-checkbox" value=""/>
					{{/row.erpDocker.id}}
					{{^row.erpDocker.id}}
						<input type="checkbox" data-docker-key="{{row.erpDocker.dockerNo}}-{{row.erpDocker.sealNo}}" class="my-checkbox hide my-vin-checkbox" value=""/>
					{{/row.erpDocker.id}}

					</td>
					<td>
						<input id="erpVinList{{idx}}_vinNo" name="erpVinList[{{idx}}].vinNo" type="text" value="{{row.vinNo}}" maxlength="25" class="input-small"/>
					</td>
					<td>
						<input id="erpVinList{{idx}}_engineNo" name="erpVinList[{{idx}}].engineNo" type="text" value="{{row.engineNo}}" maxlength="25" class="input-small"/>
					</td>
					<td>
						<input id="erpVinList{{idx}}_productor" name="erpVinList[{{idx}}].productor" type="text" value="{{row.productor}}" maxlength="25" class="input-small"/>
					</td>
					<td class="hide">
						<input id="erpVinList{{idx}}_dockerNo" name="erpVinList[{{idx}}].dockerKey" type="text" value="" class="input-small"/>
					</td>
					<td>
						<textarea id="erpVinList{{idx}}_remarks" name="erpVinList[{{idx}}].remarks" rows="4" maxlength="255" class="input-small ">{{row.remarks}}</textarea>
					</td>
				</tr>//-->
            </script>
            <c:forEach items="${boxList}" var="erpProductionItems" varStatus="status">
                <fieldset>
                    <legend>
                            ${fns:getDictLabel(erpProductionItems.erpProductionOrder.enmuProvider, 'enmu_provider', '')},${erpProductionItems.erpCarType.aname},${erpProductionItems.erpEngineType.aname},数量:(${erpProductionItems.count})
                    </legend>
                    <div class="control-group">
                        <div>
                            <table class="table table-striped table-bordered table-condensed">
                                <thead>
                                <tr>
                                    <th class="hide"></th>
                                    <th width="15">装箱</th>
                                    <th>车架号</th>
                                    <th>引擎编号</th>
                                    <th>生产人</th>
                                    <th class="hide">集装箱号</th>
                                    <th>备注信息</th>
                                </tr>
                                </thead>
                                <tbody id="boxList${status.index}">
                                </tbody>
                            </table>
                            <script type="text/javascript">
                                var erpVinRowIdx = 0,
                                    erpVinTpl = $("#erpVinTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                                $(document).ready(function () {
                                    var data = ${fns:toJson(erpProductionItems.erpVinList)};
                                    for (var i = 0; i < data.length; i++) {
                                        data[i].erpProductionItemsId = '${erpProductionItems.id}';
                                        addRow('#boxList${status.index}', erpVinRowIdx, erpVinTpl, data[i]);
                                        erpVinRowIdx = erpVinRowIdx + 1;
                                    }
                                    for (var i = 0; i < ${erpProductionItems.count}-data.length; i++) {
                                        addRow('#boxList${status.index}', erpVinRowIdx, erpVinTpl, {erpProductionItemsId: '${erpProductionItems.id}'});
                                        erpVinRowIdx = erpVinRowIdx + 1;
                                    }
                                });
                            </script>
                        </div>
                    </div>
                </fieldset>
            </c:forEach>
        </fieldset>

        <fieldset>
            <legend>
                海关信息
            </legend>
            <table class="table-form">
                <tr>
                    <td class="tit">报关单号:</td>
                    <td>
                        <form:input path="billManifestNo" htmlEscape="false" maxlength="255" class="input-xlarge "/>
                    </td>
                    <td class="tit">离港时间:</td>
                    <td>
                        <input name="sendTime" type="text" readonly="readonly" maxlength="20"
                               class="input-medium Wdate "
                               value="<fmt:formatDate value="${erpShipments.sendTime}" pattern="yyyy-MM-dd"/>"
                               onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                    </td>
                    <td class="tit">预计到达时间:</td>
                    <td>
                        <input name="preComeTime" type="text" readonly="readonly" maxlength="20"
                               class="input-medium Wdate "
                               value="<fmt:formatDate value="${erpShipments.preComeTime}" pattern="yyyy-MM-dd"/>"
                               onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                    </td>
                </tr>
                <tr>
                    <td class="tit">报关单附件:</td>
                    <td>
                        <form:hidden id="billManifestFile" path="billManifestFile" htmlEscape="false" maxlength="11"
                                     class="input-xlarge"/>
                        <sys:ckfinder input="billManifestFile" type="files" uploadPath="/erp/erpShipments"
                                      selectMultiple="true"/>
                    </td>
                    <td class="tit">提单附件:</td>
                    <td>
                        <form:hidden id="billLadingFile" path="billLadingFile" htmlEscape="false" maxlength="11"
                                     class="input-xlarge"/>
                        <sys:ckfinder input="billLadingFile" type="files" uploadPath="/erp/erpShipments"
                                      selectMultiple="true"/>
                    </td>
                    <td class="tit">海运账单附件:</td>
                    <td>
                        <form:hidden id="priceManifestFile" path="priceManifestFile" htmlEscape="false" maxlength="255"
                                     class="input-xlarge"/>
                        <sys:ckfinder input="priceManifestFile" type="files" uploadPath="/erp/erpShipments"
                                      selectMultiple="true"/>
                    </td>
                </tr>
            </table>
        </fieldset>
        <fieldset id="express">
            <legend>
                快递信息
            </legend>
            <table class="table-form">
                <tr>
                    <td class="tit">快递公司:</td>
                    <td>
                        <form:select path="enumExpressCompany" class="input-xlarge ">
                            <form:option value="" label=""/>
                            <form:options items="${fns:getDictList('enum_express_company')}" itemLabel="label"
                                          itemValue="value" htmlEscape="false"/>
                        </form:select>
                    </td>
                    <td class="tit">文件寄送单号:</td>
                    <td>
                        <form:input path="expressNum" htmlEscape="false" maxlength="25" class="input-xlarge"/>
                        <span class="help-inline"><font color="red">*</font> </span>
                    </td>
                </tr>
                <tr>
                    <td class="tit">快递时间:</td>
                    <td>
                        <input name="expressDate" type="text" readonly="readonly" maxlength="20"
                               class="input-medium Wdate "
                               value="<fmt:formatDate value="${erpShipments.expressDate}" pattern="yyyy-MM-dd"/>"
                               onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                    </td>
                    <td class="tit">快递单据附件:</td>
                    <td>
                        <form:hidden id="expressFile" path="expressFile" htmlEscape="false" maxlength="255"
                                     class="input-xlarge"/>
                        <sys:ckfinder input="expressFile" type="files" uploadPath="/erp/erpShipments"
                                      selectMultiple="true"/>
                    </td>
                </tr>
            </table>
        </fieldset>
        <div class="form-actions my-form-actions">
            <shiro:hasPermission name="erp:erpShipments:save">
                <input id="btnSubmit" class="btn btn-default" type="submit" value="保存草稿"/>
                &nbsp;
            </shiro:hasPermission>
            <c:if test="${erpShipments.act.taskId != null && erpShipments.act.taskId != ''}">
                <shiro:hasPermission name="erp:erpShipments:oa:create">
                    <input class="btn btn-success" type="submit" value="发货" onclick="$('#ipt_draft').val(0);"/>&nbsp;
                </shiro:hasPermission>
            </c:if>
            <input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </form:form>
</div>
<script>
    function mappingDocterVin() {
        $('.my-docker-radio').each(function (i, n) {
            var newDockerKey = $(this).parents('td').siblings().children('input').slice(2, 4).map(function () {
                return $(this).val()
            }).get().join('-');
            var dockerKey = $(this).data('dockerKey')
            $('.my-vin-checkbox').filter(function () {
                return dockerKey === $(this).data('dockerKey')
            }).each(function (i, n) {
                $(this).parents('td').siblings().children('input').eq(6).val(newDockerKey);
            });
        })
    }

    $(function () {
        $('.my-vin-checkbox').live('click', function () {
            var isChecked = $(this).prop('checked');

            var dockerKey = $('.my-docker-radio').filter(':checked').data('dockerKey');

            if (isChecked) {
                $(this).data('dockerKey', dockerKey);
                $(this).parents('td').siblings().children('input').eq(6).val(dockerKey);
            } else {
                $(this).removeData('dockerKey');
                $(this).parents('td').siblings().children('input').eq(6).val('');
            }
        });

        $('.my-docker-radio').live('click', function (evt) {
            var dockerKey = $('.my-docker-radio').filter(':checked').parents('td').siblings().children('input').slice(2, 4).map(function () {
                return $(this).val()
            }).get().join('-');

//                 var newDockerKey = $(this).parents('td').siblings().children('input').slice(2, 4).map(function(){return $(this).val()}).get().join('-');
            if (dockerKey === '-') {
                alertx('请填写集装箱号');
                evt.stopPropagation();
                evt.preventDefault();
                return;
            }

            $('.my-vin-checkbox').removeClass('hide');
//                var dockerKey =$('.my-docker-radio').filter(':checked').parents('td').siblings().children('input').slice(2, 4).map(function(){return $(this).val()}).get().join('-');


            var oldDockerKey = $(this).data('dockerKey');
            if (oldDockerKey === '-') {
                oldDockerKey = dockerKey;
                $(this).data('dockerKey', dockerKey);
            }
            var isChecked = $(this).prop('checked');
            if (isChecked) {
                $('.my-vin-checkbox').filter(':checked').filter(function () {
                    return oldDockerKey !== $(this).data('dockerKey')
                }).addClass('hide');
            }
        });
    })
</script>
</body>
</html>