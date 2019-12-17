/*!
 * 
 * 
 * 通用公共方法
 * @author ThinkGem
 * @version 2014-4-29
 */
$(document).ready(function () {
    try {
        // 链接去掉虚框
        $("a").bind("focus", function () {
            if (this.blur) {
                this.blur()
            }
            ;
        });
        //所有下拉框使用select2
        $("select").select2();
    } catch (e) {
        // blank
    }
});

// 引入js和css文件
function include(id, path, file) {
    if (document.getElementById(id) == null) {
        var files = typeof file == "string" ? [file] : file;
        for (var i = 0; i < files.length; i++) {
            var name = files[i].replace(/^\s|\s$/g, "");
            var att = name.split('.');
            var ext = att[att.length - 1].toLowerCase();
            var isCSS = ext == "css";
            var tag = isCSS ? "link" : "script";
            var attr = isCSS ? " type='text/css' rel='stylesheet' " : " type='text/javascript' ";
            var link = (isCSS ? "href" : "src") + "='" + path + name + "'";
            document.write("<" + tag + (i == 0 ? " id=" + id : "") + attr + link + "></" + tag + ">");
        }
    }
}

// 获取URL地址参数
function getQueryString(name, url) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    if (!url || url == "") {
        url = window.location.search;
    } else {
        url = url.substring(url.indexOf("?"));
    }
    r = url.substr(1).match(reg)
    if (r != null) return unescape(r[2]);
    return null;
}

//获取字典标签
function getDictLabel(data, value, defaultValue) {
    for (var i = 0; i < data.length; i++) {
        var row = data[i];
        if (row.value == value) {
            return row.label;
        }
    }
    return defaultValue;
}

// 打开一个窗体
function windowOpen(url, name, width, height) {
    var top = parseInt((window.screen.height - height) / 2, 10), left = parseInt((window.screen.width - width) / 2, 10),
        options = "location=no,menubar=no,toolbar=no,dependent=yes,minimizable=no,modal=yes,alwaysRaised=yes," +
            "resizable=yes,scrollbars=yes," + "width=" + width + ",height=" + height + ",top=" + top + ",left=" + left;
    window.open(url, name, options);
}

// 恢复提示框显示
function resetTip() {
    top.$.jBox.tip.mess = null;
}

// 关闭提示框
function closeTip() {
    top.$.jBox.closeTip();
}

//显示提示框
function showTip(mess, type, timeout, lazytime) {
    resetTip();
    setTimeout(function () {
        top.$.jBox.tip(mess, (type == undefined || type == '' ? 'info' : type), {
            opacity: 0,
            timeout: timeout == undefined ? 2000 : timeout
        });
    }, lazytime == undefined ? 500 : lazytime);
}

// 显示加载框
function loading(mess) {
    if (mess == undefined || mess == "") {
        mess = "正在提交，请稍等...";
    }
    resetTip();
    top.$.jBox.tip(mess, 'loading', {opacity: 0});
}

// 关闭提示框
function closeLoading() {
    // 恢复提示框显示
    resetTip();
    // 关闭提示框
    closeTip();
}

// 警告对话框
function alertx(mess, closed) {
    top.$.jBox.info(mess, '提示', {
        closed: function () {
            if (typeof closed == 'function') {
                closed();
            }
        }
    });
    top.$('.jbox-body .jbox-icon').css('top', '55px');
}

// 确认对话框
function confirmx(mess, href, closed) {
    top.$.jBox.confirm(mess, '系统提示', function (v, h, f) {
        if (v == 'ok') {
            if (typeof href == 'function') {
                href();
            } else {
                resetTip(); //loading();
                location = href;
            }
        }
    }, {
        buttonsFocus: 1, closed: function () {
            if (typeof closed == 'function') {
                closed();
            }
        }
    });
    top.$('.jbox-body .jbox-icon').css('top', '55px');
    return false;
}

// 提示输入对话框
function promptx(title, lable, href, closed) {
    top.$.jBox("<div class='form-search' style='padding:20px;text-align:center;'>" + lable + "：<input type='text' id='txt' name='txt'/></div>", {
        title: title, submit: function (v, h, f) {
            if (f.txt == '') {
                top.$.jBox.tip("请输入" + lable + "。", 'error');
                return false;
            }
            if (typeof href == 'function') {
                href();
            } else {
                resetTip(); //loading();
                location = href + encodeURIComponent(f.txt);
            }
        }, closed: function () {
            if (typeof closed == 'function') {
                closed();
            }
        }
    });
    return false;
}

