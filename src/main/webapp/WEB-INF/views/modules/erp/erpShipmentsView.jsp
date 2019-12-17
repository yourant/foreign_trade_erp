<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>发货单管理</title>
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
		<li><a href="${ctx}/erp/erpShipments/">发货单列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpShipments/form?id=${erpShipments.id}">发货单<shiro:hasPermission name="erp:erpShipments:edit">${not empty erpShipments.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpShipments:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="erpShipments" action="${ctx}/erp/erpShipments/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">提单号：</label>
                <div class="controls">
                    ${erpShipments.blno}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">入货通知附件：</label>
                <div class="controls">
                    <form:hidden id="noticeFile" path="noticeFile" htmlEscape="false" maxlength="11" class="input-xlarge"/>
                    <sys:ckfinder input="noticeFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"   readonly="true"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">提单类型：</label>
                <div class="controls">
                    <form:select path="enumBillType" class="input-xlarge "  readonly="true" disabled="true">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('enum_bill_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">发货日期：</label>
                <div class="controls">
                    <fmt:formatDate value="${erpShipments.deliveryTime}" pattern="yyyy-MM-dd" />
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">报关单号：</label>
                <div class="controls">
                    ${erpShipments.billManifestNo}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">报关单附件：</label>
                <div class="controls">
                    <form:hidden id="billManifestFile" path="billManifestFile" htmlEscape="false" maxlength="11" class="input-xlarge"/>
                    <sys:ckfinder input="billManifestFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"   readonly="true"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">提单附件：</label>
                <div class="controls">
                    <form:hidden id="billLadingFile" path="billLadingFile" htmlEscape="false" maxlength="11" class="input-xlarge"/>
                    <sys:ckfinder input="billLadingFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"   readonly="true"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">海运账单附件：</label>
                <div class="controls">
                    <form:hidden id="priceManifestFile" path="priceManifestFile" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                    <sys:ckfinder input="priceManifestFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"   readonly="true"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">离港日期：</label>
                <div class="controls">
                    <fmt:formatDate value="${erpShipments.sendTime}" pattern="yyyy-MM-dd" />
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">预计到达日期：</label>
                <div class="controls">
                    <fmt:formatDate value="${erpShipments.preComeTime}" pattern="yyyy-MM-dd" />
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">快递公司：</label>
                <div class="controls">
                    <form:select path="enumExpressCompany" class="input-xlarge "  readonly="true" disabled="true">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('enum_express_company')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">文件寄送单号：</label>
                <div class="controls">
                    ${erpShipments.expressNum}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">快递单据附件：</label>
                <div class="controls">
                    <form:hidden id="expressFile" path="expressFile" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                    <sys:ckfinder input="expressFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"   readonly="true"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">货物类型：</label>
                <div class="controls">
                    ${erpShipments.enumShipmentsType}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">发货状态：</label>
                <div class="controls">
                    <form:select path="status" class="input-xlarge "  readonly="true" disabled="true">
                        <form:option value="" label=""/>
                        <form:options items="${fns:getDictList('status_shipments')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                    </form:select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注信息：</label>
                <div class="controls">
                    <pre>
                    ${erpShipments.remarks}
                    </pre>
                </div>
            </div>
                <div class="control-group">
                    <label class="control-label">集装箱：</label>
                    <div class="controls">
                        <table id="contentTable" class="table table-striped table-bordered table-condensed">
                            <thead>
                                <tr>
                                    <th class="hide"></th>
                                    <th>集装箱号</th>
                                    <th>铅封号</th>
                                    <th>其余</th>
                                    <th>备注信息</th>
                                    <shiro:hasPermission name="erp:erpShipments:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
                                </tr>
                            </thead>
                            <tbody id="erpDockerList">
                            </tbody>
                        </table>
                        <script type="text/template" id="erpDockerTpl">//<!--
                            <tr id="erpDockerList{{idx}}">
                                <td class="hide">
                                    <input id="erpDockerList{{idx}}_id" name="erpDockerList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
                                    <input id="erpDockerList{{idx}}_delFlag" name="erpDockerList[{{idx}}].delFlag" type="hidden" value="0"/>
                                </td>
                                <td>
                                {{row.dockerNo}}
                                </td>
                                <td>
                                {{row.sealNo}}
                                </td>
                                <td>
                                {{row.parts}}
                                </td>
                                <td>
                                {{row.remarks}}
                                </td>
                            </tr>//-->
                        </script>
                        <script type="text/javascript">
                            var erpDockerRowIdx = 0, erpDockerTpl = $("#erpDockerTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
                            $(document).ready(function() {
                                var data = ${fns:toJson(erpShipments.erpDockerList)};
                                for (var i=0; i<data.length; i++){
                                    addRow('#erpDockerList', erpDockerRowIdx, erpDockerTpl, data[i]);
                                    erpDockerRowIdx = erpDockerRowIdx + 1;
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