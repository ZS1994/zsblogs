<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <base href="<%=basePath%>">
    <title>小佩走进我的生活</title>
    <script type="text/javascript">
    </script>
    <style type="text/css">
	.button {
		display: inline-block;
		padding: 3px 7px;
		font-size: 12px;
		cursor: pointer;
		text-align: center;   
		text-decoration: none;
		outline: none;
		color: #fff;
		background-color: #4CAF50;
		border: none;
		border-radius: 4px;
		box-shadow: 0 2px #999;
		margin-top: 2px;
		margin-bottom: 2px;
		width: 80%;
		height: 40px;
	}
	
	.button:hover {
		background-color: #3e8e41;
	}
	
	.button:active {
	  background-color: #3e8e41;
	  box-shadow: 0 0px #666;
	  transform: translateY(2px);
	}
	
	.main{
	    text-align: center; /*让div内部文字居中*/
	    border-radius: 20px;
	    width: 80%;
	    height: 30%;
	    margin: auto;
	    position: absolute;
	    top: 0;
	    left: 0;
	    right: 0;
	    bottom: 0;
	}
	
	.title{
		text-align: center;
	    padding: 10px;
	    font-size: 18px;
	    font-weight: bold;
	}
    </style>
  </head>
  
  <body style="margin: 0px;padding: 0px;background-color:#CCECFB;">
  	
  	<div class="title">小佩走进了我的生活</div>
  	
  	<img alt="" src="${path }/framework/image/love/timg.gif" style="width: 100%;">
  	
  	<div class="main" style="margin-bottom: 100px;">
		<p style="font-family: 楷体;color: #fb03ff;">也许这一次就是那早已注定的前缘，不然怎曾有如此的企盼，真想要将你的名字烙在心上，成为我情感的驻足点，小佩，祝你生日快乐！你永远是我的小仙女！哈哈，这段时间我制作了一个小游戏想送给你，希望你能喜欢。</p>  	
	  	<button class="button" onclick="window.location.href='${path}/staticView/loveXiaoPei.jsp'">开始游戏</button>
  	</div>
  	
  </body>
</html>