// 添加TAB页面
function addTabPage(title, url, closeable, $this, refresh) {
    top.$.fn.jerichoTab.addTab({
        tabFirer: $this,
        title: title,
        closeable: closeable == undefined,
        data: {
            dataType: 'iframe',
            dataLink: url
        }
    }).loadData(refresh != undefined);
}

// cookie操作
function cookie(name, value, options) {
    if (typeof value != 'undefined') { // name and value given, set cookie
        options = options || {};
        if (value === null) {
            value = '';
            options.expires = -1;
        }
        var expires = '';
        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
            var date;
            if (typeof options.expires == 'number') {
                date = new Date();
                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
            } else {
                date = options.expires;
            }
            expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
        }
        var path = options.path ? '; path=' + options.path : '';
        var domain = options.domain ? '; domain=' + options.domain : '';
        var secure = options.secure ? '; secure' : '';
        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else { // only name given, get cookie
        var cookieValue = null;
        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                // Does this cookie string begin with the name we want?
                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
}

// 数值前补零
function pad(num, n) {
    var len = num.toString().length;
    while (len < n) {
        num = "0" + num;
        len++;
    }
    return num;
}

// 转换为日期
function strToDate(date) {
    return new Date(date.replace(/-/g, "/"));
}

// 日期加减
function addDate(date, dadd) {
    date = date.valueOf();
    date = date + dadd * 24 * 60 * 60 * 1000;
    return new Date(date);
}

//截取字符串，区别汉字和英文
function abbr(name, maxLength) {
    if (!maxLength) {
        maxLength = 20;
    }
    if (name == null || name.length < 1) {
        return "";
    }
    var w = 0;//字符串长度，一个汉字长度为2
    var s = 0;//汉字个数
    var p = false;//判断字符串当前循环的前一个字符是否为汉字
    var b = false;//判断字符串当前循环的字符是否为汉字
    var nameSub;
    for (var i = 0; i < name.length; i++) {
        if (i > 1 && b == false) {
            p = false;
        }
        if (i > 1 && b == true) {
            p = true;
        }
        var c = name.charCodeAt(i);
        //单字节加1
        if ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xff9f)) {
            w++;
            b = false;
        } else {
            w += 2;
            s++;
            b = true;
        }
        if (w > maxLength && i <= name.length - 1) {
            if (b == true && p == true) {
                nameSub = name.substring(0, i - 2) + "...";
            }
            if (b == false && p == false) {
                nameSub = name.substring(0, i - 3) + "...";
            }
            if (b == true && p == false) {
                nameSub = name.substring(0, i - 2) + "...";
            }
            if (p == true) {
                nameSub = name.substring(0, i - 2) + "...";
            }
            break;
        }
    }
    if (w <= maxLength) {
        return name;
    }
    return nameSub;
}


function HTMLDecode(text) {
    var temp = document.createElement("div");
    temp.innerHTML = text;
    var output = temp.innerText || temp.textContent;
    temp = null;
    return output;
}

function showDialogByThisDataContent(owner, title) {
    var content = $(owner).data('content');
    top.$.jBox('html:' + content, {
        title: title,
        width: top.$(top.document).innerWidth() * 0.8,
        height: top.$(top.document).innerHeight() * 0.8
    });
    top.$('#jbox-content').css('overflow-y', 'auto');
}
function showDialogByContent(content, title) {
    top.$.jBox('html:' + content, {
        title: title,
        width: top.$(top.document).innerWidth() * 0.8,
        height: top.$(top.document).innerHeight() * 0.8
    });
    top.$('#jbox-content').css('overflow-y', 'auto');
}
function showDialogByIdVal(id, title) {
    top.$.jBox('html:' + $('#' + id).val(), {
        title: title,
        width: top.$(top.document).innerWidth() * 0.8,
        height: top.$(top.document).innerHeight() * 0.8
    });
    top.$('#jbox-content').css('overflow-y', 'auto');
}
function showDialogByUrl(url, title,opener,w,h) {
    top.$.jBox('iframe:' + url, {
        opener:opener,
        title: title,
        top: '50px', /* 窗口离顶部的距离,可以是百分比或像素(如 '100px') */
        width: w || (top.$(top.document).innerWidth() * 0.6),
        height: h || (top.$(top.document).innerHeight() * 0.8),
        closed:function(){
            try{
                top.window.jBox.openerWindows.pop();
            }catch (e){

            }
        }
    });
    top.$('#jbox-content').css('overflow-y', 'hidden');
}

