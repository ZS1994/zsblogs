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
    	setInterval("refreshHtml();",1000*5);
    });
    function refreshHtml(){
    	pullRequest({
    		urlb:"/api/crawler/info/1",
    		type:"get",
    		success:function(data){
   				var str="";
   				$.each(data.list, function(key, val) {
   					str=str+val.url+"&nbsp;&nbsp;&nbsp;&nbsp;"+val.urlBlogList+"<br>";
   				});
   				$("#list").html(str);
   				$("#isBegin").html(data.isBegin?"true":"false");
   				$("#listSize").html(data.list.length);
   				
   				
   				if (data.isBegin) {//已开启
					$("#btn_begin").attr("disabled","disabled");
					$("#btn_finish").removeAttr("disabled");
				}else{//已关闭
					$("#btn_begin").removeAttr("disabled");
					$("#btn_finish").attr("disabled","disabled");
				}
    		}
    	});
    	pullRequest({
    		urlb:"/api/crawler/info/2",
    		type:"get",
    		success:function(data){
    			$("#isBegin_2").html(data.isBegin?"true":"false");
   				if (data.isBegin) {//已开启
					$("#btn_begin_2").attr("disabled","disabled");
					$("#btn_finish_2").removeAttr("disabled");
				}else{//已关闭
					$("#btn_begin_2").removeAttr("disabled");
					$("#btn_finish_2").attr("disabled","disabled");
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
  	<jsp:include page="/WEB-INF/jsp/part/top_part.jsp"/>
  	<div class="p_body">
		
		<div class="body_top_jiange"></div>	
  		<div class="container" style="width: 90%;">
		    
		    
		    
			<h3>爬虫机器人1号(爬取博客内容)</h3>
	    	
	    	<div class="btn-group">
		    	<button id="btn_begin" class="btn btn-danger span2" onclick="begin('1')">开启</button>
		    	<button id="btn_finish" class="btn btn btn-danger span2" onclick="finish('1')">关闭</button>
		    	<!--<button id="btn_finish" class="btn btn btn-danger span2" onclick="refreshHtml()">刷新</button>  -->
	    	</div>
	    	<br>
	    	<br>
	    	<div>
		    	<h4>目前的参数数值</h4>
		    	<table class="table">
		    		<tr>
						<td style="width: 150px;">list大小</td>
						<td id="listSize"></td>
					</tr>
					<tr>
						<td style="width: 150px;">list</td>
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
		    	<!--<button id="btn_finish_2" class="btn btn btn-danger span2" onclick="refreshHtml()">刷新</button>  -->
	    	</div>
		    <br>
	    	<br>
	    	<div>
		    	<h4>目前的参数数值</h4>
		    	<table class="table">
					<tr>
						<td style="width: 150px;">isBegin</td>
						<td id="isBegin_2"></td>
					</tr>		    		
		    	</table>
	    	</div>
	    	
	    	
	    	
	    	
	    </div>
  		
  		
  		
  	</div>
  	<jsp:include page="/WEB-INF/jsp/part/bottom_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/right_part.jsp"/>
  </body>
</html>
