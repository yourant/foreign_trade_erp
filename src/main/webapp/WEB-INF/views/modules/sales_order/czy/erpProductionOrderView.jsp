<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>查看生产订单</title>
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
	<li class="active"><a>查看生产订单</a></li>
</ul><br/>
<div class="my-container">
	<form:form id="inputForm" modelAttribute="erpSalesOrder" action="${ctx}/erp/erpSalesOrder/save" method="post" class="form-horizontal">
	<form:hidden path="id"/>
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
		<label class="control-label">PI 附件：</label>
		<div class="controls">
			<form:hidden id="piFile" path="piFile" htmlEscape="false" maxlength="11" class="input-xlarge"/>
			<sys:ckfinder input="piFile" type="files" uploadPath="/erp/erpSalesOrder" selectMultiple="true" readonly="true" />
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">简要生产计划：</label>
		<div class="controls">
			<form:hidden id="productionPlain" path="productionPlain" htmlEscape="false" maxlength="255" class="input-xlarge"/>
			<sys:ckfinder input="productionPlain" type="files" uploadPath="/erp/erpSalesOrder" selectMultiple="true" readonly="true" />
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">下单日期：</label>
		<div class="controls">
			<fmt:formatDate value="${erpSalesOrder.orderTime}" pattern="yyyy-MM-dd" />
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">备注信息：</label>
		<div class="controls">
			<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255"
						   class="input-xxlarge hide" disabled="true" readonly="true"/>
			<sys:ckeditor replace="remarks" uploadPath="/test" height="200"/>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">生产订单：</label>
		<div class="controls">
			<table class="table table-bordered table-condensed">
				<thead>
				<tr>
					<th class="hide"></th>
					<th>供应商</th>
					<th>生产计划</th>
					<th>下单日期</th>
					<th>备注信息</th>
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
								<select id="erpProductionOrderList{{idx}}_enmuProvider" name="erpProductionOrderList[{{idx}}].enmuProvider" data-value="{{row.enmuProvider}}" class="input-small " readonly="true" disabled="true">
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
							<td>
								<input id="erpProductionOrderList{{idx}}_orderTime" name="erpProductionOrderList[{{idx}}].orderTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
									value="{{row.orderTime}}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" readonly="true"/>
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
                    // .tab-content
                    var tabs = $('#erpProductionOrderList').children();
                    tabs.click(function () {
                        $('.tab-content tbody tr').removeClass('info').eq(tabs.removeClass('info').index($(this).addClass('info'))).addClass('info');
                    });
                });
			</script>
		</div>
	</div>
	<script type="text/template" id="erpProductionItemsTpl">//<!--
		<tr id="erpProductionItemsList{{idx}}">
			<td class="hide">
				<input id="erpProductionItemsList{{idx}}_id" name="erpProductionOrderList[{{row.statusIdx}}].erpProductionItemsList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
				<input id="erpProductionItemsList{{idx}}_delFlag" name="erpProductionOrderList[{{row.statusIdx}}].erpProductionItemsList[{{idx}}].delFlag" type="hidden" value="0"/>
			</td>
			<td>
				{{row.erpEngineType.aname}}
			</td>
			<td>
				{{row.erpCarType.aname}}
			</td>
			<td>
				{{row.count}}
			</td>
			<td>
				{{row.remarks}}
			</td>
		</tr>//-->
	</script>
	<c:forEach items="${erpSalesOrder.erpProductionOrderList}" var="erpProductionOrder" varStatus="status">
		<div class="control-group tab-content">
			<label class="control-label">生产明细：</label>
			<div class="controls">
				<table class="table table-bordered table-condensed">
					<thead>
					<tr>
						<th class="hide"></th>
						<th>发动机型号</th>
						<th>车型</th>
						<th>数量</th>
						<th>备注信息</th>
					</tr>
					</thead>
					<tbody id="erpProductionItems${status.index}">
					</tbody>
				</table>

				<script type="text/javascript">
                    var erpProductionOrder${status.index}erpProductionItemsRowIdx = 0, erpProductionItemsTpl = $("#erpProductionItemsTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
                    $(document).ready(function() {
                        var data = ${fns:toJson(erpProductionOrder.erpProductionItemsList)};
                        for (var i=0; i<data.length; i++){
                            data[i].statusIdx = ${status.index};
                            addRow('#erpProductionItems${status.index}', erpProductionOrder${status.index}erpProductionItemsRowIdx, erpProductionItemsTpl, data[i]);
                            erpProductionOrder${status.index}erpProductionItemsRowIdx = erpProductionOrder${status.index}erpProductionItemsRowIdx + 1;
                        }
                    });
				</script>
			</div>
		</div>
	</c:forEach>
</form:form>
</div>
</body>
</html>