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
    <title>登录</title>
    <script type="text/javascript">
    function login(){
    	var d=formToJson($("#ff"));
    	var rhint=$("#result_hint");
    	if(d.usernum==null || d.userpass==null){
    		var str="<div class='alert alert-error fade in'>"+
        	"<a class='close' href='#' data-dismiss='alert'>&times;</a>"+
        	"<strong>错误！</strong>账号和密码不能为空。</div>";
    		rhint.html(str);
    	}else{
    		var btns=$("#btn_sub");
    		btns.attr("class","btn btn-success disabled");
    		btns.html("登录中...");
    		$.ajax({
    			url:"${path}/api/login/token",
    			type:"post",
    			data:d,
    			success:function(data){
    				if(isJson(data)){
    					if(data.result=="success"){
    						setToken(data.data);
    						window.location.href="${path}";
    					}else{
    						str="<div class='alert alert-error fade in'>"+
    			        	"<a class='close' href='#' data-dismiss='alert'>&times;</a>"+
    			        	"<strong>错误！</strong>"+data.data+"</div>";
    			    		rhint.html(str);
    			    		btns.attr("class","btn btn-success");
    			    		btns.html("登录中");
    					}
    				}else{
    					alert("错误！返回值异常。");
    					
    				}
    			}
    		});
    		
    		
    		
    	}
    	console.log(d);
    	
    }
    </script>
    <style type="text/css">
	.parent {
		width:100%;
		height:100%;
		position: relative;
	}
	.child {
		width:302px;
		position: absolute;
		left: 50%;
		top: 50%;
		transform: translate(-50%, -50%);
	}
    </style>
  </head>
  
  <body>
		
	<div class="parent">
		<div class="child">
			<center>
				<img alt="张顺的个人博客" src="${path }/framework/image/login/logo_zs_transparent.png">
			</center>
			<div style="text-align: center;font-size: 24px;line-height: 2;font-family: 宋体;margin-top: 50px;">
				登录
			</div>
			<div id="result_hint">
			</div>
			<div class="well">
				<form id="ff">
					<label class="control-label" for="num">账号</label>
					<input type="text" id="num" name="usernum" placeholder="请输入账号(一般为邮箱/手机)" style="height: inherit;width: 100%;" required>
					<label class="control-label" for="pass">密码</label>
					<input type="password" id="pass" name="userpass" placeholder="请输入密码" style="height: inherit;width: 100%;" required>
					<div style="height: 10px;"></div>
					<button type="button" id="btn_sub" class="btn btn-success" onclick="login()" style="width: 100%;">登录</button>
				</form>
			</div>
		
			<div class="well" style="text-align: center;">
				没有账号？<a href="${path }/menu/blogList/blog?page=1&rows=10&sort=createTime&order=desc">注册一个</a>
			</div>
		
		</div>
	</div>
		
  </body>
</html>
