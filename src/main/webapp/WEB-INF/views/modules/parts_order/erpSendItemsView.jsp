<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>配件订单管理</title>
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

        function color(){
            $('.my-send-checkbox').filter(function (i, n) {
                return $(n).data('dockerKey') !== '-'
            }).each(function (i, n) {
                var dockerKey = $(n).data('dockerKey');
                $(n).parent('td').css('background-color', '')
                $('.my-docker-radio').filter(function (i, n) {
                    return $(n).data('dockerKey') === dockerKey && $(n).parent().prev().children('input:last').val() === '0';
                }).each(function(ii,nn){
                    var color = $(nn).parent('td').css('background-color');
                    $(n).parent('td').css('background-color', color);
                });
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
                $(obj).parent().parent().children('td:nth-child(2)').children('input').attr({'readonly':true,'checked':false,'disabled':true});
                $("#erpSendItemsList").find("tr").each(function(){
                    if($(this).find("td.hide input:first").val() == ""){
                        $(this).remove();
                        $(obj).parent().parent().remove();
                    }else{
                        if($(this).data("vinid") == id.val()){
                            $(this).addClass("error");
                            $(this).find("td.hide input:last").val("1")
                        }
                        if($(this).data("dockerid") == id.val()){//删除集装箱信息 也删除选中效果
                            $(this).children('td').eq(1).css('background-color','');
                        }
                    }
                });
            } else if (delFlag.val() == "1") {
                delFlag.val("0");
                $(obj).html("&times;").attr("title", "删除");
                $(obj).parent().parent().removeClass("error");
                $(obj).parent().parent().children('td:nth-child(2)').children('input').attr({'readonly':false,'disabled':false});
                $("#erpSendItemsList").find("tr").each(function(){
                    if($(this).data("vinid") == id.val()){//删除配件级联删除发货信息
                        $(this).removeClass("error");
                        $(this).find("td.hide input:last").val("0")
                    }
                });
            }

            color();
            totalMoney();
        }
        function getRandomSafeColor() {
            var base = ['00','33','66','99','CC','FF'];     //基础色代码
            var len = base.length;                          //基础色长度
            var bg = new Array();                           //返回的结果
            var random = Math.ceil(Math.random()*215+1);    //获取1-216之间的随机数
            var res;
            for(var r = 0; r < len; r++){
                for(var g = 0; g < len; g++){
                    for(var b = 0; b < len; b++){
                        bg.push('#'+base[r].toString()+base[g].toString()+base[b].toString());
                    }
                };
            };
            for(var i=0;i<bg.length;i++){
                res =  bg[random];
            }
            return res;
        }
        function showItemsDialog(url, title) {
            showDialogByUrl(url, title, window);
        }
        function totalMoney(){
            var totalMoney = $('.sum').filter(function(){  return $(this).parent('td').parent('tr').find('.my-delFlag').val() == "0"}).map(function(){var priceDan = $(this).parent('td').prev().prev().prev().text(); return parseInt(priceDan) * parseInt($(this).val() | 0);}).get().join('+');
            $('#price').val(eval(totalMoney));
		}
	</script>
</head>
<body>
<ul class="nav nav-tabs my-nav-tabs">
	<li class="active"><a>配件订单查看</a></li>
</ul><br/>
<div class="my-container">
	<form:form id="inputForm" modelAttribute="erpPartsOrder" action="${ctx}/erp/erpPartsOrder/save" method="post" class="form-horizontal">
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
			<label class="control-label">PI：</label>
			<div class="controls">
					${erpPartsOrder.pi}
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">PI附件：</label>
			<div class="controls">
				<form:hidden id="piFile" path="piFile" htmlEscape="false" maxlength="11" class="input-xlarge"/>
				<sys:ckfinder input="piFile" type="files" uploadPath="/erp/erpPartsOrder" selectMultiple="true" readonly="true"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge hide" readonly="true" disabled="true"/>
				<sys:ckeditor replace="remarks" uploadPath="/erp/erpPartsOrder/remarks" height="200"/>
			</div>
		</div>
		<div id="shipping-info">

		</div>
			<div class="control-group">
				<div class="text-center">
					<button type="button" class="btn btn-primary active btn-lg switchSendItems" data-status="express">快递</button>
					<button type="button" class="btn btn-lg switchSendItems" data-status="shipments">拼箱</button>
				</div>
			</div>
			<fieldset id="shipments" class="hide">
				<legend>
					拼箱信息
				</legend>
				<fieldset>
					<legend>
						主信息
					</legend>
					<table class="table-form">
						<form:hidden path="erpShipments.id"/>
						<tr>
							<td class="tit">提单号:</td>
							<td>
								${erpPartsOrder.erpShipments.blno}
							</td>
							<td class="tit">提单类型:</td>
							<td>
								<form:select path="erpShipments.enumBillType" id="enumBillType" class="input-xlarge " readonly="true" disabled="true">
									<form:option value="" label=""/>
									<form:options items="${fns:getDictList('enum_bill_type')}" itemLabel="label"
												  itemValue="value" htmlEscape="false"/>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="tit">货物类型:</td>
							<td>
								<form:select path="erpShipments.enumShipmentsType" class="input-xlarge " readonly="true" disabled="true">
									<form:option value="" label=""/>
									<form:options items="${fns:getDictList('enum_shipments_type')}" itemLabel="label"
												  itemValue="value" htmlEscape="false"/>
								</form:select>
							</td>
							<td class="tit">发货时间:</td>
							<td>
								<fmt:formatDate value="${erpPartsOrder.erpShipments.deliveryTime}" pattern="yyyy-MM-dd" />
							</td>
						</tr>
						<tr>
							<td class="tit">入货通知附件:</td>
							<td colspan="3">
								<form:hidden id="noticeFile" path="erpShipments.noticeFile" htmlEscape="false" maxlength="11"
											 class="input-xlarge"/>
								<sys:ckfinder input="noticeFile" type="files" uploadPath="/erp/erpShipments"
											  selectMultiple="true" readonly="true"/>
							</td>
						</tr>
						<tr>
							<td class="tit">备注信息:</td>
							<td colspan="3">
								<form:textarea id="erpShipmentsRemarks" path="erpShipments.remarks" htmlEscape="false" rows="4" maxlength="255"
											   class="input-xxlarge hide" readonly="true" disabled="true"/>
								<sys:ckeditor replace="erpShipmentsRemarks" uploadPath="/test" height="200"/>
							</td>
						</tr>
					</table>
				</fieldset>
				<fieldset>
					<legend>
						海关信息
					</legend>
					<table class="table-form">
						<tr>
							<td class="tit">报关单号:</td>
							<td>
								${erpPartsOrder.erpShipments.billManifestNo}
							</td>
							<td class="tit">离港时间:</td>
							<td>
								<fmt:formatDate value="${erpPartsOrder.erpShipments.sendTime}" pattern="yyyy-MM-dd" />
							</td>
							<td class="tit">预计到达时间:</td>
							<td>
								<fmt:formatDate value="${erpPartsOrder.erpShipments.preComeTime}" pattern="yyyy-MM-dd" />
							</td>
						</tr>
						<tr>
							<td class="tit">报关单附件:</td>
							<td>
								<form:hidden id="billManifestFile" path="erpShipments.billManifestFile" htmlEscape="false" maxlength="11"
											 class="input-xlarge"/>
								<sys:ckfinder input="billManifestFile" type="files" uploadPath="/erp/erpShipments"
											  selectMultiple="true" readonly="true"/>
							</td>
							<td class="tit">提单附件:</td>
							<td>
								<form:hidden id="billLadingFile" path="erpShipments.billLadingFile" htmlEscape="false" maxlength="11"
											 class="input-xlarge"/>
								<sys:ckfinder input="billLadingFile" type="files" uploadPath="/erp/erpShipments"
											  selectMultiple="true" readonly="true"/>
							</td>
							<td class="tit">海运账单附件:</td>
							<td>
								<form:hidden id="priceManifestFile" path="erpShipments.priceManifestFile" htmlEscape="false" maxlength="255"
											 class="input-xlarge"/>
								<sys:ckfinder input="priceManifestFile" type="files" uploadPath="/erp/erpShipments"
											  selectMultiple="true" readonly="true"/>
							</td>
						</tr>
					</table>
				</fieldset>
				<fieldset>
					<legend>
						集装箱信息
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
							</table>
							<script type="text/template" id="erpDockerTpl">//<!--
						<tr id="erpDockerList{{idx}}">
							<td class="hide">
								<input id="erpDockerList{{idx}}_id" name="erpShipments.erpDockerList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="erpDockerList{{idx}}_delFlag" name="erpShipments.erpDockerList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td width="15" style="background-color: {{row.bgColor}};">
								<input type="radio" name="myDockerRadio" readonly="true" disabled="true" data-docker-key="{{row.dockerNo}}-{{row.sealNo}}" class="my-checkbox my-docker-radio"  value="" />
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
								<textarea id="erpDockerList{{idx}}_remarks" readonly="true" disabled="true" name="erpShipments.erpDockerList[{{idx}}].remarks" rows="4" maxlength="255" class="input-small ">{{row.remarks}}</textarea>
							</td>
							<shiro:hasPermission name="erp:erpShipments:edit"><td class="text-center" width="10">

							</td></shiro:hasPermission>
						</tr>//-->
							</script>
							<script type="text/javascript">
                                var erpDockerRowIdx = 0,
                                    erpDockerTpl = $("#erpDockerTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                                $(document).ready(function () {
                                    var data = ${fns:toJson(erpPartsOrder.erpShipments.erpDockerList)};
                                    for (var i = 0; i < data.length; i++) {
                                        data[i].bgColor = getRandomSafeColor();
                                        addRow('#erpDockerList', erpDockerRowIdx, erpDockerTpl, data[i]);
                                        erpDockerRowIdx = erpDockerRowIdx + 1;
                                    }
                                });
							</script>
						</div>
					</div>
				</fieldset>
			</fieldset>
			<fieldset id="express">
				<legend>
					快递信息
				</legend>
				<table class="table-form">
					<form:hidden path="erpExpress.id"/>
					<tr>
						<td class="tit">快递公司:</td>
						<td>
							<form:select path="erpExpress.enumExpressCompany" class="input-xlarge " readonly="true" disabled="true" >
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('enum_express_company')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</td>
						<td class="tit">快递单号:</td>
						<td>
							${erpPartsOrder.erpExpress.expressNo}
						</td>
						<td class="tit">快递费:</td>
						<td>
							${erpPartsOrder.erpExpress.price}
						</td>
						<td class="tit">快递时间:</td>
						<td>
							<fmt:formatDate value="${erpPartsOrder.erpExpress.expressDate}" pattern="yyyy-MM-dd"/>
						</td>
					</tr>
					<tr>
						<td class="tit">备注信息:</td>
						<td colspan="7">
							<form:textarea id="erpExpressRemarks" path="erpExpress.remarks" htmlEscape="false" rows="4" maxlength="255"
										   class="input-xxlarge hide" readonly="true" disabled="true" />
							<sys:ckeditor replace="erpExpressRemarks" uploadPath="/test" height="200"/>
						</td>
					</tr>
				</table>
			</fieldset>
		<fieldset>
			<legend>
				发货信息
			</legend>
			<div class="control-group">
				<div>
					<table class="table table-striped table-bordered table-condensed">
						<thead>
						<tr>
							<th class="hide"></th>
							<th width="15"></th>
							<th>配件</th>
							<th>价格</th>
							<th>车型</th>
							<th>发动机型号</th>
							<th>数量</th>
							<th>金额</th>
							<th>备注信息</th>
							<shiro:hasPermission name="erp:erpSendItems:edit">
								<th width="10">&nbsp;</th>
							</shiro:hasPermission>
						</tr>
						</thead>
						<tbody id="erpSendItemsList">
						</tbody>
						<tfoot>
						<tr>
							<td colspan="6">
								<%--<a href="javascript:"
									 onclick="addRow('#erpSendItemsList', erpSendItemsRowIdx, erpSendItemsTpl);erpSendItemsRowIdx = erpSendItemsRowIdx + 1;"
											   class="btn">新增</a>--%>
							</td>
							<td colspan="2">
								总价：<c:if test="${!fns:contains(erpPartsOrder.status,'1,2,3,5,7')}">${erpPartsOrder.price}</c:if><c:if test="${fns:contains(erpPartsOrder.status,'1,2,3,5,7')}"><input name="price" id="price" disabled="disabled" readonly="readonly"></c:if>
							</td>
						</tr>
						</tfoot>
					</table>
					<script type="text/template" id="erpSendItemsTpl">//<!--
						<tr id="erpSendItemsList{{idx}}" class="sendItems-lists" data-vinid="{{row.erpVin.id}}" data-dockerid="{{row.erpDocker.id}}">
							<td class="hide">
								<input id="erpSendItemsList{{idx}}_id" name="erpSendItemsList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="erpSendItemsList{{idx}}_delFlag" class="my-delFlag" name="erpSendItemsList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td width="15">
								{{#row.erpExpress.id}}
									<input type="checkbox" readonly="true" disabled="true" data-status-key="express" data-docker-key="{{row.erpDocker.dockerNo}}-{{row.erpDocker.sealNo}}" class="my-checkbox my-send-checkbox" checked="checked" value=""/>
									<input id="erpSendItemsList{{idx}}_statusKey" name="erpSendItemsList[{{idx}}].statusKey" type="hidden" value="express"/>
								{{/row.erpExpress.id}}
								{{#row.erpDocker.id}}
									<input type="checkbox" readonly="true" disabled="true" data-status-key="shipments" data-docker-key="{{row.erpDocker.dockerNo}}-{{row.erpDocker.sealNo}}" class="my-checkbox hide my-send-checkbox" checked="checked" value=""/>
									<input id="erpSendItemsList{{idx}}_statusKey" name="erpSendItemsList[{{idx}}].statusKey" type="hidden" value="shipments"/>
								{{/row.erpDocker.id}}
								{{^row.erpExpress.id}}
									{{^row.erpDocker.id}}
										<input type="checkbox" readonly="true" disabled="true" data-status-key="" data-docker-key="{{row.erpDocker.dockerNo}}-{{row.erpDocker.sealNo}}" class="my-checkbox my-send-checkbox" value=""/>
										<input id="erpSendItemsList{{idx}}_statusKey" name="erpSendItemsList[{{idx}}].statusKey" type="hidden" value=""/>
									{{/row.erpDocker.id}}
								{{/row.erpExpress.id}}
								<input id="erpSendItemsList{{idx}}_dockerKey" name="erpSendItemsList[{{idx}}].dockerKey" type="hidden" value="{{row.erpDocker.dockerNo}}-{{row.erpDocker.sealNo}}"/>
							</td>
							<td>
								<input id="erpSendItemsList{{idx}}_erpCarPartsID" name="erpSendItemsList[{{idx}}].erpCarParts.id" type="hidden" value="{{row.erpCarParts.id}}" class="input-small "/>
								{{row.erpCarParts.aname}}
							</td>
							<td class="price">
								{{row.erpCarParts.price}}
							</td>
							<td>
								{{row.erpCarParts.erpCarType.aname}}
							</td>
							<td>
								{{row.erpCarParts.erpEngineType.aname}}
							</td>
							<td>
								<input id="erpSendItemsList{{idx}}_count" name="erpSendItemsList[{{idx}}].count" type="number" min="0" value="{{row.count}}" maxlength="11" class="input-small digits sum" disabled="true" readonly="true"/>
							</td>
							<td>
								<p class="sum_price"></p>
							</td>
							<td>
								<textarea id="erpSendItemsList{{idx}}_remarks" name="erpSendItemsList[{{idx}}].remarks" rows="4" maxlength="255" class="input-small " disabled="true" readonly="true">{{row.remarks}}</textarea>
							</td>
							<shiro:hasPermission name="erp:erpSendItems:edit"><td class="text-center" width="10">

							</td></shiro:hasPermission>
						</tr>//-->
					</script>
					<script type="text/javascript">
                        var erpSendItemsRowIdx = 0, erpSendItemsTpl = $("#erpSendItemsTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
                        $(document).ready(function() {
                            var data = ${fns:toJson(erpPartsOrder.erpSendItemsList)};
                            for (var i=0; i<data.length; i++){
                                addRow('#erpSendItemsList', erpSendItemsRowIdx, erpSendItemsTpl, data[i]);
                                if(data[i].count){
                                    $('#erpSendItemsList'+i).find('.sum_price').text(data[i].erpCarParts.price*data[i].count);
                                }
                                erpSendItemsRowIdx = erpSendItemsRowIdx + 1;
                            }
							color();
                            totalMoney();
                        });
                        $(function () {

                            $('.my-vin-radio').live('click', function () {
                                var vinId = $('.my-vin-radio').filter(':checked').parents('td').siblings().children('input:first').val()
								$("#erpSendItemsList tr").removeClass("info");
                                $("tr[data-vinid='"+vinId+"']").addClass("info");
                            });
                            $('.my-send-checkbox').live('click', function () {
                                var isChecked = $(this).prop('checked');

                                var status = $('button.switchSendItems.active').data('status');

                                if (isChecked) {
                                    if(status == "shipments"){//如果是拼箱必须选择集装箱
                                        var dockerKey = $('.my-docker-radio').filter(':checked').data('dockerKey');
                                        var bgcolor = $('.my-docker-radio').filter(':checked').parent().css('background-color');
                                        if(!dockerKey){
                                            top.$.jBox.tip("请先选择集装箱");
                                            $(this).prop('checked',false);
										}else{
                                            $(this).data('statusKey', status);
                                            $(this).next("input").val(status);
                                            $(this).data('dockerKey', dockerKey);
                                            $(this).siblings("input:last").val(dockerKey);
                                            $(this).parent().css('background-color',bgcolor);
										}
									}else{
                                        $(this).data('statusKey', status);
                                        $(this).next("input").val(status);
                                        $(this).removeData('dockerKey');
                                        $(this).siblings("input:last").val('');
                                        $(this).parent().css('background-color','');
									}
                                } else {
                                    $(this).removeData('statusKey');
                                    $(this).removeData('dockerKey');
                                    $(this).next("input").val("");
                                    $(this).siblings("input:last").val('');
                                    $(this).parent().css('background-color','');
                                }
                            });
                            $("button.switchSendItems").live('click', function(){
                                $(this).addClass("btn-primary active").siblings().removeClass("btn-primary active");
                                var status = $(this).data("status");
                                if(status == "express"){
                                    $("#express").show();
                                    $("#shipments").hide();
                                }else{
                                    $("#express").hide();
                                    $("#shipments").show();
                                }
                                $('.my-send-checkbox').removeClass('hide');
								$('.my-send-checkbox').filter(':checked').filter(function () {
									return status !== $(this).data('statusKey')
								}).addClass('hide');
                            });
                            $('.my-docker-radio').live('click', function (evt) {
                                var dockerKey = $('.my-docker-radio').filter(':checked').parents('td').siblings().children('input').slice(2, 4).map(function () {
                                    return $(this).val()
                                }).get().join('-');

                                if (dockerKey === '-') {
                                    alertx('请填写集装箱号');
                                    evt.stopPropagation();
                                    evt.preventDefault();
                                    return;
                                }
                                if($(this).parent().css('background-color') == "rgb(249, 249, 249)" || $(this).parent().css('background-color') == "rgba(0, 0, 0, 0)"){
                                    $(this).parent().css('background-color',getRandomSafeColor());
								}

                                var oldDockerKey = $(this).data('dockerKey');
                                if (oldDockerKey === '-') {
                                    oldDockerKey = dockerKey;
                                    $(this).data('dockerKey', dockerKey);
                                }
                            });
                        })
					</script>
				</div>
			</div>
		</fieldset>
		<%@ include file="../../include/approveInfo.jspf" %>
		<div class="form-actions my-form-actions">
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</div>
<script>
    $(function () {
        $('.sum').keyup(function () {
            var $count = 0,
                $priceTotalObj = $(this).parents('.sendItems-lists').find('.sum_price'),
                $price = $(this).parents('.sendItems-lists').find('.price').html(),  //单价
                $priceTotal = 0;
            if ($(this).val() == '') {
                $(this).val('1');
            }
            $(this).val($(this).val().replace(/\D|^0/g, ''));
            $count = $(this).val();
            $priceTotal = $count * parseInt($price);
            $(this).attr('value', $count);
            $priceTotalObj.html($priceTotal);
            totalMoney();
        })

    })
</script>
</body>
</html>