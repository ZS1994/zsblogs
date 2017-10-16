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
    <title>编辑博客</title>
    <script type="text/javascript">
    function preview(){
    	$("#blog_preview").html($("#blog_content").val());
    }
    function save(){
    	var str="<div class='alert alert-success fade in'>"+
    	"<a class='close' data-dismiss='alert'>&times;</a>"+
    	"<strong>成功！</strong>保存成功。</div>";
    	$("#result_hint").append(str);
    	//$(".alert").alert();
    	setTimeout(function(){
    		$(".alert").alert('close');
    	},2000);
    }
    </script>
    <style type="text/css">
    
    </style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body">
		
		
		<div class="row-fluid" style="margin-top: 30px;margin-bottom: 100px;">
			
			
			<div class="span6">
				
				<div class="container" style="width: 90%;padding-top: 20px;">
					
				    <legend>请使用第三方编辑器编写，写完将其拷贝至文本域中</legend>
				    
				    <lable>标题</lable>
				    <input id="blog_title" type="text" placeholder="请输入标题..." style="width: 100%;height: inherit;">
				    
				    <lable>正文</lable>
				    <textarea id="blog_content" rows="15" style="width: 100%;"></textarea>
				    
				    <lable>摘要</lable>
				    <textarea id="blog_summary" rows="4" style="width: 100%;"></textarea>
				    
				    
				    <center>
				    	<button class="btn" onclick="save()">保存</button>
				    	<button class="btn" onclick="preview()">预览</button>
				    </center>
				    
				    <div id="result_hint" style="margin-top: 10px;">
				    </div>
				    
			    </div>
				
			</div>
			<div class="span6" style="border-left: 1px solid #999;min-height:600px;">
			
				<div class="container" style="width: 90%;padding-top: 20px;">
				    <legend>预览博客</legend>
				    
				    <div id="blog_preview"></div>
				    
			    </div>
			
			</div>
		</div>	
  		
  		
  	</div>
  	
  </body>
</html>
