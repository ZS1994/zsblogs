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
    <title>我的信息</title>
    <script type="text/javascript">
    
    </script>
    <style type="text/css">
    
    </style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body">
		
		<div class="body_top_jiange"></div>	
  		<div class="container" style="width: 90%;">
		    
			<div class='media'>
				<a class="pull-left">
			    	<img class="img-polaroid" src="${user.img }" onerror="this.src='${path }/framework/image/user/superman_1.png'" style="width: 200px;height: 200px;">
			    </a>
			    <div class="media-body">
			    	<legend>${user.name }</legend>
			    	账号：${user.usernum }
			    	<br>
			    	邮箱：${user.mail }
			    	<br>
			    	手机：${user.phone }
			    	<br>
			    	是否被注销：${user.isdelete }
			    	<br>
			    	创建时间：${createTime }
			    	<br>
			    	拥有的角色：${user.roleNames }
			    	
			    </div>
			</div>
		    
		    
	    </div>
  		
  		
  		
  	</div>
  	
  </body>
</html>
