<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
  <head>
  	<jsp:include page="/WEB-INF/jsp/part/include_bootstrap.jsp"/>
    <base href="<%=basePath%>">
    <title>首页</title>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body">
  	
		<div class="body_top_jiange"></div>	
		<div class="container" style="width: 90%;">
		    <div class="hero-unit">
			  <h2 style="line-height: 1.5;">你好！</h2>
			  <p>欢迎来到我的领域！这里暂时是一个博客网站，你可以在这里浏览文章、发表评论，当然，如果你想发表博客，那么，你就需要去注册一个账号了，另外，如果你仅仅只是对该网站的系统架构感兴趣，那么也没问题，我愿意分享该网站的源码，该项目托管在github，你可以在上面获取源码，还可以浏览我的开发历程。</p>
			  <p>
			    <a class="btn btn-primary btn-large" href="https://github.com/ZS1994/zsblogs">
			      	前往github
			    </a>
			  </p>
			</div>
	    </div>
  			
  		
  		
  	</div>
  	
  </body>
</html>
