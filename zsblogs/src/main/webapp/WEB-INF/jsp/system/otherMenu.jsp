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
  	<jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <base href="<%=basePath%>">
    <title>其他菜单</title>
    <script type="text/javascript">
    $(function(){
    	initMenuAuto($("#menu"));
    });
  	//追加阅读信息
    function insertMenu(r){
    	var str="";
		for(var i=0;i<r.length;i++){
			var menuName=r[i].name!=null?r[i].name:"<span class=\"muted\">找不到菜单</span>";
			var url=r[i].url!=null?r[i].url:"";
			str=str+
			"<tr>"+
				"<td>"+
					i+
				"</td>"+
				"<td>"+
					"<a href='"+url+"' target='_blank'>"+
					menuName+
					"</a>"+
				"</td>"+
				"<td>"+
					url+
				"</td>"+
			"</tr>";
		}
		$("#menubody").append(str);
    }
  	function doRefresh(){
  		pullRequest({
			urlb:"/api/system/cache/refresh",
			type:"get",
			success:function(data){
				$("#cacheRefreshResult").html("<pre>"+data+"</pre>");
			}
		});
  	}
  	function duQuery(){
  		$("#menubody").html("");
  		pullRequest({
    		urlb:"/api/permission/list",
    		type:"get",
    		data:{
    			int1:$("#menu").val(),
    			str3:"menu",
    			page:1,
    			rows:MAXTOTAL
    		},
    		superSuccess:function(data){
    			console.log(data);
    			var r=data.rows;
    			insertMenu(r);
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
		    
		    <button onclick="doRefresh()" class="btn btn-info" >刷新缓存</button>
  			<div id="cacheRefreshResult"></div>
  			
  			<div style="height: 10px;"></div>
  			
		          菜单：<input type="text" id="menu"/>
		    <button onclick="duQuery()" class="btn btn-info" >搜索</button>
		    
		    <table class="table table-striped">
		    	<thead>
		    		<tr>
		    			<td>序号</td>
		    			<td>菜单</td>
		    			<td>url</td>
		    		</tr>
		    	</thead>
		    	<tbody id="menubody">
		    	</tbody>
		    </table>
		    
	    </div>
  		
  		
  		
  	</div>
  	<jsp:include page="/WEB-INF/jsp/part/bottom_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/right_part.jsp"/>
  </body>
</html>
