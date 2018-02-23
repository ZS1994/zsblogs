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
    <title>爬虫管理</title>
    <script type="text/javascript">
    	
    $(function(){
    	refreshHtml();
    });
    function refreshHtml(){
    	pullRequest({
    		urlb:"/api/crawler/info/1",
    		type:"get",
    		success:function(data){
   				$("#blogSer").html(data.blogSer?"[已加载]":"[未加载]");
   				var str="";
   				$.each(data.list, function(key, val) {
   					str=str+val.url+"&nbsp;&nbsp;&nbsp;&nbsp;"+val.urlBlogList+"<br>";
   				});
   				$("#list").html(str);
   				
   				$("#isBegin").html(data.isBegin?"true":"false");
   				
   				if (data.isBegin) {//已开启
					$("#btn_begin").addClass("disabled");
					$("#btn_finish").removeClass("disabled");
				}else{//已关闭
					$("#btn_begin").removeClass("disabled");
					$("#btn_finish").addClass("disabled");
				}
    		}
    	});
    	pullRequest({
    		urlb:"/api/crawler/info/2",
    		type:"get",
    		success:function(data){
   				if (data.isBegin) {//已开启
					$("#btn_begin_2").addClass("disabled");
					$("#btn_finish_2").removeClass("disabled");
				}else{//已关闭
					$("#btn_begin_2").removeClass("disabled");
					$("#btn_finish_2").addClass("disabled");
				}
    		}
    	});
    }
    function addURL(){
    	pullRequest({
    		urlb:"/api/crawler/addurl",
    		type:"post",
    		data:{url:$("#targetURL").val()},
    		success:function(data){
    			alert(data);
    			refreshHtml();
    		}
    	});
    }
    function begin(no){
    	pullRequest({
    		urlb:"/api/crawler/control",
    		type:"get",
    		data:{isBegin:true,no:no},
    		success:function(data){
    			alert(data);
    			refreshHtml();
    		}
    	});
    }
    function finish(no){
    	pullRequest({
    		urlb:"/api/crawler/control",
    		type:"get",
    		data:{isBegin:false,no:no},
    		success:function(data){
    			alert(data);
    			refreshHtml();
    		}
    	});
    }
    </script>
    <style type="text/css">
    
    </style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body">
		
		<div class="body_top_jiange"></div>	
  		<div class="container" style="width: 90%;">
		    
		    
		    
			<h3>爬虫机器人1号(爬取博客内容)</h3>
	    	
	    	<div class="btn-group">
		    	<button id="btn_begin" class="btn btn-danger span2" onclick="begin('1')">开启</button>
		    	<button id="btn_finish" class="btn btn btn-danger span2" onclick="finish('1')">关闭</button>
		    	<button id="btn_finish" class="btn btn btn-danger span2" onclick="refreshHtml()">刷新</button>
	    	</div>
	    	
	    	
	    	<br>
	    	<br>
	    	
	    	<!-- 
	    	<div class="input-append">
				<input class="span3" id="targetURL" type="text" placeholder="请输入目标URL..." style="height: inherit;">
				<button class="btn" type="button" onclick="addURL()">添加</button>
			</div>
	    	 -->
	    	
	    	<div>
		    	<h4>目前的参数数值</h4>
		    	<table class="table">
					<tr>
						<td>blogSer</td>
						<td id="blogSer"></td>
					</tr>
					<tr>
						<td>list</td>
						<td id="list"></td>
					</tr>
					<tr>
						<td>isBegin</td>
						<td id="isBegin"></td>
					</tr>		    		
		    	</table>
	    	</div>
	    	
		    <h3>爬虫机器人2号(爬取基金信息)</h3>
	    	<div class="btn-group">
		    	<button id="btn_begin_2" class="btn btn-danger span2" onclick="begin('2')">开启</button>
		    	<button id="btn_finish_2" class="btn btn btn-danger span2" onclick="finish('2')">关闭</button>
		    	<button id="btn_finish_2" class="btn btn btn-danger span2" onclick="refreshHtml()">刷新</button>
	    	</div>
		    
	    </div>
  		
  		
  		
  	</div>
  	
  </body>
</html>
