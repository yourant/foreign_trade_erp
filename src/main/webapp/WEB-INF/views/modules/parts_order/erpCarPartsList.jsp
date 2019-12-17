<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>配件管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//全选
            $("#all").click(function(){
                if(this.checked) {
                    $("input[name='ids']").prop("checked",true);
                }
                else {
                    $("input[name='ids']").prop("checked",false);
                }
            });
            //单选
            $("input[name='ids']").click(function () {
                isall = $("input[name='ids']").length == $("input[name='ids']:checked").length;
                $('#all').prop('checked', isall);
            });
            //表格样式
            $("#dndTable").children("tr").hover(function () {
                $(this.cells).css('background', '#E4E4E4').eq(0).addClass('showDragHandle');
            }, function () {
                $(this.cells).css('background', '').eq(0).removeClass('showDragHandle');
            }).click(function () {//点击背景变色
                if (window._preCells) $(window._preCells).removeClass('my-text-shadow');
                $(window._preCells = this.cells).addClass('my-text-shadow');
            });
            //重置表单
            $("#btnReset").click(function(){
                $("#searchForm")[0].reset();
            });
			// 添加配件
            $("#addParts").click(function(){
                if($("input[name='ids']:checked").length==0){
                    showTip('最少选择一个配件');
                    return
				}
                var partsIds = "";
                $("input[name='ids']:checked").each(function(i){
                    partsIds += this.value + ",";
                });
                $.get(ctx+"/erp/erpSendItems/addParts",{ partsOrderId:'${partsOrderId}',partsIds: partsIds.substring(0,partsIds.length-1)}, function(data){
					if(data > 0){
                        $("input[name='ids']:checked").prop({disabled: true});
                        try{
                            top.$.jBox.getOpener().location.reload(true);
                        }catch (e){
                        }
                        top.$.jBox.close();
					}
                });
            });
		});
	</script>
</head>
<body>
	<%--<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/erp/erpCarParts/">配件列表</a></li>
		<shiro:hasPermission name="erp:erpCarParts:edit"><li><a href="${ctx}/erp/erpCarParts/form">配件添加</a></li></shiro:hasPermission>
	</ul>--%>
	<form:form id="searchForm" modelAttribute="erpCarParts" action="${ctx}/erp/erpCarParts/partsList" method="post" class="breadcrumb form-search">
		<ul class="ul-form">
			<input type="hidden" name="partsOrderId" value="${partsOrderId}"/>
			<li><label>中文名称：</label>
				<form:input path="aname" htmlEscape="false" maxlength="50" class="input-medium"/>
			</li>
			<li><label>英文名称：</label>
				<form:input path="enName" htmlEscape="false" maxlength="50" class="input-medium"/>
			</li>
			<li><label>车型：</label>
				<sys:treeselect id="erpCarType" name="erpCarType.id" value="${erpCarParts.erpCarType.id}"
								labelName="erpCarType.aname" labelValue="${erpCarParts.erpCarType.aname}"
								title="车型" url="/autoComplete/treeData?type=3" viewName="view_car_type"
								cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li><label>发动机型号：</label>
				<sys:treeselect id="erpEngineType" name="erpEngineType.id" value="${erpCarParts.erpEngineType.id}"
								labelName="erpEngineType.aname" labelValue="${erpCarParts.erpEngineType.aname}"
								title="发动机型号" url="/autoComplete/treeData?type=3" viewName="view_engine_type"
								cssClass="input-small" allowClear="true" notAllowSelectParent="true"/>
			</li>
			<li><label>价格：</label>
				<form:input path="price" htmlEscape="false" class="input-medium"/>
			</li>
			<li><label>更新日期：</label>
				<input name="updateDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${erpCarParts.updateDate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</li>
			<li><label>备注信息：</label>
				<form:input path="remarks" htmlEscape="false" maxlength="255" class="input-medium"/>
			</li>
			<li><label>删除标记：</label>
				<form:select path="delFlag" class="input-medium2">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('del_flag')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li class="btns">
				<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
				<input id="btnReset" class="btn btn-default" type="reset" value="重置"/>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed" style="margin-bottom: 100px">
		<thead>
			<tr>
				<th class="checkbox-width"><input type="checkbox" class="my-checkbox" name="all" id="all"/>全选</th>
				<th>中文名称</th>
				<th>英文名称</th>
				<th>车型</th>
				<th>发动机型号</th>
				<th>配件图片</th>
				<th>价格</th>
				<th>更新时间</th>
				<th>备注信息</th>
			</tr>
		</thead>
		<tbody id="dndTable">
		<c:forEach items="${list}" var="erpCarParts">
			<tr>
				<td>
					<c:if test="${erpCarParts.name == 'true'}">
						<input type="checkbox" class="my-checkbox" name="id" value="${erpCarParts.id}" disabled="disabled" checked="checked"/>
					</c:if>
					<c:if test="${erpCarParts.name != 'true'}">
						<input type="checkbox" class="my-checkbox" name="ids" value="${erpCarParts.id}"/>
					</c:if>
				</td>
				<td>
				<%-- <a href="javascript:showDialogByUrl('${ctx}/erp/erpCarParts/view?id=${erpCarParts.id}','查看详情');" target="_blank"> --%>
				<a href="${ctx}/erp/erpCarParts/view?id=${erpCarParts.id}">
					${erpCarParts.aname}
				</a></td>
				<td>
					${erpCarParts.enName}
				</td>
				<td>
					${erpCarParts.erpCarType.aname}
				</td>
				<td>
					${erpCarParts.erpEngineType.aname}
				</td>
				<td>
					<c:forEach items="${fn:split(erpCarParts.image,'||')}" var="img" varStatus="s">
						<c:if test="${img ne ''}">
							<a href="${img}" target="_blank">图片${s.index + 1}</a>
						</c:if>
					</c:forEach>
				</td>
				<td>
					${fns:getDictLabel(erpCarParts.unit, 'price_unit', '')}${erpCarParts.price}
				</td>
				<td>
					<fmt:formatDate value="${erpCarParts.updateDate}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
					${erpCarParts.remarks}
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="form-actions my-form-actions">
		<input class="btn btn-success" type="submit" value="添加" id="addParts"/>
	</div>
</body>
</html>