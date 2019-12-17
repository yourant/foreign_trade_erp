<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>支付类型管理</title>
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
		<li><a href="${ctx}/erp/erpPayType/">支付类型列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpPayType/form?id=${erpPayType.id}">支付类型<shiro:hasPermission name="erp:erpPayType:edit">${not empty erpPayType.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpPayType:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="erpPayType" action="${ctx}/erp/erpPayType/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">销售订单：</label>
                <div class="controls">
                    ${erpPayType.erpSalesOrder.id}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">付款方式：</label>
                <div class="controls">
                    <form:select path="enmuPaymentType" class="input-xlarge required"  readonly="true" disabled="true">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('enmu_payment_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">付款方式比例：</label>
                <div class="controls">
                    ${erpPayType.scale}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">应付总金额：</label>
                <div class="controls">
                    ${erpPayType.sumPrice}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注信息：</label>
                <div class="controls">
                    <pre>
                    ${erpPayType.remarks}
                    </pre>
                </div>
            </div>
                <div class="control-group">
                    <label class="control-label">支付金额：</label>
                    <div class="controls">
                        <table id="contentTable" class="table table-striped table-bordered table-condensed">
                            <thead>
                                <tr>
                                    <th class="hide"></th>
                                    <th>应付款</th>
                                    <th>实付款</th>
                                    <th>付款时间</th>
                                    <th>付款比例</th>
                                    <th>支付截图</th>
                                    <%--<th>备注信息</th>--%>
                                    <shiro:hasPermission name="erp:erpPayType:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
                                </tr>
                            </thead>
                            <tbody id="erpPayMoneyList">
                            </tbody>
                        </table>
                        <script type="text/template" id="erpPayMoneyTpl">//<!--
                            <tr id="erpPayMoneyList{{idx}}">
                                <td class="hide">
                                    <input id="erpPayMoneyList{{idx}}_id" name="erpPayMoneyList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
                                    <input id="erpPayMoneyList{{idx}}_delFlag" name="erpPayMoneyList[{{idx}}].delFlag" type="hidden" value="0"/>
                                </td>
                                <td>
                                {{row.payableMoney}}
                                </td>
                                <td>
                                {{row.comeMoney}}
                                </td>
                                <td>
                                    <input id="erpPayMoneyList{{idx}}_time" name="erpPayMoneyList[{{idx}}].time" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "
                                        value="{{row.time}}" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});" readonly="true"/>
                                </td>
                                <td>
                                {{row.scale}}
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
                        <script type="text/javascript">
                            var erpPayMoneyRowIdx = 0, erpPayMoneyTpl = $("#erpPayMoneyTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
                            $(document).ready(function() {
                                var data = ${fns:toJson(erpPayType.erpPayMoneyList)};
                                for (var i=0; i<data.length; i++){
                                    addRow('#erpPayMoneyList', erpPayMoneyRowIdx, erpPayMoneyTpl, data[i]);
                                    erpPayMoneyRowIdx = erpPayMoneyRowIdx + 1;
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