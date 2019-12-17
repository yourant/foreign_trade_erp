<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>客户管理</title>
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
    </script>
</head>
<body>
<ul class="nav nav-tabs">
    <li><a href="${ctx}/erp/erpCustomer/">客户列表</a></li>
    <li class="active"><a href="${ctx}/erp/erpCustomer/form?id=${erpCustomer.id}">客户<shiro:hasPermission
            name="erp:erpCustomer:edit">${not empty erpCustomer.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission
            name="erp:erpCustomer:edit">查看</shiro:lacksPermission></a></li>
</ul>
<br/>
<form:form id="inputForm" modelAttribute="erpCustomer" action="${ctx}/erp/erpCustomer/save" method="post"
           class="form-horizontal">
    <form:hidden path="id"/>
    <sys:message content="${message}"/>
    <div class="control-group">
        <label class="control-label">所属员工：</label>
        <div class="controls">
            <shiro:hasPermission name="erp:erpCustomer:belongToUser">
                <sys:treeselect id="user" name="user.id" value="${erpCustomer.user.id}" labelName="user.name"
                                labelValue="${erpCustomer.user.name}"
                                title="用户" url="/sys/office/treeData?type=3" cssClass="input-small"
                                allowClear="true" notAllowSelectParent="true"/>
            </shiro:hasPermission>
            <shiro:lacksPermission name="erp:erpCustomer:belongToUser">
                <input type="hidden" name="user.id" value="${fns:getUser().id}">
                ${fns:getUser().name}
            </shiro:lacksPermission>
                <%--<c:choose>--%>
                <%--<c:when test="${fns:getUser().roleEnames.matches('admin|jl')}">--%>
                <%----%>
                <%--</c:when>--%>
                <%--<c:otherwise>--%>
                <%--</c:otherwise>--%>
                <%--</c:choose>--%>
            </li>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">名称：</label>
        <div class="controls">
            <form:input path="aname" htmlEscape="false" maxlength="25" class="input-xlarge required"/>
            <span class="help-inline"><font color="red">*</font> </span>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">公司：</label>
        <div class="controls">
            <form:input path="company" htmlEscape="false" maxlength="50" class="input-xlarge required"/>
            <span class="help-inline"><font color="red">*</font> </span>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">邮箱：</label>
        <div class="controls">
            <form:input path="email" htmlEscape="false" maxlength="25" class="input-xlarge required email"/>


            <span class="help-inline"><font color="red">*</font> </span>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">电话：</label>
        <div class="controls">
            <form:input path="phone" htmlEscape="false" maxlength="12" class="input-xlarge"/>
                <%--<span class="help-inline"><font color="red">*</font> </span>--%>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">地址：</label>
        <div class="controls">
            <form:input path="address" htmlEscape="false" maxlength="100" class="input-xlarge required"/>
            <span class="help-inline"><font color="red">*</font> </span>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">国家：</label>
        <div class="controls">
            <sys:treeselect id="sysCountry" name="sysCountry.id" value="${erpCustomer.sysCountry.id}"
                            labelName="sysCountry.aname" labelValue="${erpCustomer.sysCountry.aname}"
                            title="国家" url="/autoComplete/treeData?type=3" viewName="view_country"
                            cssClass="required" allowClear="true" notAllowSelectParent="true"/>
            <span class="help-inline"><font color="red">*</font> </span>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">客户来源：</label>
        <div class="controls">
            <form:select path="enmuCustomerSource" class="input-xlarge ">
                <form:options items="${fns:getDictList('enmu_customer_source')}" itemLabel="label" itemValue="value"
                              htmlEscape="false"/>
            </form:select>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">客户类型：</label>
        <div class="controls">
            <form:select path="enmuCustomerType" class="input-xlarge ">
                <form:options items="${fns:getDictList('enmu_customer_type')}" itemLabel="label" itemValue="value"
                              htmlEscape="false"/>
            </form:select>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">备注信息：</label>
        <div class="controls">
            <form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>


        </div>
    </div>
    <div class="form-actions">
        <shiro:hasPermission name="erp:erpCustomer:edit"><input id="btnSubmit" class="btn btn-primary" type="submit"
                                                                value="保 存"/>&nbsp;</shiro:hasPermission>
        <input id="btnCancel" class="btn hide" type="button" value="返 回" onclick="history.go(-1)"/>
    </div>
</form:form>
</body>
</html>