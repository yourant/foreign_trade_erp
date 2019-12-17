<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>销售订单管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
		function addRow(list, idx, tpl, row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row
			}));
			$(list+idx).find("select").each(function(){
				$(this).val($(this).attr("data-value"));
			});
			$(list+idx).find("input[type='checkbox'], input[type='radio']").each(function(){
				var ss = $(this).attr("data-value").split(',');
				for (var i=0; i<ss.length; i++){
					if($(this).val() == ss[i]){
						$(this).attr("checked","checked");
					}
				}
			});
		}
		function delRow(obj, prefix){
			var id = $(prefix+"_id");
			var delFlag = $(prefix+"_delFlag");
			if (id.val() == ""){
				$(obj).parent().parent().remove();
			}else if(delFlag.val() == "0"){
				delFlag.val("1");
				$(obj).html("&divide;").attr("title", "撤销删除");
				$(obj).parent().parent().addClass("error");
			}else if(delFlag.val() == "1"){
				delFlag.val("0");
				$(obj).html("&times;").attr("title", "删除");
				$(obj).parent().parent().removeClass("error");
			}
		}
	</script>
</head>
<body>
	<ul class="nav nav-tabs my-nav-tabs">
		<li><a href="${ctx}/erp/erpSalesOrder/">销售订单列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpSalesOrder/form?id=${erpSalesOrder.id}">销售订单<shiro:hasPermission name="erp:erpSalesOrder:edit">${not empty erpSalesOrder.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpSalesOrder:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="erpSalesOrder" action="${ctx}/erp/erpSalesOrder/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">客户：</label>
                <div class="controls">
                    ${erpSalesOrder.erpCustomer.id}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">人员名称：</label>
                <div class="controls">
                    ${erpSalesOrder.user}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">贸易形式：</label>
                <div class="controls">
                    <form:select path="enmuTradingType" class="input-xlarge "  readonly="true" disabled="true">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('enmu_trading_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
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
                <label class="control-label">简要生产计划：</label>
                <div class="controls">
                    <pre>
                    ${erpSalesOrder.productionPlain}
                    </pre>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">下单日期：</label>
                <div class="controls">
                    <fmt:formatDate value="${erpSalesOrder.orderTime}" pattern="yyyy-MM-dd" />
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">销售提成：</label>
                <div class="controls">
                    ${erpSalesOrder.commission}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">发放月份：</label>
                <div class="controls">
                    <fmt:formatDate value="${erpSalesOrder.commissionMonth}" pattern="yyyy-MM-dd" />
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">订单状态：</label>
                <div class="controls">
                    <form:select path="status" class="input-xlarge "  readonly="true" disabled="true">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('status_sales_order')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注信息：</label>
                <div class="controls">
                    <pre>
                    ${erpSalesOrder.remarks}
                    </pre>
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
                                    <th>订单金额</th>
                                    <th>备注信息</th>
                                    <shiro:hasPermission name="erp:erpSalesOrder:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
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
                                    <select id="erpPayTypeList{{idx}}_enmuPaymentType" name="erpPayTypeList[{{idx}}].enmuPaymentType" data-value="{{row.enmuPaymentType}}" class="input-small required" readonly="true" disabled="true">
                                        <option value=""></option>
                                        <c:forEach items="${fns:getDictList('enmu_payment_type')}" var="dict">
                                            <option value="${dict.value}">${dict.label}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                {{row.scale}}
                                </td>
                                <td>
                                {{row.sumPrice}}
                                </td>
                                <td>
                                {{row.remarks}}
                                </td>
                            </tr>//-->
                        </script>
                        <script type="text/javascript">
                            var erpPayTypeRowIdx = 0, erpPayTypeTpl = $("#erpPayTypeTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
                            $(document).ready(function() {
                                var data = ${fns:toJson(erpSalesOrder.erpPayTypeList)};
                                for (var i=0; i<data.length; i++){
                                    addRow('#erpPayTypeList', erpPayTypeRowIdx, erpPayTypeTpl, data[i]);
                                    erpPayTypeRowIdx = erpPayTypeRowIdx + 1;
                                }
                            });
                        </script>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">生产订单：</label>
                    <div class="controls">
                        <table id="contentTable" class="table table-striped table-bordered table-condensed">
                            <thead>
                                <tr>
                                    <th class="hide"></th>
                                    <th>销售订单</th>
                                    <th>供应商</th>
                                    <th>简要生产计划</th>
                                    <th>下单日期</th>
                                    <th>备注信息</th>
                                    <shiro:hasPermission name="erp:erpSalesOrder:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
                                </tr>
                            </thead>
                            <tbody id="erpProductionOrderList">
                            </tbody>
                        </table>
                        <script type="text/template" id="erpProductionOrderTpl">//<!--
                            <tr id="erpProductionOrderList{{idx}}">
                                <td class="hide">
                                    <input id="erpProductionOrderList{{idx}}_id" name="erpProductionOrderList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
                                    <input id="erpProductionOrderList{{idx}}_delFlag" name="erpProductionOrderList[{{idx}}].delFlag" type="hidden" value="0"/>
                                </td>
                                <td>
                                {{row.erpSalesOrder.id}}
                                </td>
                                <td>
                                    <select id="erpProductionOrderList{{idx}}_enmuProvider" name="erpProductionOrderList[{{idx}}].enmuProvider" data-value="{{row.enmuProvider}}" class="input-small " readonly="true" disabled="true">
                                        <option value=""></option>
                                        <c:forEach items="${fns:getDictList('enum_provider')}" var="dict">
                                            <option value="${dict.value}">${dict.label}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                {{row.content}}
                                </td>
                                <td>
                                    <input id="erpProductionOrderList{{idx}}_orderTime" name="erpProductionOrderList[{{idx}}].orderTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
                                        value="{{row.orderTime}}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" readonly="true"/>
                                </td>
                                <td>
                                {{row.remarks}}
                                </td>
                            </tr>//-->
                        </script>
                        <script type="text/javascript">
                            var erpProductionOrderRowIdx = 0, erpProductionOrderTpl = $("#erpProductionOrderTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
                            $(document).ready(function() {
                                var data = ${fns:toJson(erpSalesOrder.erpProductionOrderList)};
                                for (var i=0; i<data.length; i++){
                                    addRow('#erpProductionOrderList', erpProductionOrderRowIdx, erpProductionOrderTpl, data[i]);
                                    erpProductionOrderRowIdx = erpProductionOrderRowIdx + 1;
                                }
                            });
                        </script>
                    </div>
                </div>
            <div class="form-actions my-form-actions">
                <input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
            </div>
        </form:form>
    </div>
</body>
</html>