<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>发货单管理</title>
	<meta name="decorator" content="default"/>
    <style>
        fieldset{padding:.35em .625em .75em;margin:0 2px;border:1px solid silver}

        legend{padding:.5em;border:0;width:auto}
    </style>
	<script type="text/javascript">
        $(document).ready(function() {
            //$("#name").focus();
            $("#inputForm").validate({
                submitHandler: function(form){
                    mappingDocterVin();
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
            $("#enumBillType").on("change",function(data){
                if(data.val == 1){//正本显示，电放不显示快递
                    $("#express").show();
                }else{
                    $("#express").hide();
                }
            })
        });
        function addRow(list, idx, tpl, row){
            $(list).append(Mustache.render(tpl, {
                idx: idx, delBtn: true, row: row
            }));
            $(list+idx).find("select").each(function(){
                $(this).val($(this).attr("data-value"));
            });
            $(list+idx).find("input[type='checkbox'], input[type='radio']").each(function(){
                try{
                    var ss = $(this).attr("data-value").split(',');
                    for (var i=0; i<ss.length; i++){
                        if($(this).val() == ss[i]){
                            $(this).attr("checked","checked");
                        }
                    }
                }catch (e){}
            });
        }
        function delRow(obj, prefix){
            var dockerKey = $(prefix+"_id").parent().next().find('input:radio').data('dockerKey');
            var length = $('.my-vin-checkbox').filter(':checked').filter(function(){ return dockerKey !== $(this).data('dockerKey')}).length;
            if(length > 0 ){
                alertx('请清空该集装箱里面的，才能删除');
                return;
            }
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
        <li class="active"><a>发货单查看</a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="erpShipments" action="${ctx}/erp/erpShipments/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <fieldset>
                <legend>
                    发货信息
                </legend>
                <table class="table-form">
                    <tr>
                        <td class="tit">提单号:</td>
                        <td>
                                ${erpShipments.blno}
                        </td>
                        <td class="tit">提单类型:</td>
                        <td>
                            <form:select path="enumBillType" class="input-xlarge "  readonly="true" disabled="true">
                                <form:option value="" label=""/>
                                <form:options items="${fns:getDictList('enum_bill_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                            </form:select>
                        </td>
                    </tr>
                    <tr>
                        <td class="tit">货物类型:</td>
                        <td>
                            <form:select path="enumShipmentsType" class="input-xlarge " readonly="true" disabled="true">
                                <form:option value="" label=""/>
                                <form:options items="${fns:getDictList('enum_shipments_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                            </form:select>
                        </td>
                        <td class="tit">发货时间:</td>
                        <td>
                            <fmt:formatDate value="${erpShipments.deliveryTime}" pattern="yyyy-MM-dd" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tit">入货通知附件:</td>
                        <td colspan="3">
                            <form:hidden id="noticeFile" path="noticeFile" htmlEscape="false" maxlength="11" class="input-xlarge"/>
                            <sys:ckfinder input="noticeFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"   readonly="true"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="tit">备注信息:</td>
                        <td colspan="3">
                            <form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255"
                                           class="input-xxlarge hide" readonly="true" disabled="true"/>
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
                                    <td width="15">
                                        <input type="radio" name="myRadio" data-docker-key="{{row.dockerNo}}-{{row.sealNo}}" class="my-checkbox my-docker-radio"  value="" />
                                    </td>
                                    <td>
                                        {{row.dockerNo}}
                                    </td>
                                    <td>
                                        {{row.sealNo}}
                                    </td>
                                    <%--<td>
                                        {{row.parts}}
                                    </td>--%>
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
						{{row.vinNo}}
					</td>
					<td>
						{{row.engineNo}}
					</td>
					<td>
						{{row.productor}}
					</td>
					<td>
						{{row.remarks}}
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
                                        <th>备注信息</th>
                                    </tr>
                                    </thead>
                                    <tbody id="boxList${status.index}">
                                    </tbody>
                                </table>
                                <script type="text/javascript">
                                    var erpVinRowIdx = 0, erpVinTpl = $("#erpVinTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
                                    $(document).ready(function() {
                                        var data = ${fns:toJson(erpProductionItems.erpVinList)};
                                        for (var i=0; i<data.length; i++){
                                            data[i].erpProductionItemsId = '${erpProductionItems.id}';
                                            addRow('#boxList${status.index}', erpVinRowIdx, erpVinTpl, data[i]);
                                            erpVinRowIdx = erpVinRowIdx + 1;
                                        }
                                        for (var i=0; i<${erpProductionItems.count}-data.length; i++){
                                            addRow('#boxList${status.index}', erpVinRowIdx, erpVinTpl,{erpProductionItemsId:'${erpProductionItems.id}'});
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
                                ${erpShipments.billManifestNo}
                        </td>
                        <td class="tit">离港时间:</td>
                        <td>
                            <fmt:formatDate value="${erpShipments.sendTime}" pattern="yyyy-MM-dd" />
                        </td>
                        <td class="tit">预计到达时间:</td>
                        <td>
                            <fmt:formatDate value="${erpShipments.preComeTime}" pattern="yyyy-MM-dd" />
                        </td>
                    </tr>
                    <tr>
                        <td class="tit">报关单附件:</td>
                        <td>
                            <form:hidden id="billManifestFile" path="billManifestFile" htmlEscape="false" maxlength="11" class="input-xlarge"/>
                            <sys:ckfinder input="billManifestFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"   readonly="true"/>
                        </td>
                        <td class="tit">提单附件:</td>
                        <td>
                            <form:hidden id="billLadingFile" path="billLadingFile" htmlEscape="false" maxlength="11" class="input-xlarge"/>
                            <sys:ckfinder input="billLadingFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"   readonly="true"/>
                        </td>
                        <td class="tit">海运账单附件:</td>
                        <td>
                            <form:hidden id="priceManifestFile" path="priceManifestFile" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                            <sys:ckfinder input="priceManifestFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"   readonly="true"/>
                        </td>
                    </tr>
                </table>
            </fieldset>

            <fieldset class=${erpShipments.enumBillType==2 ? "hide" : ""}>
                <legend>
                    快递信息
                </legend>
                <table class="table-form">
                    <tr>
                        <td class="tit">快递公司:</td>
                        <td>
                            <form:select path="enumExpressCompany" class="input-xlarge "  readonly="true" disabled="true">
                                <form:option value="" label=""/>
                                <form:options items="${fns:getDictList('enum_express_company')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
                            </form:select>
                        </td>
                        <td class="tit">文件寄送单号:</td>
                        <td>
                                ${erpShipments.expressNum}
                        </td>
                    </tr>
                    <tr>
                        <td class="tit">快递时间:</td>
                        <td>
                            <fmt:formatDate value="${erpShipments.expressDate}" pattern="yyyy-MM-dd" />
                        </td>
                        <td class="tit">快递单据附件:</td>
                        <td>
                            <form:hidden id="expressFile" path="expressFile" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                            <sys:ckfinder input="expressFile" type="files" uploadPath="/erp/erpShipments" selectMultiple="true"   readonly="true"/>
                        </td>
                    </tr>
                </table>
            </fieldset>
            <div class="form-actions my-form-actions">
                <input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
            </div>
        </form:form>
        <script>
            function mappingDocterVin() {
                $('.my-docker-radio').each(function(i,n){
                    var newDockerKey = $(this).parents('td').siblings().children('input').slice(2, 4).map(function(){return $(this).val()}).get().join('-');
                    var dockerKey = $(this).data('dockerKey')
                    $('.my-vin-checkbox').filter(function(){ return dockerKey === $(this).data('dockerKey')}).each(function(i,n){
                        $(this).parents('td').siblings().children('input').eq(6).val(newDockerKey);
                    });
                })
            }
            $(function(){
                $('.my-vin-checkbox').live('click',function(){
                    var isChecked = $(this).prop('checked');

                    var dockerKey = $('.my-docker-radio').filter(':checked').data('dockerKey');

                    if(isChecked){
                        $(this).data('dockerKey', dockerKey);
                        $(this).parents('td').siblings().children('input').eq(6).val(dockerKey);
                    }else{
                        $(this).removeData('dockerKey');
                        $(this).parents('td').siblings().children('input').eq(6).val('');
                    }
                });

                $('.my-docker-radio').live('click', function(evt){
                    var dockerKey =$('.my-docker-radio').filter(':checked').parents('td').siblings().children('input').slice(2, 4).map(function(){return $(this).val()}).get().join('-');

//                 var newDockerKey = $(this).parents('td').siblings().children('input').slice(2, 4).map(function(){return $(this).val()}).get().join('-');
                    if ( dockerKey === '-'){
                        alertx('请填写集装箱号');
                        evt.stopPropagation();
                        evt.preventDefault();
                        return;
                    }

                    $('.my-vin-checkbox').removeClass('hide');
//                var dockerKey =$('.my-docker-radio').filter(':checked').parents('td').siblings().children('input').slice(2, 4).map(function(){return $(this).val()}).get().join('-');


                    var oldDockerKey = $(this).data('dockerKey');
                    if(oldDockerKey === '-'){
                        oldDockerKey=dockerKey;
                        $(this).data('dockerKey', dockerKey);
                    }
                    var isChecked = $(this).prop('checked');
                    if(isChecked){
                        $('.my-vin-checkbox').filter(':checked').filter(function(){ return oldDockerKey !== $(this).data('dockerKey')}).addClass('hide');
                    }
                });
            })
        </script>
    </div>
</body>
</html>