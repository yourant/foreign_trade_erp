<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>集装箱管理</title>
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
		<li><a href="${ctx}/erp/erpDocker/">集装箱列表</a></li>
		<li class="active"><a href="${ctx}/erp/erpDocker/form?id=${erpDocker.id}">集装箱<shiro:hasPermission name="erp:erpDocker:edit">${not empty erpDocker.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission name="erp:erpDocker:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="my-container">
        <form:form id="inputForm" modelAttribute="erpDocker" action="${ctx}/erp/erpDocker/save" method="post" class="form-horizontal">
            <form:hidden path="id"/>
            <sys:message content="${message}"/>
            <div class="control-group">
                <label class="control-label">发货单：</label>
                <div class="controls">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">集装箱号：</label>
                <div class="controls">
                    ${erpDocker.dockerNo}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">铅封号：</label>
                <div class="controls">
                    ${erpDocker.sealNo}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">其余：</label>
                <div class="controls">
                    ${erpDocker.parts}
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">备注信息：</label>
                <div class="controls">
                    <pre>
                    ${erpDocker.remarks}
                    </pre>
                </div>
            </div>
                <div class="control-group">
                    <label class="control-label">车架信息：</label>
                    <div class="controls">
                        <table id="contentTable" class="table table-striped table-bordered table-condensed">
                            <thead>
                                <tr>
                                    <th class="hide"></th>
                                    <th>生产订单明细</th>
                                    <th>车架号</th>
                                    <th>引擎编号</th>
                                    <th>生产人</th>
                                    <th>备注信息</th>
                                    <shiro:hasPermission name="erp:erpDocker:edit"><th width="10">&nbsp;</th></shiro:hasPermission>
                                </tr>
                            </thead>
                            <tbody id="erpVinList">
                            </tbody>
                        </table>
                        <script type="text/template" id="erpVinTpl">//<!--
                            <tr id="erpVinList{{idx}}">
                                <td class="hide">
                                    <input id="erpVinList{{idx}}_id" name="erpVinList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
                                    <input id="erpVinList{{idx}}_delFlag" name="erpVinList[{{idx}}].delFlag" type="hidden" value="0"/>
                                </td>
                                <td>
                                {{row.erpProductionItems.id}}
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
                        <script type="text/javascript">
                            var erpVinRowIdx = 0, erpVinTpl = $("#erpVinTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
                            $(document).ready(function() {
                                var data = ${fns:toJson(erpDocker.erpVinList)};
                                for (var i=0; i<data.length; i++){
                                    addRow('#erpVinList', erpVinRowIdx, erpVinTpl, data[i]);
                                    erpVinRowIdx = erpVinRowIdx + 1;
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