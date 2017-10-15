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
    <title>博客正文</title>
    <script type="text/javascript">
    var url="<%=path%>/api/blog/${id}";
    
    $(function(){
    	$.ajax({
    		url:url,
    		type:"get",
    		success:function(data){
    			$("#blog_title").html(data.data.title);
    			$("#blog_author").html(data.data.id);
    			$("#blog_content").html(data.data.content);
    			console.log(data);
    		}
    		
    	});
    });
    </script>
    <style type="text/css">
    .blog_block{
    	border: 1px solid #e4e4e4;
    	padding: 20px;
    	margin-bottom: 10px;
    }
    </style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body">
			
  		<div class="container" style="width: 90%;">
		    
		    <h2 id="blog_title"></h2>
		    
		    <div id="blog_author"></div>
			
			<div id="blog_content"></div>	
		    
	    </div>
  		
  	</div>
  	
  </body>
</html>
