<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>生产订单管理</title>
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
		<li><a href="${ctx}/erp/erpProductionOrder/">生产订单列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpProductionOrder/form?id=${erpProductionOrder.id}">生产订单<shiro:hasPermission name="erp:erpProductionOrder:edit">${not empty erpProductionOrder.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpProductionOrder:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="erpProductionOrder" action="${ctx}/erp/erpProductionOrder/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">销售订单：</label>
                <div class="controls">
                    ${erpProductionOrder.erpSalesOrder.id}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">供应商：</label>
                <div class="controls">
                    <form:select path="enmuProvider" class="input-xlarge "  readonly="true" disabled="true">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('enum_provider')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">生产计划：</label>
                <div class="controls">
                    <form:hidden id="content" path="content" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                    <sys:ckfinder input="content" type="files" uploadPath="/ProductionPlain" selectMultiple="true" readonly="true"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">下单日期：</label>
                <div class="controls">
                    <fmt:formatDate value="${erpProductionOrder.orderTime}" pattern="yyyy-MM-dd" />
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注信息：</label>
                <div class="controls">
                    <pre>
                    ${erpProductionOrder.remarks}
                    </pre>
                </div>
            </div>
                <div class="control-group">
                    <label class="control-label">生产明细：</label>
                    <div class="controls">
                        <table id="contentTable" class="table table-striped table-bordered table-condensed">
                            <thead>
                                <tr>
                                    <th class="hide"></th>
                                    <th>发动机型号</th>
                                    <th>车型</th>
                                    <th>数量</th>
                                    <th>备注信息</th>
                                    <shiro:hasPermission name="erp:erpProductionOrder:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
                                </tr>
                            </thead>
                            <tbody id="erpProductionItemsList">
                            </tbody>
                        </table>
                        <script type="text/template" id="erpProductionItemsTpl">//<!--
                            <tr id="erpProductionItemsList{{idx}}">
                                <td class="hide">
                                    <input id="erpProductionItemsList{{idx}}_id" name="erpProductionItemsList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
                                    <input id="erpProductionItemsList{{idx}}_delFlag" name="erpProductionItemsList[{{idx}}].delFlag" type="hidden" value="0"/>
                                </td>
                                <td>
                                    <select id="erpProductionItemsList{{idx}}_erpEngineType" name="erpProductionItemsList[{{idx}}].erpEngineType.id" data-value="{{row.erpEngineType.id}}" class="input-small " readonly="true" disabled="true">
                                        <option value=""></option>
                                        <c:forEach items="${fns:getDictList('')}" var="dict">
                                            <option value="${dict.value}">${dict.label}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <select id="erpProductionItemsList{{idx}}_erpCarType" name="erpProductionItemsList[{{idx}}].erpCarType.id" data-value="{{row.erpCarType.id}}" class="input-small " readonly="true" disabled="true">
                                        <option value=""></option>
                                        <c:forEach items="${fns:getDictList('')}" var="dict">
                                            <option value="${dict.value}">${dict.label}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                {{row.count}}
                                </td>
                                <td>
                                {{row.remarks}}
                                </td>
                            </tr>//-->
                        </script>
                        <script type="text/javascript">
                            var erpProductionItemsRowIdx = 0, erpProductionItemsTpl = $("#erpProductionItemsTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
                            $(document).ready(function() {
                                var data = ${fns:toJson(erpProductionOrder.erpProductionItemsList)};
                                for (var i=0; i<data.length; i++){
                                    addRow('#erpProductionItemsList', erpProductionItemsRowIdx, erpProductionItemsTpl, data[i]);
                                    erpProductionItemsRowIdx = erpProductionItemsRowIdx + 1;
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