$.jBox.setDefaults({
    id: null, /* 在页面中的唯一id，如果为null则自动生成随机id,一个id只会显示一个jBox */
    top: '20px', /* 窗口离顶部的距离,可以是百分比或像素(如 '100px') */
    border: 5, /* 窗口的外边框像素大小,必须是0以上的整数 */
    opacity: 0.1, /* 窗口隔离层的透明度,如果设置为0,则不显示隔离层 */
    timeout: 0, /* 窗口显示多少毫秒后自动关闭,如果设置为0,则不自动关闭 */
    showType: 'fade', /* 窗口显示的类型,可选值有:show、fade、slide */
    showSpeed: 'fast', /* 窗口显示的速度,可选值有:'slow'、'fast'、表示毫秒的整数 */
    showIcon: true, /* 是否显示窗口标题的图标，true显示，false不显示，或自定义的CSS样式类名（以为图标为背景） */
    showClose: true, /* 是否显示窗口右上角的关闭按钮 */
    draggable: true, /* 是否可以拖动窗口 */
    dragLimit: true, /* 在可以拖动窗口的情况下，是否限制在可视范围 */
    dragClone: false, /* 在可以拖动窗口的情况下，鼠标按下时窗口是否克隆窗口 */
    persistent: true, /* 在显示隔离层的情况下，点击隔离层时，是否坚持窗口不关闭 */
    showScrolling: true, /* 是否显示浏览的滚动条 */
    ajaxData: {}, /* 在窗口内容使用get:或post:前缀标识的情况下，ajax post的数据，例如：{ id: 1 } 或 "id=1" */
    iframeScrolling: 'auto', /* 在窗口内容使用iframe:前缀标识的情况下，iframe的scrolling属性值，可选值有：'auto'、'yes'、'no' */

    title: 'jBox', /* 窗口的标题 */
    width: 350, /* 窗口的宽度，值为'auto'或表示像素的整数 */
    height: 'auto', /* 窗口的高度，值为'auto'或表示像素的整数 */
    bottomText: '关闭窗口前，请注意数据有没有保存。', /* 窗口的按钮左边的内容，当没有按钮时此设置无效 */
    buttons: {'关闭': 'ok'}, /* 窗口的按钮 */
    buttonsFocus: 0, /* 表示第几个按钮为默认按钮，索引从0开始 */
    loaded: function (h) {
    }, /* 窗口加载完成后执行的函数，需要注意的是，如果是ajax或iframe也是要等加载完http请求才算窗口加载完成，
     参数h表示窗口内容的jQuery对象 */
    submit: function (v, h, f) {
        return true;
    },
    /* 点击窗口按钮后的回调函数，返回true时表示关闭窗口，
     参数有三个，v表示所点的按钮的返回值，h表示窗口内容的jQuery对象，f表示窗口内容里的form表单键值 */
    closed: function () {
    } /* 窗口关闭后执行的函数 */
});


jQuery.fn.extend({
    autoComplete: function (url) {
        var self = this;
        $.ajax({
            type: "GET",
            contentType: "application/json",
            url: url,
            dataType: "json",
            success: function (datas) {
                $(self).autocomplete({
                    lookup: datas,
                    onSelect: function (suggestion) {
                        var flag = "-auto-complete";
                        var delName = $(self).attr("name");
                        var name = delName;
                        var idx = delName.indexOf(flag);
                        if (idx != -1) {
                            name = delName.substring(0, idx);
                        }
                        $(':hidden[name="' + name + '"]').remove();
                        $(self).after($(self).clone().attr('name', name).attr('type', 'hidden').val(suggestion.data));
                        $(self).attr("name", name + flag);
                    }
                });
            }
        });
        return this;
    }
});

/**
 * autoComplete("#autocomplete", "${ctx}/crm/erpCountry/getAllList")
 * $('#autocomplete').autoComplete("${ctx}/crm/erpCountry/getAllList");
 * 直接在input text标签 上添加属性即可：<input type="text" data-autocomplate-url="${ctx}/crm/erpCountry/getAllList"/>
 */
(function () {

    $(function () {
        // auto complete应用在那些标签：input:text

        $(':text[data-autocomplete-view]').each(function (i, n) {
            var view = $(this).data('autocomplete-view');
            $(this).autoComplete(ctx + '/autoComplete?viewName=' + view);
        });
    });

})();
