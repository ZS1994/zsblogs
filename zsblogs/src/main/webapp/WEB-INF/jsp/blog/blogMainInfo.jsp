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
    $(function(){
    	pullRequest({
    		urlb:"/api/blog/${id}",
    		type:"get",
    		isNeedToken:false,
    		success:function(data){
    			console.log(data);
    			$("#blog_title").html(data.title);
    			$("#blog_author").html(new Date(data.createTime).Format("yyyy年MM月dd日 hh:mm:ss"));
    			$("#blog_content").html(data.content);
    		}
    	});
    });
    </script>
    <style type="text/css">
    
    </style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body">
			
  		<div class="container" style="width: 90%;">
		    
		    <h2 id="blog_title" style="margin-top: 30px;text-align: center;"></h2>
		    
		    <legend id="blog_author" class="blog_introduction" style="text-align: center;"></legend>
			
			<div id="blog_content" style="margin-bottom: 100px;"></div>	
		    
	    </div>
  		
  	</div>
  	
  </body>
</html>
