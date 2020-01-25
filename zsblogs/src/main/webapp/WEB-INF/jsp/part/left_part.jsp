<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<script>
/**
 * @author 张顺
 * @see 2017-9-12，封装访问接口方法，做一些预处理动作，具体页面中只需写自己的业务逻辑相关代码，而不必关心其他东西
 * @param urlb： url后面的部分，不包含项目名。前面补全的是${path},所以后面不要开头要加/
 * @param type： 请求类型，比如：get、post、put、delete，默认get
 * @param async： 是否异步 true、false，默认true
 * @param data： json对象，需要传的参数，默认空json对象
 * @param success 成功时调用的函数,其函数参数为success(data)
 * @param superSuccess 成功时调用的函数,不为空将覆盖sucess，该函数不会做任何预处理
 * @param error 失败时执行的函数，注意并不是网络问题导致的失败，是成功接收，只是result=='error'，其函数参数为error(code,data)
 * @param isNeedToken: 是否需要判断token是否存在，true判断，false不判断，默认true
 * */
function pullRequest(options){
	var urlb,type,async,data,success,error,isNeedToken,superSuccess;
	if(options){
		urlb=options.urlb?options.urlb:"";
		type=options.type?options.type:"get";
		async=typeof(options.async)!="undefined"?options.async:true;
		data=options.data?options.data:{};
		success=options.success?options.success:function(data){};
		superSuccess=options.superSuccess?options.superSuccess:null;
		error=options.error?options.error:null;
		isNeedToken=typeof(options.isNeedToken)!="undefined"?options.isNeedToken:true;
		var url = "${path}"+urlb;
	    var token=getToken();
	    var isNext=false;//是否继续的标志
	    if(isNeedToken){
	    	if(token){
	    		isNext=true;
	    	}else{
	        	alert("token为空，可能需要重新登录。");
	        }
	    }else{
	    	isNext=true;
	    }
	    if(isNext){
	    	$.ajax({
	        	url:url,
	        	type:type,
	        	async:async,
	        	data:data,
	        	dataType: "json",  
	        	beforeSend: function (request) {
	    	        request.setRequestHeader("token", token);
	    	    },
	        	success:function(data){
	        		if(superSuccess){
	        			//add begin 张顺 at 2019-12-8 这里先判断一下是否是错误信息，如果是错误信息的话，那么先弹窗显示错误信息
	        			if(data){
	        				var json;
		        			if(isJson(data)){
		        				json=data;
		        			}else{
		        				json=JSON.parse(data);
		        			}
		        			if(json.result=="error"){
		        				alert(json.data + "\n" + (json.description?json.description:""));
		        			}
	        			}
	        			//add end 张顺 at 2019-12-8 这里先判断一下是否是错误信息，如果是错误信息的话，那么先弹窗显示错误信息
	        			superSuccess(data);
	        		}else{
	        			if(data){
		        			var json;
		        			if(isJson(data)){
		        				json=data;
		        			}else{
		        				json=JSON.parse(data);
		        			}
		        			if(json.result=="success"){
		        				success(json.data);	
		        			}else if(json.result=="error"){
		        				if(error){
		        					error(json.code,json.data);
		        					//张顺，2019-7-20，1，即使成功，如果有信息也要显示出来
		        					if(json.description){
			        					alert(json.description);
		        					}
		        					//张顺，2019-7-20，-1，即使成功，如果有信息也要显示出来
		        				}else{
		        					alert("错误。\n错误代码："+json.code+"。\n错误参数："+json.data+"。\n错误详情："+json.description);
		        				}
		        			}
		        		}else{
		        			alert("返回值为空，可能接口出错，请检查后台错误日志。");
		        		}
	        		}
	        	},
	        	error:function(XMLHttpRequest, textStatus, errorThrown) {
	        		alert("status:"+XMLHttpRequest.status+"\nreadyState:"+XMLHttpRequest.readyState+"\ntextStatus:"+textStatus);
	    	    }
	        });
	    }else{
	    	alert("函数中止，请检查参数设置。");
	    }
	}else{
		alert("错误：参数为空，请检查代码。");
	}
    
}
function logout(){
	removeToken();
	pullRequest({
		urlb:"/api/login/token/clear",
		type:"delete",
		isNeedToken:false,
		success:function(data){
			alert(data);
		}
	});
}

