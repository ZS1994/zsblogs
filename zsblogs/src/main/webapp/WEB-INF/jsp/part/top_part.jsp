<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<script type="text/javascript">
jQuery.fn.slideLeftHide = function( speed, callback ) { 
	this.animate({ 
		left:"-200px"
	}, speed, callback ); 
}
jQuery.fn.slideLeftShow = function( speed, callback ) { 
	this.animate({ 
		left:"0"
	}, speed, callback ); 
}
function toggleMenu(){
	var a=$(".nav-small").attr("a");
	if (a) {
		$(".nav-small").slideLeftHide(350,function(){
			$(".nav-modal").hide();
			$(".nav-small").removeAttr("a");
		});
	}else{
		$(".nav-modal").show();
		$(".nav-small").slideLeftShow(350,function(){
			$(".nav-small").attr("a","a");
		});
	}
}
function closeMenu(){
	$(".nav-small").slideLeftHide(350,function(){
		$(".nav-modal").hide();
		$(".nav-small").removeAttr("a");
	});
}
$(function(){
	$(".title-small").html($(document).attr("title"));
});
</script>
<style>
.collapsed {
	position:absolute;
	left:0;
	top:0;
    width: 40px;
    height: 40px;
    background-color: transparent;
    background-image: none;
    border: 1px solid transparent;
    cursor: pointer;
    outline:none;
}
.collapsed:active {
    border: 1px solid transparent;
}
.collapsed .icon-bar {
    display: block;
    width: 22px;
    height: 2px;
    border-radius: 1px;
    background-color: #32D3C3;
}
.collapsed .icon-bar + .icon-bar {
    margin-top: 4px;
}
.title-small{
	color: #32D3C3;
	font-size:18px;
	text-align: center;
	position: relative;
    top: 50%;
    transform: translateY(-50%);
}
.nav-small ul{
	margin-top: 20px;
	list-style:none;
}
.nav-small ul li{
    margin-top: 5px;
}
.nav-small ul li a{
    color: #555353;
    font-size: 16px;
}
</style>
<div class="p_top" style="background-color: #1e1d26;">

	<div class="title-small">
		时光的细节
	</div>

	<button class="collapsed" type="button" onclick="toggleMenu()">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
    </button>
	

</div>
<div class="nav-modal" onclick="closeMenu()">
	
	
	<div class="nav-small">
		<a href="${path }/menu/part">
			<div class="my_logo" style="background-color: rgba(41, 41, 41, 0.37);">
				<div class="my_logo_child1" style="width: 50px;left: 0px;">
					<img class="img-circle" src="<%=path %>/framework/image/zhangshun.png" width="32" height="32" style="margin-left: 4px;" />
				</div>
				<div class="my_logo_child2" style="color: #2d2d2d;">
					时光与细节
				</div>
			</div>
		</a>
		<ul>
			<li>
			    <a href="<%=path%>/menu/blogList/blog?page=1&rows=10&sort=createTime&order=desc">最新博客</a>
			</li>
			<li>
				<a href="<%=path%>/menu/user/blogList">
					博客栏目
				</a>
			</li>
			<li>
				<a href="<%=path%>/menu/user/blog">
					我的博客
				</a>
			</li>
			<li>
				<a href="<%=path%>/menu/blogList/blog/user/edit">
					写博客
				</a>
			</li>
			<li>
				<a href="<%=path%>/menu/system/users/own">
					我的信息
				</a>
			</li>
			<li>
				<a href="${path }/menu/system/users">
					用户管理
				</a>
			</li>
			<li>
				<a href="${path }/menu/system/role">
					角色管理
				</a>
			</li>
			<li>
				<a href="${path }/menu/system/permission">
					权限管理
				</a>
			</li>
			<li>
				<a href="<%=path%>/menu/system/login">
					登录
				</a>
			</li>
			<li>
				<a onclick="logout()">
					登出
				</a>
			</li>
			<li>
				<a href="${path }/menu/crawler/manager">
					爬虫管理
				</a>
			</li>
			<li>
				<a href="${path }/menu/system/timeline">
					操作日志
				</a>
			</li>
			<li>
				<a href="${path }/menu/system/apidoc">
					api文档管理
				</a>
			</li>
			<li>
				<a href="${path }/menu/fund/fundInfo">
					基金信息管理
				</a>
			</li>
			<li>
				<a href="${path }/menu/fund/fundHistory">
					基金历史管理
				</a>
			</li>
			<li>
				<a href="${path }/menu/fund/fundTrade">
					基金交易管理
				</a>
			</li>
			<li>
				<a href="${path }/menu/quartz/listJob">
					quartz实验室
				</a>
			</li>
		</ul>
		
		
		
		
	
	
		
		
		
	
		
		
		
		
		
		
		
		
		
	</div>
</div>
