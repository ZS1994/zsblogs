<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request
            .getServerPort() + path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <jsp:include page="/WEB-INF/jsp/part/include_bootstrap.jsp"/>
    <base href="<%=basePath%>">
    <title>最新博客</title>
    <script type="text/javascript">
        let page = "${acc.page}", total, rows = "${acc.rows}", pageSize,
            str1 = "${not empty acc.str1 ? acc.str1 : null}",// 模糊查询关键字
            str3 = "${not empty acc.str3 ? acc.str3 : null}",// 多个栏目id，逗号分割
            str4 = "${not empty acc.str4 ? acc.str4 : null}",// 栏目的名称集合，逗号隔开
            str5 = "${not empty acc.str5 ? acc.str5 : null}";// 选中的年份
        let allBlogList = JSON.parse(${blogList});
        let years = JSON.parse(${years});

        // 初始化时执行的内容:
        $(function () {
            // 获取博客，查询所有博客
            getBlogList();
            //填充搜索框内容
            $("#ssTitle").val(str1);
            //初始化栏目筛选
            htmlBlogListFilte();
            // 填充博客栏目
            appendBlogList();
            // 填充年份选择框
            appendYears();
        });

        // 获取博客，查询所有博客
        function getBlogList() {
            let json = {
                page: page,
                rows: rows,
                int1: 0,// 是否能查出影藏博客
                str1: str1,// 模糊查询关键字
                str3: str3, // 多个栏目id，逗号分割
                str5: str5,// 选中的年份
            };
            pullRequest({
                urlb: "/api/blog/list",
                type: "get",
                data: json,
                isNeedToken: false,
                superSuccess: function (data) {
                    //先预防是权限问题
                    if (isJson(data)) {
                        if (data.result) {
                            alert("result：" + data.result + "\ncode：" + data.code + "\ndata：" + data.data);
                        } else {
                            total = data.total;
                            if (total % rows == 0) {
                                pageSize = Math.floor(total / rows);
                            } else {
                                pageSize = Math.floor(total / rows) + 1;
                            }
                            if (page >= pageSize) {
                                $("#page_next").parent().addClass("disabled");
                            } else {
                                $("#page_next").parent().removeClass("disabled");
                            }
                            if (page == 1) {
                                $("#page_last").parent().addClass("disabled");
                            } else {
                                $("#page_last").parent().removeClass("disabled");
                            }
                            appendBlog(data.rows);
                            $("#page_position").html("第" + page + "/" + pageSize + "页");//设置当前第几页了
                        }
                    }
                    // 初始化按栏目搜索的事件监听
                    initBlogListQuery();
                }
            });
        }

        // 初始化栏目筛选
        function htmlBlogListFilte() {
            console.log(str3);
            if (str3) {
                let str3Arr = strToArrBySplit(str3);
                let str4Arr = strToArrBySplit(str4);
                let htmlStr = "";
                for (let i = 0; i < str3Arr.length; i++) {
                    let str3Tmp = arrToStr(arrRemoveItem(str3Arr, str3Arr[i]));
                    let str4Tmp = arrToStr(arrRemoveItem(str4Arr, str4Arr[i]));
                    htmlStr += "<a class=\"blId_tj\" href=\"" + initFirstLink(str1, str3Tmp, str4Tmp, str5) + "\">" +
                        str4Arr[i] +
                        " ×</a>";
                }
                $("#blId_tj").html(htmlStr);
            }
        }

        //填充博客
        function appendBlog(rows) {
            for (let i = 0; i < rows.length; i++) {
                let str = "<div class='blog_block'><h4><a class='blog_title' onclick='gotoBlogMain(" + rows[i].id + ")'>" + rows[i].title + "</a></h4>" +
                    "<p>" + rows[i].summary + "</p>" +
                    //modify begion by 张顺 at 2019-12-10 将用户改为超链接，可以跳转他的详情页面
                    "<div class='blog_introduction'>" + (rows[i].user ? "<a class='blNameA' href='${path }/menu/system/users/own?id=" + rows[i].user.id + "'>" + rows[i].user.name + "</a>" : "[无法找到该用户]") + "&nbsp;&nbsp;&nbsp;&nbsp;" + rows[i].createTime + "&nbsp;&nbsp;&nbsp;&nbsp;" + rows[i].blogListNamesA + "&nbsp;&nbsp;&nbsp;&nbsp;<a class='blog_read_a' href='${path}/menu/blogList/blog/read?bId=" + rows[i].id + "'>" + rows[i].readCount + "次阅读</a></div>" +
                    //modify end by 张顺 at 2019-12-10 将用户改为超链接，可以跳转他的详情页面
                    "</div>";
                $("#blogs").append(str);
            }
        }

        // 填充博客栏目
        function appendBlogList() {
            console.log(allBlogList);
            for (let i = 0; i < allBlogList.length; i++) {
                let str3Tmp = str3 + "," + allBlogList[i].id;
                let str4Tmp = str4 + "," + allBlogList[i].name;
                let str = "<a class=\"blog_list_item_a\" href=\"" + initFirstLink(str1, str3Tmp, str4Tmp, str5) + "\">"
                    + allBlogList[i].name + "</a>";
                $("#allBlogList").append(str);
            }
        }

        // 填充年份筛选
        function appendYears() {
            console.log(years);
            console.log(str5);
            let html = "<option selected value=\"\">--选择年份可筛选--</option>";
            if (str5) {
                html = "<option  value=\"\">--选择年份可筛选--</option>";
            }
            for (let i = 0; i < years.length; i++) {
                let yearItem = years[i];
                if (str5 == yearItem) {
                    html += "<option selected value=\"" + yearItem + "\">" + yearItem + "年</option>";
                } else {
                    html += "<option value=\"" + yearItem + "\">" + yearItem + "年</option>";
                }
            }
            $("#years").append(html);
        }

        // 查看博客详情
        function gotoBlogMain(id) {
            window.location.href = "${path}/menu/blogList/blog/one?id=" + id;
        }

        function lastPage() {
            if ($("#page_last").parent().attr('class') != "disabled") {
                page--;
                window.location.href = initPageLink(page, rows, str1, str3, str4, str5);
            }
        }

        function nextPage() {
            if ($("#page_next").parent().attr('class') != "disabled") {
                page++;
                window.location.href = initPageLink(page, rows, str1, str3, str4, str5);
            }
        }

        // 搜索
        function sousuo() {
            str1 = $("#ssTitle").val().trim();
            window.location.href = initFirstLink(str1, str3, str4, str5);
        }

        // 选择年份
        function selectYear(val) {
            console.log(val);
            window.location.href = initFirstLink(str1, str3, str4, val);
        }

        // 初始化按栏目搜索的事件监听
        function initBlogListQuery() {
            $(".blNameA").each(function (i, el) {
                $(el).click(function () {
                    let str3Tmp = str3 + "," + $(el).attr("id");
                    let str4Tmp = str4 + "," + $(el).html();
                    // 重新格式化一下
                    str3Tmp = arrToStr(strToArrBySplit(str3Tmp));
                    str4Tmp = arrToStr(strToArrBySplit(str4Tmp));
                    window.location.href = initFirstLink(str1, str3Tmp, str4Tmp, str5);
                });
            });
        }

        // 把逗号拼接的字符串转为数组
        function strToArrBySplit(str) {
            let strArr = str.split(",");
            let arrNew = [];
            for (let i = 0; i < strArr.length; i++) {
                let item = strArr[i];
                // 过滤空项
                if (item == '') {
                    continue;
                }
                // 过滤重复项
                if (arrNew.indexOf(item) > -1) {
                    continue;
                }
                arrNew.push(strArr[i]);
            }
            return arrNew;
        }

        // 数组中去掉某一项然后返回新数组出来
        function arrRemoveItem(arr, item) {
            let arrNew = [];
            for (let i = 0; i < arr.length; i++) {
                if (arr[i] == item) {
                    continue;
                }
                arrNew.push(arr[i]);
            }
            return arrNew;
        }

        // 数组转为使用逗号分割的字符串
        function arrToStr(arr) {
            let str = "";
            for (let i = 0; i < arr.length; i++) {
                let item = arr[i];
                if (item == '') {
                    continue;
                }
                str += item + ",";
            }
            // 去掉最后的逗号
            if (str.length > 0) {
                str = str.substr(0, str.length - 1);
            }
            return str;
        }

        /**
         * 组装跳转链接
         * @param str1Tmp 模糊查询关键字
         * @param str3Tmp 多个栏目id，逗号分割
         * @param str4Tmp 栏目的名称集合，逗号隔开
         * @param str5Tmp 选中的年份
         * @returns {string}
         */
        function initFirstLink(str1Tmp, str3Tmp, str4Tmp, str5Tmp) {
            let link = "${path}/menu/blogList/blog?page=" + 1 + "&rows="
                + rows + "&sort=createTime&order=desc&int1=0&str1=" + str1Tmp
                + "&str3=" + str3Tmp
                + "&str4=" + str4Tmp
                + "&str5=" + str5Tmp;
            return link;
        }

        /**
         * 组装分页跳转链接
         * @param pageTmp 页码
         * @param rowsTmp 每页大小
         * @param str1Tmp 模糊查询关键字
         * @param str3Tmp 多个栏目id，逗号分割
         * @param str4Tmp 栏目的名称集合，逗号隔开
         * @param str5Tmp 选中的年份
         * @returns {string}
         */
        function initPageLink(pageTmp, rowsTmp, str1Tmp, str3Tmp, str4Tmp, str5Tmp) {
            let link = "${path}/menu/blogList/blog?page=" + pageTmp
                + "&rows=" + rowsTmp +
                "&sort=createTime&order=desc&int1=0&str1=" + str1Tmp
                + "&str3=" + str3Tmp
                + "&str4=" + str4Tmp
                + "&str5=" + str5Tmp;
            return link;
        }

    </script>
    <style type="text/css">
        .blog_block {
            border: 1px solid #e4e4e4;
            padding: 20px;
            margin-bottom: 10px;
        }

        .blog_title {
            font-size: 18px;
            cursor: pointer;
        }

        a {
            cursor: pointer;
        }

        .blog_read_a {
            font-size: 12px;
        }

        .blNameA {
            font-size: 12px;
            cursor: pointer;
            color: #08c;
            text-decoration: none;
        }

        .blNameA:hover {
            color: #005580;
            text-decoration: underline;
            outline: 0;
        }

        .blId_tj {
            color: #ffffff;
            font-size: 14px;
            background-color: #9f9c9c;
            padding: 2px 5px;
            border-radius: 2px;
        }

        .blId_tj:hover {
            color: #403f3f;
            text-decoration: none;
        }

        .blog_list_item_a {
            font-size: 14px;
        }

        .allBlogList {
            display: flex;
            column-gap: 5px;
            flex-wrap: wrap;
            margin-bottom: 5px;
        }

        .blId_tj_box {
            display: flex;
            column-gap: 5px;
            row-gap: 1px;
            flex-wrap: wrap;
            margin-bottom: 5px;
        }

        .sousuo-box {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            column-gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 3px;
        }
    </style>