$(function(){
	//初始化菜单展开与否
	var menu=$(".p_left");
	var body=$(".p_body");
	var btn=$("#showBtn");
	var dg=body.find("#dg");
	var isMenuHidden=window.localStorage.getItem("isMenuHidden");
	if (isMenuHidden) {//收缩
		menu.addClass("menu_hidden");//就收缩
		body.addClass("body_full");
		btn.addClass("btn_hidden");
	}
	if(dg){
		try{
			dg.datagrid('resize',{});
		}catch (e) {
		}
	}
});
/* function toggleHidden(){
	var menu=$(".p_left");
	var body=$(".p_body");
	var btn=$("#showBtn");
	var dg=body.find("#dg");
	var isMenuHidden=window.localStorage.getItem("isMenuHidden");
	if(isMenuHidden){//如果是收缩的话
		menu.removeClass("menu_hidden");
		body.removeClass("body_full");
		btn.removeClass("btn_hidden");
		window.localStorage.removeItem("isMenuHidden");
	}else{//展开的话
		menu.addClass("menu_hidden");//就收缩
		body.addClass("body_full");
		btn.addClass("btn_hidden");
		window.localStorage.setItem("isMenuHidden",true);
	}
	if(dg){
		try{
			dg.datagrid('resize',{});
		}catch (e) {
		}
	}
} */
</script>
<style>
.img-circle {
    -webkit-border-radius: 500px;
    -moz-border-radius: 500px;
    border-radius: 500px;
}
img {
    width: auto\9;
    height: auto;
    max-width: 100%;
    vertical-align: middle;
    border: 0;
    -ms-interpolation-mode: bicubic;
}
.show_btn{
	width: 10px;
	height: 50px;
	position: absolute;
	right: -10px;
	top: 50%;
	background: url(${path}/framework/image/menu/向左.png);
}
.btn_hidden{
	background: url(${path}/framework/image/menu/向右.png);
}
</style>  
<div class="p_left">

	<a href="${path }/menu/part">
	<div class="my_logo">
		<div class="my_logo_child1" style="width: 50px;">
			<img class="img-circle" src="<%=path %>/framework/image/zhangshun.png" width="32" height="32" style="margin-left: 9px;" />
		</div>
		<div class="my_logo_child2">
			时光与细节
		</div>
	</div>
	</a>

	<div class="menu_jiange"></div>
	
	<%-- 
	<div class="entry">
		<a href="${path }/menu/blogList/blog/edit">我的简历</a>
	</div>
	--%>
	 
	<a href="${path }/menu/blogList/blog?page=1&rows=10&sort=createTime&order=desc"> 
		<div class="entry">
			最新博客
		</div>
	</a>
	<a href="${path }/menu/user/blogList">
		<div class="entry">
			博客栏目
		</div>
	</a>
	<a href="${path }/menu/user/blog">
		<div class="entry">
			我的博客
		</div>
	</a>
	<a href="${path }/menu/blogList/blog/user/edit">
		<div class="entry">
			写博客
		</div>
	</a>
	<a href="${path }/menu/system/users/own?id=${userMeId }">
		<div class="entry">
			我的信息
		</div>
	</a>


	<a href="${path }/menu/system/users">
		<div class="entry">
			用户管理
		</div>
	</a>
	<a href="${path }/menu/system/role">
		<div class="entry">
			角色管理
		</div>
	</a>
	<a href="${path }/menu/system/permission">
		<div class="entry">
			权限管理
		</div>
	</a>

	<a href="${path }/menu/system/login">
		<div class="entry">
			登录
		</div>
	</a>
	<a onclick="logout()">
	  	<div class="entry">
			登出
		</div>
	</a>
	<%-- <a href="${path }/menu/crawler/manager">
		<div class="entry">
			爬虫管理
		</div>
	</a> --%>
	<a href="${path }/menu/system/timeline">
		<div class="entry">
			操作日志
		</div>
	</a>
	<a href="${path }/menu/system/apidoc">
		<div class="entry">
			api文档管理
		</div>
	</a>
	<a href="${path }/menu/fund/fundInfo">
		<div class="entry">
			基金信息管理
		</div>
	</a>
	<a href="${path }/menu/fund/fundHistory">
		<div class="entry">
			基金历史管理
		</div>
	</a>
	<a href="${path }/menu/fund/fundTrade">
		<div class="entry">
			基金交易管理
		</div>
	</a>
	<a href="${path }/menu/quartz/listJob">
		<div class="entry">
			quartz实验室
		</div>
	</a>
	<a href="${path }/menu/system/otherMenu">
		<div class="entry">
			其他菜单
		</div>
	</a>
	
	<!-- <div id="showBtn" class="show_btn" onclick="toggleHidden()" style="z-index: 999;background-color: #777474;"></div> -->
</div>
