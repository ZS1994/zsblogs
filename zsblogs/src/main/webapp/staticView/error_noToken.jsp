<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<jsp:include page="/WEB-INF/jsp/part/include_bootstrap.jsp"/>
    <base href="<%=basePath%>">
    <title>错误</title>
    <style type="text/css">
    </style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body">
 		<div class="body_top_jiange"></div>	
		<div class="container" style="width:90%;">
			<h1>错误代码：1</h1>
			<p>没有证书，请重新获取。</p>
			<p>您可以<a href="${path }/menu/system/login">登录</a>获取证书，若没有账号，可前往<a href="${path }/menu/system/users/logup">注册</a>。</p>
	    </div>
  	</div>
  </body>
</html>
