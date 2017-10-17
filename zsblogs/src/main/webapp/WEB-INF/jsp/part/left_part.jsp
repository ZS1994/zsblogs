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
	        	beforeSend: function (request) {
	    	        request.setRequestHeader("token", token);
	    	    },
	        	success:function(data){
	        		if(superSuccess){
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
		        				}else{
		        					alert("错误。\n错误代码："+json.code+"。\n错误参数："+json.data);
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
			console.log(data);
		}
	});
}
</script>
<style>
.my_logo{
	border: 0px solid red;
	height: 50px;
	background-color: #1E1D26;
	color:#11e397;
	font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
	font-size:  22px;
	position: relative;
	line-height: 20px;
}
.my_logo_child1{
	position: absolute;
    top: 50%;
    transform: translateY(-50%);
}
.my_logo_child2{
	position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
}
.entry{
	text-align: right;
	padding-right: 10px;
	padding-top: 3px;
	padding-bottom: 3px;
	width: auto;
}
a {
    color: #08c;
    text-decoration: none;
    font-size: 20px;
    line-height: 20px;
    font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
}
</style>  
<div class="p_left">

	<div class="my_logo">
		
		<%-- <div class="my_logo_child1" style="width: 35px;margin-left: 10px;">
			<img class="img-circle" src="<%=path %>/framework/image/zhangshun.png" width="32" height="32" style="">
		</div>
		
	
		<div class="my_logo_child2">
			张顺的博客
		</div> --%>
		
		
		
	</div>

	<div style="height: 50px;"></div>

	<%-- <div class="entry">
		<a href="<%=path%>/menu/blogList/blog/edit">我的简历</a>
	</div> --%>
	
	
	<div class="entry">
		<a href="<%=path%>/menu/blogList/blog?page=1&rows=3">最新博客</a>
	</div>
	<div class="entry">
		<a href="<%=path%>/menu/blogList">博客栏目</a>
	</div>
	<div class="entry">
		<a href="<%=path%>/menu/blogList/blog/edit">写博客</a>
	</div>
	<div class="entry">
		<a href="<%=path%>/menu/system/login">登录</a>
	</div>
  	<div class="entry">
		<a onclick="logout()">登出</a>
	</div>
	
	
</div>
