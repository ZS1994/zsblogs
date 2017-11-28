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
			alert(data);
		}
	});
}
</script>
<style>

</style>  
<div class="p_left">

	<a href="${path }/menu/part">
	<div class="my_logo">
		<div class="my_logo_child1" style="width: 50px;">
			<img class="img-circle" src="<%=path %>/framework/image/zhangshun.png" width="32" height="32" style="margin-left: 9px;" />
		</div>
		<div class="my_logo_child2">
			张顺的博客
		</div>
	</div>
	</a>

	<div class="menu_jiange"></div>
	
	<%-- 
	<div class="entry">
		<a href="<%=path%>/menu/blogList/blog/edit">我的简历</a>
	</div>
	--%>
	 
	<a href="<%=path%>/menu/blogList/blog?page=1&rows=10&sort=createTime&order=desc"> 
		<div class="entry">
			最新博客
			<img class="menu_img" alt="" src="${path }/framework/image/menu/1新.png">
		</div>
	</a>
	<a href="<%=path%>/menu/user/blogList">
		<div class="entry">
			博客栏目
			<img class="menu_img" alt="" src="${path }/framework/image/menu/2栏.png">
		</div>
	</a>
	<a href="<%=path%>/menu/user/blog">
		<div class="entry">
			我的博客
			<img class="menu_img" alt="" src="${path }/framework/image/menu/3博.png">
		</div>
	</a>
	<a href="<%=path%>/menu/blogList/blog/user/edit">
		<div class="entry">
			写博客
			<img class="menu_img" alt="" src="${path }/framework/image/menu/4写.png">
		</div>
	</a>
	<a href="<%=path%>/menu/system/users/own">
		<div class="entry">
			我的信息
			<img class="menu_img" alt="" src="${path }/framework/image/menu/5我.png">
		</div>
	</a>


	<a href="${path }/menu/system/users">
		<div class="entry">
			用户管理
			<img class="menu_img" alt="" src="${path }/framework/image/menu/6户.png">
		</div>
	</a>
	<a href="${path }/menu/system/role">
		<div class="entry">
			角色管理
			<img class="menu_img" alt="" src="${path }/framework/image/menu/9角.png">
		</div>
	</a>
	<a href="${path }/menu/system/permission">
		<div class="entry">
			权限管理
			<img class="menu_img" alt="" src="${path }/framework/image/menu/10权.png">
		</div>
	</a>

	<a href="<%=path%>/menu/system/login">
		<div class="entry">
			登录
			<img class="menu_img" alt="" src="${path }/framework/image/menu/11入.png">
		</div>
	</a>
	<a onclick="logout()">
	  	<div class="entry">
			登出
			<img class="menu_img" alt="" src="${path }/framework/image/menu/12出.png">
		</div>
	</a>
	<a href="${path }/menu/crawler/manager">
		<div class="entry">
			爬虫管理
			<img class="menu_img" alt="" src="${path }/framework/image/menu/13爬.png">
		</div>
	</a>
	<a href="${path }/menu/system/timeline">
		<div class="entry">
			操作日志
			<img class="menu_img" alt="" src="${path }/framework/image/menu/14志.png">
		</div>
	</a>
	
</div>
