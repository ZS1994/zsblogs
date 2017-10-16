<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<style>
.my_logo{
	border: 0px solid red;
	height: 50px;
	background-color: #1E1D26;
	color:#11e397;
	font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
	font-size:  22px;
	position: relative;
	line-height: 20px;
}
.my_logo_child1{
	position: absolute;
    top: 50%;
    transform: translateY(-50%);
}
.my_logo_child2{
	position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
}
.entry{
	text-align: right;
	padding-right: 10px;
	padding-top: 3px;
	padding-bottom: 3px;
	width: auto;
}
a {
    color: #08c;
    text-decoration: none;
    font-size: 20px;
    line-height: 20px;
    font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
}
</style>  
<div class="p_left">

	<div class="my_logo">
		
		<div class="my_logo_child1" style="width: 35px;margin-left: 10px;">
			<img class="img-circle" src="<%=path %>/framework/image/zhangshun.png" width="32" height="32" style="">
		</div>
		
	
		<div class="my_logo_child2">
			张顺的博客
		</div>
		
		
		
	</div>

	<div style="height: 50px;"></div>

	<div class="entry">
		<a href="<%=path%>/menu/blogList/blog/edit">我的简历</a>
	</div>
	<div class="entry">
		<a href="<%=path%>/menu/blogList/blog?page=1&rows=3">最新博客</a>
	</div>
	<div class="entry">
		<a href="<%=path%>/menu/blogList">博客栏目</a>
	</div>
	<div class="entry">
		<a href="<%=path%>/menu/blogList/blog/edit">写博客</a>
	</div>
	
  	
</div>
