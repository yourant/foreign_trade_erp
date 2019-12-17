<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>三包订单管理</title>
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
	</script>
</head>
<body>
<ul class="nav nav-tabs my-nav-tabs">
	<li class="active"><a>录入${fns:contains(erpRepairOrder.status,'4,8')?'发货信息':'配件信息'}</a></li>
</ul><br/>
<div class="my-container">
	<form:form id="inputForm" modelAttribute="erpRepairOrder" action="${ctx}/erp/erpRepairOrder/save" method="post" class="form-horizontal">
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
			<label class="control-label">解决方案类型：</label>
			<div class="controls">
				<form:select path="enumSolutionType" class="input-xlarge required"  readonly="true" disabled="true">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('enum_solution_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">维修配件：</label>
			<div class="controls">
				<form:textarea path="requireParts" htmlEscape="false" rows="4" maxlength="255"
							   class="input-xxlarge hide" disabled="true" readonly="true"/>
				<sys:ckeditor replace="requireParts" uploadPath="/test" height="200"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255"
							   class="input-xxlarge "/>
				<sys:ckeditor replace="remarks" uploadPath="/test" height="200"/>
			</div>
		</div>
		<div id="shipping-info">

		</div>
		<c:if test="${fns:contains(erpRepairOrder.status,'4,6,8')}">
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
								<form:input path="erpShipments.blno" htmlEscape="false" maxlength="25" class="input-xlarge "/>
							</td>
							<td class="tit">提单类型:</td>
							<td>
								<form:select path="erpShipments.enumBillType" id="enumBillType" class="input-xlarge ">
									<form:option value="" label=""/>
									<form:options items="${fns:getDictList('enum_bill_type')}" itemLabel="label"
												  itemValue="value" htmlEscape="false"/>
								</form:select>
							</td>
						</tr>
						<tr>
							<td class="tit">货物类型:</td>
							<td>
								<form:select path="erpShipments.enumShipmentsType" class="input-xlarge ">
									<form:option value="" label=""/>
									<form:options items="${fns:getDictList('enum_shipments_type')}" itemLabel="label"
												  itemValue="value" htmlEscape="false"/>
								</form:select>
							</td>
							<td class="tit">发货时间:</td>
							<td>
								<input name="erpShipments.deliveryTime" type="text" readonly="readonly" maxlength="20"
									   class="input-medium Wdate "
									   value="<fmt:formatDate value="${erpShipments.deliveryTime}" pattern="yyyy-MM-dd"/>"
									   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
							</td>
						</tr>
						<tr>
							<td class="tit">入货通知附件:</td>
							<td colspan="3">
								<form:hidden id="noticeFile" path="erpShipments.noticeFile" htmlEscape="false" maxlength="11"
											 class="input-xlarge"/>
								<sys:ckfinder input="noticeFile" type="files" uploadPath="/erp/erpShipments"
											  selectMultiple="true"/>
							</td>
						</tr>
						<tr>
							<td class="tit">备注信息:</td>
							<td colspan="3">
								<form:textarea id="erpShipmentsRemarks" path="erpShipments.remarks" htmlEscape="false" rows="4" maxlength="255"
											   class="input-xxlarge " />
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
								<form:input path="erpShipments.billManifestNo" htmlEscape="false" maxlength="255" class="input-xlarge "/>
							</td>
							<td class="tit">离港时间:</td>
							<td>
								<input name="erpShipments.sendTime" type="text" readonly="readonly" maxlength="20"
									   class="input-medium Wdate "
									   value="<fmt:formatDate value="${erpShipments.sendTime}" pattern="yyyy-MM-dd"/>"
									   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
							</td>
							<td class="tit">预计到达时间:</td>
							<td>
								<input name="erpShipments.preComeTime" type="text" readonly="readonly" maxlength="20"
									   class="input-medium Wdate "
									   value="<fmt:formatDate value="${erpShipments.preComeTime}" pattern="yyyy-MM-dd"/>"
									   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
							</td>
						</tr>
						<tr>
							<td class="tit">报关单附件:</td>
							<td>
								<form:hidden id="billManifestFile" path="erpShipments.billManifestFile" htmlEscape="false" maxlength="11"
											 class="input-xlarge"/>
								<sys:ckfinder input="billManifestFile" type="files" uploadPath="/erp/erpShipments"
											  selectMultiple="true"/>
							</td>
							<td class="tit">提单附件:</td>
							<td>
								<form:hidden id="billLadingFile" path="erpShipments.billLadingFile" htmlEscape="false" maxlength="11"
											 class="input-xlarge"/>
								<sys:ckfinder input="billLadingFile" type="files" uploadPath="/erp/erpShipments"
											  selectMultiple="true"/>
							</td>
							<td class="tit">海运账单附件:</td>
							<td>
								<form:hidden id="priceManifestFile" path="erpShipments.priceManifestFile" htmlEscape="false" maxlength="255"
											 class="input-xlarge"/>
								<sys:ckfinder input="priceManifestFile" type="files" uploadPath="/erp/erpShipments"
											  selectMultiple="true"/>
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
								<input id="erpDockerList{{idx}}_id" name="erpShipments.erpDockerList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="erpDockerList{{idx}}_delFlag" name="erpShipments.erpDockerList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td width="15" style="background-color: {{row.bgColor}};">
								<input type="radio" name="myDockerRadio" data-docker-key="{{row.dockerNo}}-{{row.sealNo}}" class="my-checkbox my-docker-radio"  value="" />
							</td>
							<td>
								<input id="erpDockerList{{idx}}_dockerNo" name="erpShipments.erpDockerList[{{idx}}].dockerNo" type="text" value="{{row.dockerNo}}" maxlength="25" class="input-small my-dockerNo"/>
							</td>
							<td>
								<input id="erpDockerList{{idx}}_sealNo" name="erpShipments.erpDockerList[{{idx}}].sealNo" type="text" value="{{row.sealNo}}" maxlength="25" class="input-small my-sealNo"/>
							</td>
							<%--<td>
								<input id="erpDockerList{{idx}}_parts" name="erpShipments.erpDockerList[{{idx}}].parts" type="text" value="{{row.parts}}" class="input-small "/>
							</td>--%>
							<td>
								<textarea id="erpDockerList{{idx}}_remarks" name="erpShipments.erpDockerList[{{idx}}].remarks" rows="4" maxlength="255" class="input-small ">{{row.remarks}}</textarea>
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
                                    var data = ${fns:toJson(erpRepairOrder.erpShipments.erpDockerList)};
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
							<form:select path="erpExpress.enumExpressCompany" class="input-xlarge ">
								<form:option value="" label=""/>
								<form:options items="${fns:getDictList('enum_express_company')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
							</form:select>
						</td>
						<td class="tit">快递单号:</td>
						<td>
							<form:input path="erpExpress.expressNo" htmlEscape="false" maxlength="25" class="input-xlarge "/>
						</td>
						<td class="tit">快递费:</td>
						<td>
							<form:input path="erpExpress.price" htmlEscape="false" class="input-xlarge "/>
						</td>
						<td class="tit">快递时间:</td>
						<td>
							<input name="erpExpress.expressDate" type="text" readonly="readonly" maxlength="20"
								   class="input-medium Wdate "
								   value="<fmt:formatDate value="${erpExpress.expressDate}" pattern="yyyy-MM-dd"/>"
								   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
						</td>
					</tr>
					<tr>
						<td class="tit">备注信息:</td>
						<td colspan="7">
							<%--${erpRepairOrder.erpExpress.remarks}--%>
							<form:textarea id="erpExpressRemarks" path="erpExpress.remarks" htmlEscape="false" rows="4" maxlength="255"
										   class="input-xxlarge " />
							<sys:ckeditor replace="erpExpressRemarks" uploadPath="/test" height="200"/>
						</td>
					</tr>
				</table>
			</fieldset>
		</c:if>
		<fieldset>
			<legend>
				配件列表
			</legend>
			<div class="control-group">
				<div>
					<table class="table table-striped table-bordered table-condensed">
						<thead>
						<tr>
							<th class="hide"></th>
							<th width="15"></th>
							<th>车架号</th>
							<th>车型</th>
							<th>发动机</th>
							<th>PI</th>
							<th width="10">&nbsp;</th>
						</tr>
						</thead>
						<tbody id="erpVinDTOList">
						</tbody>
						<c:if test="${fns:contains(erpRepairOrder.status,'1,3,5')}">
							<tfoot>
							<tr>
								<td colspan="6"><a href="javascript:"
												   onclick="addRow('#erpVinDTOList', erpVinDTORowIdx, erpVinDTOTpl);erpVinDTORowIdx = erpVinDTORowIdx + 1;"
												   class="btn">新增</a></td>
							</tr>
							</tfoot>
						</c:if>
					</table>
					<script type="text/template" id="erpVinDTOTpl">//<!--
					<tr id="erpVinList{{idx}}">
						<td class="hide">
							<input id="erpVinDTOList{{idx}}_id" name="erpVinDTOList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
							<input id="erpVinDTOList{{idx}}_delFlag" name="erpVinDTOList[{{idx}}].delFlag" type="hidden" value="0"/>
						</td>
						<td width="15">
							<input type="radio" name="myRadio" class="my-checkbox my-vin-radio"  value="" />
						</td>
						<td>
							<div class="input-append">
								<input <c:if test="${fns:contains(erpRepairOrder.status,'1,3,5')}">id="erpVinDTOList{{idx}}_vinNo" </c:if>name="erpVinDTOList[{{idx}}].vinNo" readonly="readonly" type="text" value="{{row.vinNo}}" data-msg-required="" class="input-small">
								<a <c:if test="${fns:contains(erpRepairOrder.status,'1,3,5')}">id="erpVinDTOList{{idx}}Button" </c:if> href="javascript:" class="btn  " style="">&nbsp;<i class="icon-search"></i>&nbsp;</a>&nbsp;&nbsp;
							</div>
							<script type="text/javascript">
								$("#erpVinDTOList{{idx}}Button, #erpVinDTOList{{idx}}_vinNo").click(function(){
									if($("#erpVinDTOList{{idx}}_vinNo").val() != ""){
										top.$.jBox.confirm('更换车架号对应的配件也会更换，确认更换吗？', '系统提示', function (v, h, f) {
											if (v == 'ok') {
												open();
											}
										});
									}else{
										open();
									}


								});
								function open(){
									// 正常打开
									top.$.jBox.open("iframe:/erp/a/tag/treeselect?viewName=view_vin&url="+encodeURIComponent("/autoComplete/treeData?type=1")+"&module=&checked=&extId=&isAll=", "选择车架号", 300, 420, {
										ajaxData:{selectIds: $("#erpVinDTOList{{idx}}_id").val()},buttons:{"确定":"ok", "清除":"clear", "关闭":true}, submit:function(v, h, f){
											if (v=="ok"){
												var tree = h.find("iframe")[0].contentWindow.tree;//h.find("iframe").contents();
												var ids = [], names = [], nodes = [];
												if ("" == "true"){
													nodes = tree.getCheckedNodes(true);
												}else{
													nodes = tree.getSelectedNodes();
												}
												for(var i=0; i<nodes.length; i++) {//
													if (nodes[i].isParent){
														top.$.jBox.tip("不能选择父节点（"+nodes[i].name+"）请重新选择。");
														return false;
													}//
													var flag = false;
													$("#erpVinDTOList tr").each(function(){
														var id = $(this).find("td.hide input:first").val();
														if(nodes[i].id == id){
															flag = true;
															return false;
														}
													});
													if(flag){
														top.$.jBox.tip("已选择（"+nodes[i].name+"）请重新选择。");
														return false;
													}
													ids.push(nodes[i].id);
													names.push(nodes[i].name);//
													break; // 如果为非复选框选择，则返回第一个选择
												}
												//删除之前vinId对应的发货信息
												$("#erpSendItemsList").find("tr").each(function(){
													if($(this).data("vinid") == $("#erpVinDTOList{{idx}}_id").val()){
														$(this).remove();
													}
												});
												$("#erpVinDTOList{{idx}}_id").val(ids.join(",").replace(/u_/ig,""));
												$("#erpVinDTOList{{idx}}_vinNo").val(names.join(","));
												//根据车架号查车型发动机和PI
												$.get("${ctx}/erp/erpRepairOrder/findVinDTOById", { vinId: ids.join(",").replace(/u_/ig,"")},
												  function(data){
												  	$("#erpVinDTOList{{idx}}_erpCarType").val(data.erpCarType.aname);
												  	$("#erpVinDTOList{{idx}}_erpEngineType").val(data.erpEngineType.aname);
												  	$("#erpVinDTOList{{idx}}_pi").val(data.pi);
												  	//根据车型ID和发动机ID查询出所有相关的配件
												  	$.get("${ctx}/erp/erpCarParts/findListByCarIdAndEngineId", { carId : data.erpCarType.id,engineId : data.erpEngineType.id},
												  		function(data){
															var erpSendItemsRowIdx = 0, erpSendItemsTpl = $("#erpSendItemsTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
															if($("#erpSendItemsList").find("tr:last").attr("id") != undefined){
																erpSendItemsRowIdx = parseInt($("#erpSendItemsList").find("tr:last").attr("id").replace('erpSendItemsList',''))+1;
															}
															for (var i=0; i<data.length; i++){
																var row = {erpCarParts:data[i],erpVin:{id:$("#erpVinDTOList{{idx}}_id").val(),vinNo:$("#erpVinDTOList{{idx}}_vinNo").val()}}
																addRow('#erpSendItemsList', erpSendItemsRowIdx, erpSendItemsTpl, row);
																erpSendItemsRowIdx = erpSendItemsRowIdx + 1;
															}
												  	});
												});
											}//
											else if (v=="clear"){
												//删除之前vinId对应的发货信息
												$("#erpSendItemsList").find("tr").each(function(){
													if($(this).data("vinid") == $("#erpVinDTOList{{idx}}_id").val()){
														$(this).remove();
													}
												});
												$("#erpVinDTOList{{idx}}_id").val("");
												$("#erpVinDTOList{{idx}}_vinNo").val("");
												$("#erpVinDTOList{{idx}}_erpCarType").val("");
												$("#erpVinDTOList{{idx}}_erpEngineType").val("");
												$("#erpVinDTOList{{idx}}_pi").val("");

											}//
										}, loaded:function(h){
											$(".jbox-content", top.document).css("overflow-y","hidden");
										}
									});
								}
							</script>
						</td>
						<td>
							<input id="erpVinDTOList{{idx}}_erpCarType" name="erpVinDTOList[{{idx}}].erpCarType.aname" type="text" value="{{row.erpCarType.aname}}" class="input-small" readonly="true"/>
						</td>
						<td>
							<input id="erpVinDTOList{{idx}}_erpEngineType" name="erpVinDTOList[{{idx}}].erpEngineType.aname" type="text" value="{{row.erpEngineType.aname}}" class="input-small" readonly="true"/>
						</td>
						<td>
							<input id="erpVinDTOList{{idx}}_pi" name="erpVinDTOList[{{idx}}].pi" type="text" value="{{row.pi}}" class="input-small " readonly="true"/>
						</td>
						<td class="text-center" width="10">
							<c:if test="${fns:contains(erpRepairOrder.status,'1,3,5')}">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#erpVinDTOList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</c:if>
						</td>
					</tr>//-->
					</script>
					<script type="text/javascript">
						var erpVinDTORowIdx = 0,
                            erpVinDTOTpl = $("#erpVinDTOTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
						$(document).ready(function () {
							var data = ${fns:toJson(erpRepairOrder.erpVinDTOList)};
							for (var i = 0; i < data.length; i++) {
								addRow('#erpVinDTOList', erpVinDTORowIdx, erpVinDTOTpl, data[i]);
                                erpVinDTORowIdx = erpVinDTORowIdx + 1;
							}
						});
					</script>
				</div>
			</div>
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
							<th>车架号</th>
							<th>数量</th>
							<th>备注信息</th>
						</tr>
						</thead>
						<tbody id="erpSendItemsList">
						</tbody>
					</table>
					<script type="text/template" id="erpSendItemsTpl">//<!--
						<tr id="erpSendItemsList{{idx}}" data-vinid="{{row.erpVin.id}}" data-dockerid="{{row.erpDocker.id}}">
							<td class="hide">
								<input id="erpSendItemsList{{idx}}_id" name="erpSendItemsList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
								<input id="erpSendItemsList{{idx}}_delFlag" name="erpSendItemsList[{{idx}}].delFlag" type="hidden" value="0"/>
							</td>
							<td width="15">
							<c:if test="${fns:contains(erpRepairOrder.status,'4,6,8')}">
								{{#row.erpExpress.id}}
									<input type="checkbox" data-status-key="express" data-docker-key="{{row.erpDocker.dockerNo}}-{{row.erpDocker.sealNo}}" class="my-checkbox my-send-checkbox" checked="checked" value=""/>
									<input id="erpSendItemsList{{idx}}_statusKey" name="erpSendItemsList[{{idx}}].statusKey" type="hidden" value="express"/>
								{{/row.erpExpress.id}}
								{{#row.erpDocker.id}}
									<input type="checkbox" data-status-key="shipments" data-docker-key="{{row.erpDocker.dockerNo}}-{{row.erpDocker.sealNo}}" class="my-checkbox hide my-send-checkbox" checked="checked" value=""/>
									<input id="erpSendItemsList{{idx}}_statusKey" name="erpSendItemsList[{{idx}}].statusKey" type="hidden" value="shipments"/>
								{{/row.erpDocker.id}}
								{{^row.erpExpress.id}}
									{{^row.erpDocker.id}}
										<input type="checkbox" data-status-key="" data-docker-key="{{row.erpDocker.dockerNo}}-{{row.erpDocker.sealNo}}" class="my-checkbox my-send-checkbox" value=""/>
										<input id="erpSendItemsList{{idx}}_statusKey" name="erpSendItemsList[{{idx}}].statusKey" type="hidden" value=""/>
									{{/row.erpDocker.id}}
								{{/row.erpExpress.id}}
								<input id="erpSendItemsList{{idx}}_dockerKey" name="erpSendItemsList[{{idx}}].dockerKey" type="hidden" value="{{row.erpDocker.dockerNo}}-{{row.erpDocker.sealNo}}"/>
							</c:if>
							</td>
							<td>
								<input id="erpSendItemsList{{idx}}_erpCarPartsID" name="erpSendItemsList[{{idx}}].erpCarParts.id" type="hidden" value="{{row.erpCarParts.id}}" class="input-small "/>
								{{row.erpCarParts.aname}}
							</td>
							<td>
								{{row.erpVin.vinNo}}
								<input id="erpSendItemsList{{idx}}_erpVinId" name="erpSendItemsList[{{idx}}].erpVin.id" type="hidden" value="{{row.erpVin.id}}" maxlength="64" class="input-small "/>
							</td>
							<td>
								<input id="erpSendItemsList{{idx}}_count" name="erpSendItemsList[{{idx}}].count" type="text" value="{{row.count}}" maxlength="11" class="input-small digits" <c:if test="${fns:contains(erpRepairOrder.status,'4,6,8')}">disabled="true" readonly="true" </c:if>/>
							</td>

							<td>
								<textarea id="erpSendItemsList{{idx}}_remarks" name="erpSendItemsList[{{idx}}].remarks" rows="4" maxlength="255" class="input-small " <c:if test="${fns:contains(erpRepairOrder.status,'4,6,8')}">disabled="true" readonly="true" </c:if>>{{row.remarks}}</textarea>
							</td>
						</tr>//-->
					</script>
					<script type="text/javascript">
                        var erpSendItemsRowIdx = 0, erpSendItemsTpl = $("#erpSendItemsTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
                        $(document).ready(function() {
                            var data = ${fns:toJson(erpRepairOrder.erpSendItemsList)};
                            for (var i=0; i<data.length; i++){
                                addRow('#erpSendItemsList', erpSendItemsRowIdx, erpSendItemsTpl, data[i]);
                                erpSendItemsRowIdx = erpSendItemsRowIdx + 1;
                            }
							color();
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
			<shiro:hasPermission name="erp:erpRepairOrder:save">
				<input id="btnSubmit" class="btn btn-default" type="submit" value="保存草稿"/>
				&nbsp;
			</shiro:hasPermission>
			<c:if test="${erpRepairOrder.act.taskId != null && erpRepairOrder.act.taskId != ''}">
				<shiro:hasPermission name="erp:erpRepairOrder:sendItemForm">
					<input class="btn btn-success" type="submit" value="提交经理审批" onclick="$('#ipt_draft').val(0);"/>&nbsp;
				</shiro:hasPermission>
			</c:if>
			<input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</div>
</body>
</html>