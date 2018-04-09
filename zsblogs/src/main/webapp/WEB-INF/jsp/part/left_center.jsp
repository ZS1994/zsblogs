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
<style>
ol,ul{list-style:none}
.both .navs {
	border:0px solid white;
	width:100%;
	height:100px;
	margin-top:10px;
}
@keyframes LYAnimation {
	0% {
	width:0;
}
100% {
	width:100%;
}
}@keyframes TBAnimation {
	0% {
	height:0;
}
100% {
	height:64px;
}
}@keyframes LYAnimationF {
	0% {
	width:100%;
}
100% {
	width:0;
}
}@keyframes TBAnimationF {
	0% {
	height:64px;
}
100% {
	height:0;
}
}.both .navs ul {
	border-left:0px solid white;
	height:65px;
	margin-top:100px;
}
.both .navs ul li {
	border:2px solid transparent;
	width:auto;
	height:60px;
	line-height:60px;
	padding:0 8px;
	position:relative;
	cursor:pointer;
	color:white;
	transition:color 0.3s;
	margin-top: 40px;
}
.both .navs ul li .liLineTop,.both .navs ul li .liLineBottom {
	animation-name:LYAnimationF;
	animation-duration:0.3s;
	animation-iteration-count:1;
	animation-direction:normal;
	animation-timing-function:linear;
	animation-fill-mode:both;
}
.both .navs ul li .liLineLeft,.both .navs ul li .liLineRight {
	animation-name:TBAnimationF;
	animation-duration:0.3s;
	animation-iteration-count:1;
	animation-direction:normal;
	animation-timing-function:linear;
	animation-fill-mode:both;
}
.both .navs ul li .liLineTop,.both .navs ul li .liLineBottom,.both .navs ul li .liLineLeft,.both .navs ul li .liLineRight {
	display:block;
	background-color:#D2FFFF;
	position:absolute;
}
.both .navs ul li .liLineTop,.both .navs ul li .liLineBottom {
	width:0;
	height:2px;
}
.both .navs ul li .liLineLeft,.both .navs ul li .liLineRight {
	width:2px;
	height:0;
}
.both .navs ul li .liLineTop {
	left:0;
	top:-2px;
}
.both .navs ul li .liLineBottom {
	right:0;
	bottom:-2px;
}
.both .navs ul li .liLineLeft {
	left:-2px;
	bottom:-2px;
}
.both .navs ul li .liLineRight {
	right:-2px;
	top:-2px;
}
.both .navs ul li:hover {
	color:#BE9EDE;
	transition:color 0.3s;
}
.both .navs ul li:hover .liLineTop,.both .navs ul li:hover .liLineBottom {
	animation-name:LYAnimation;
	animation-duration:0.3s;
	animation-iteration-count:1;
	animation-direction:normal;
	animation-timing-function:linear;
	animation-fill-mode:both;
}
.both .navs ul li:hover .liLineLeft,.both .navs ul li:hover .liLineRight {
	animation-name:TBAnimation;
	animation-duration:0.3s;
	animation-iteration-count:1;
	animation-direction:normal;
	animation-timing-function:linear;
	animation-fill-mode:both;
}
</style>
  </head>
  
  <body>
  	<div class="p_body" style="left: 0px;top:0; background-color: #2A2A2A;">
  	
		<div class="body_top_jiange"></div>	
		<div class="container" style="width: 90%;">
		    <div class="hero-unit" style="color: white;background-color: rgba(255, 255, 255, 0.5);padding: 5px 20px;">
			  <h3 style="line-height: 1.5;">你好！</h3>
			  <p>欢迎来到我的领域！这里暂时是一个博客网站，你可以在这里浏览文章、发表评论，当然，如果你想发表博客，那么，你就需要去注册一个账号了，另外，如果你仅仅只是对该网站的系统架构感兴趣，那么也没问题，我愿意分享该网站的源码，该项目托管在github，你可以在上面获取源码，还可以浏览我的开发历程。</p>
			</div>
			
			<center>
				
				<section class="both">
				<div class="navs">
				    <ul style="margin: 0px;">
				        <li>
				            <h1 onclick="window.location.href='https://github.com/ZS1994/zsblogs'">我的GitHub</h1></a>
				            <span class="liLineTop"></span>
				            <span class="liLineBottom"></span>
				            <span class="liLineLeft"></span>
				            <span class="liLineRight"></span>
				        </li>
				        <li>
				            <h1 onclick="window.location.href='${path}/staticView/jianli.htm'">我的简历</h1>
				            <span class="liLineTop"></span>
				            <span class="liLineBottom"></span>
				            <span class="liLineLeft"></span>
				            <span class="liLineRight"></span>
				        </li>
				        <li style="margin-bottom: 100px;">
				            <h1 onclick="window.location.href='${path}/menu/blogList/blog?page=1&rows=10&sort=createTime&order=desc'">开启旅途</h1>
				            <span class="liLineTop"></span>
				            <span class="liLineBottom"></span>
				            <span class="liLineLeft"></span>
				            <span class="liLineRight"></span>
				        </li>
				    </ul>
				</div>
				</section>
				
			</center>
			
			
			
	    </div>
  			
  		
  		
  	</div>
  	
  </body>
</html>
