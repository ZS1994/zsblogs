<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
	<%--原来是准备些赊账模块的，后面发现完全不用，所以就把这个页面改为兽医系统的起始页面了
	2020-5-21 张顺
	而且以后的开发模式准备改为html + 同名js的模式，不再放在一个页面中，这样可使页面文件不至于过大
	--%>
	<base href="<%=basePath%>">
	<title>兽医店账本</title>
	<jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
	<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>

	<style type="text/css">
		.a-link{
			text-decoration: underline;
			color: blue;
			font-size: 16px;
		}
	</style>
	</head>
  
	<body>
		<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
		<jsp:include page="/WEB-INF/jsp/part/top_part.jsp"/>
		<div class="p_body table-body">

			<ol>
				<li>
					<a class="a-link" href="${path}/menu/familyshop/transaction" target="_blank">交易单管理</a>
				</li>
				<li>
					<a class="a-link" href="${path}/menu/familyshop/bill" target="_blank">账单管理</a>
				</li>
				<li>
					<a class="a-link" href="${path}/menu/familyshop/stock" target="_blank">库存管理</a>
				</li>
				<li>
					<a class="a-link" href="${path}/menu/familyshop/goods" target="_blank">货品管理</a>
				</li>
			</ol>
		</div>
		<jsp:include page="/WEB-INF/jsp/part/bottom_part.jsp"/>
		<jsp:include page="/WEB-INF/jsp/part/right_part.jsp"/>
	</body>
</html>
<script src="creditList.js"></script>