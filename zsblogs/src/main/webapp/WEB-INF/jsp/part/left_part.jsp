<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
  
<div class="p_left">

	<ul style="margin-top: 20px;margin-left: 20px;">
		<li>
			<a href="<%=path%>/menu/blogList">博客栏目</a>
		</li>
	</ul>
  	
</div>
