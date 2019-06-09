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
    <title>错误码</title>
    <style type="text/css">
    </style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body">
 		<div class="body_top_jiange"></div>	
		<div class="container" style="width:90%;">
			<ol>错误码:
				<li>-1:通用错误码</li>
				<li>0:成功</li>
				<li>1:没有证书</li>
				<li>2:证书超时</li>
				<li>11:密码错误</li>
				<li>12:该用户不存在</li>
				<li>13:输入的用户必要信息不全</li>
				<li>101:没有权限</li>
				<li>102:该用户没有分配角色</li>
				<li>103:该权限不存在</li>
				<li>104:该模块还没有设计权限</li>
			</ol>
	    </div>
  	</div>
  </body>
</html>
