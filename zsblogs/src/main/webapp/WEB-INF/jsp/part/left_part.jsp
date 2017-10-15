<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<style>
.my_logo{
	border: 0px solid red;
	height: 50px;
}
.entry{
	text-align: right;
	padding-right: 10px;
}
a {
    color: #08c;
    text-decoration: none;
    font-size: 14px;
    line-height: 20px;
    font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
}
</style>  
<div class="p_left">

	<div class="my_logo">
		
	</div>

	<div class="entry">
		<a href="<%=path%>/menu/blogList">博客栏目</a>
	</div>
	<div class="entry">
		<a href="<%=path%>/menu/blogList/blog">博客</a>
	</div>
	
  	
</div>
