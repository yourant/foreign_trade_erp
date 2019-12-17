<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>查看销售提成</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {
            //$("#name").focus();
            $("#inputForm").validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });
        });

        function showItemsDialog(url,title) {
            showDialogByUrl(url, title, window);
        }



    </script>
</head>
<body>
<ul class="nav nav-tabs my-nav-tabs">
    <li class="active"><a>查看销售提成</a></li>
</ul>
<br/>
<div class="my-container">
    <form:form id="inputForm" modelAttribute="erpSalesOrder" action="${ctx}/erp/erpSalesOrder/save" method="post"
           class="form-horizontal">
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
            <form:select path="enmuTradingType" class="input-xlarge " readonly="true" disabled="true">
                <form:option value="" label=""/>
                <form:options items="${fns:getDictList('enmu_trading_type')}" itemLabel="label" itemValue="value"
                              htmlEscape="false"/>
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
        <label class="control-label">销售提成：</label>
        <div class="controls">
                ${erpSalesOrder.commission}
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">发放月份：</label>
        <div class="controls">
            <fmt:formatDate value="${erpSalesOrder.commissionMonth}" pattern="yyyy-MM" />
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            <a onclick="showItemsDialog('${ctx}/erp/erpSalesOrder/showPayType?id=${erpSalesOrder.id}','查看收款单')">查看收款单</a>
        </label>
        <label class="control-label">
            <a onclick="showItemsDialog('${ctx}/erp/erpShipments/shipmentView?salesOrderId=${erpSalesOrder.id}','查看发货单')">查看发货单</a>
        </label>
    </div>
</form:form>
</div>
</body>
</html>