</head>

<body>
<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
<jsp:include page="/WEB-INF/jsp/part/top_part.jsp"/>
<div class="p_body">


    <div class="container" style="width:90%;margin-top: 10px; ">

        <div class="sousuo-box">
            <div class="input-append" style="margin-bottom: 0px;">
                <input class="span4" id="ssTitle" type="text" placeholder="请输入标题、作者、摘要、博客栏目搜索..."
                       style="height: inherit;">
                <button class="btn" type="button" onclick="sousuo()" style="margin-top: 1px;">搜索</button>
            </div>
            <%--选择年限--%>
            <select id="years" onchange="selectYear(this.value)">
            </select>
        </div>
        <%--选中的博客栏目--%>
        <div id="blId_tj" class="blId_tj_box"></div>

        <%--该用户所有的博客栏目--%>
        <div id="allBlogList" class="allBlogList">
        </div>

        <div id="blogs">


        </div>

        <div class="row-fluid">
            <div class="span4 offset4">
                <div class="pagination pagination-centered">
                    <ul>
                        <li><a id="page_last" onclick="lastPage()">上一页</a></li>
                        <li><span id="page_position">第1页/2页</span></li>
                        <li><a id="page_next" onclick="nextPage()">下一页</a></li>
                    </ul>
                </div>
            </div>
        </div>


    </div>


</div>
<jsp:include page="/WEB-INF/jsp/part/bottom_part.jsp"/>
<jsp:include page="/WEB-INF/jsp/part/right_part.jsp"/>
</body>
</html>
