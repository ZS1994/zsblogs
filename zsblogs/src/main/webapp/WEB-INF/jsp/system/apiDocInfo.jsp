<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>api接口文档详情</title>
    <jsp:include page="/WEB-INF/jsp/part/include_bootstrap.jsp"/>
    <script type="text/javascript">
    $(function(){
    	$('#myTab a:first').tab('show');
    	pullRequest({
    		urlb:"/api/apidoc/one",
    		type:"GET",
    		isNeedToken:false,
    		data:{id:${id}},
    		success:function(data){
    			$("#project").html(data.project);
    			$("#flag").html(data.flag);
    			$("#name").html(data.name);
    			$("#method").html(data.method);
    			$("#url").html(data.url);
   				var str="";
    			$.each(data.params,function(index,obj){
    				str=str+"<tr>"+
    				"<td>"+obj.name+"</td>"+
    				"<td>"+obj.type+"</td>"+
    				"<td>"+(obj.ismust==1?"是":"否")+"</td>"+
    				"<td>"+obj.introduce+"</td>"+
    				"<td>"+obj.eg+"</td>"+
    				"</tr>";
    			});
    			$("#param").append(str);
    			$("#returnEg").html(data.returnEg);
    			$("#url").html(data.url);
    			
    			var str2="";
    			$.each(data.params,function(index,obj){
    				str2=str2+"<tr>"+
    				"<td>"+obj.name+"</td>"+
    				"<td><input name='"+obj.name+"' value='"+obj.eg+"' type='text' style='width: 80%;height: inherit;margin-bottom: 0px;'/></td><td><button type=\"button\" class=\"btn\" onclick=\"deleteClumn($(this))\">删除参数</button></td>"+
    				"</tr>";
    			});
    			$("#param_test").append(str2);
    			$("#url_test").val(data.url);
    			$("#method_test").val(data.method);
    			
    		}
    	});
    });
    var isBtn1=true;
    function sendHttpRequest(){
    	if(isBtn1){
	    	$("#btn1").addClass("disabled");
	    	$("#btn1").html("正在请求中，请稍后...");
	    	isBtn1=false;
	    	var arr=formToJson($('#http_body'));
	        var urltmp=$('#url_test').val();
	        var t=$("#method_test").val();
	        var token=$("#token").val();
	        pullRequest({
	        	urlb:"/api/system/apitest",
	        	type:"POST",
	        	isNeedToken:false,
	        	data:{
	       			url:urltmp,
	       			method:t,
	       			token:token,
	       			data:JSON.stringify(arr)
	        	},
	        	success:function(data){
	        		console.log(data);
					$("#result").append("<P>"+data+"</p>");
					$("#btn1").removeClass("disabled");
					$("#btn1").html("发送请求");
					jsontool(data);
					isBtn1=true;
	        	},
	        	error:function(code,da){
	        		alert("错误。\n错误代码："+code+"。\n错误参数："+da);
	        		$("#btn1").removeClass("disabled");
	        		$("#btn1").html("发送请求");
	        		isBtn1=true;
	        	}
	        });
    	}
    }
    function jsontool(str){
    	$("#frame_json").contents().find("#edit").val(str);
    }
	function clearResult(){
    	$("#result").html("");
    }
	function deleteClumn(clu){
		clu.parent().parent().remove();
		
	}
	function addClumn(){
		var str=prompt("请输入name");
		$("#tab").append("<tr><td>"+str+"</td><td><input name='"+str+"' type='text' style='width: 80%;height: inherit;margin-bottom: 0px;'/></td><td><button type=\"button\" class=\"btn\" onclick=\"deleteClumn($(this))\">删除参数</button></td></tr>");
	}
	</script>
	<style type="text/css">
	#method{
		color: #ffa8a8;
	}
	#url{
		margin-left: 10px;
	}
	table thead{
		font-weight: bold;
	}
	#name{
		font-weight: bold;
	}
	</style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/top_part.jsp"/>
  	<div class="p_body">
  			
		<div class="body_top_jiange"></div>	
  		<div class="container" style="width: 90%;">
  			
  			<ul id="myTab" class="nav nav-tabs">
				<li><a href="#info" data-toggle="tab">接口信息展示</a></li>
				<li><a href="#test" data-toggle="tab">接口测试</a></li>
			</ul>
			
			<div class="tab-content">
				<div class="tab-pane fade" id="info">
					<span id="project" class="label label-info"></span>
		  			<span id="flag" class="label label-inverse"></span>
		  			<span id="name"></span>
		  			<div style="height: 4px;"></div>
					<div class="well well-small">
			  			<span id="method"></span>
			  			<span id="url"></span>
					</div>
		  			<table class="table table-bordered">
		  				<thead>
		  					<tr>
		  						<td style="width: 15%">参数</td>
		  						<td style="width: 15%">类型</td>
		  						<td style="width: 15%">是否必须</td>
		  						<td style="width: 15%">介绍</td>
		  						<td style="width: 40%">示例</td>
		  					</tr>
		  				</thead>
		  				<tbody id="param">
		  				</tbody>
		  			</table>
		  		
		  			<span>返回示例</span>
		  			<div id="returnEg" class="well well-small">
		  			</div>
				</div>
				<div class="tab-pane fade" id="test">
					url(完整):<input id="url_test" type="text" class="span4" style="height: inherit;"/>
					请求方式:<input id="method_test" type="text" class="span2" style="height: inherit;"/>
					token:<input type="text" id="token" class="span2" style="height: inherit;"/>
					<button class="btn" type="button" style="margin-bottom: 10px;" onclick="addClumn()">添加参数</button>
					<br>
					<form id="http_body">
						<table id="tab" class="table table-bordered">
							<thead>
								<tr>
									<td>参数(key)</td>
									<td>值(value)</td>
									<td>操作</td>
								</tr>
							</thead>
							<tbody id="param_test">
							</tbody>
						</table>
					</form>
					
					
					<br>
					<button id="btn1" type="button" class="btn" onclick="sendHttpRequest()">发送请求</button>
					<button id="btn2" type="button" class="btn" onclick="clearResult()">清除结果</button>
					<button href="#myModal" role="button" class="btn" data-toggle="modal">json工具</button>
					<span class="help-block">如果发现点击发送请求没有反应，很大可能是请求出错，请按F12看详细错误信息</span>
					<div id="result" class="well well-small" style="margin-top: 4px;">
					
					</div>
					
					
					<div id="myModal" class="modal hide fade modal-lg" tabindex="-1" 
						role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
					  <div class="modal-header">
					    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					    <span id="myModalLabel" style="font-weight: bold;">json工具</span>
					  </div>
					  <div class="modal-body">
					  	<iframe id="frame_json" src="staticView/json_tools/jsonTool1.html" style="width: 100%;height: 100%;border-width: 0px;">
						</iframe>
					  </div>
					  <div class="modal-footer">
					    <button class="btn" type="button" data-dismiss="modal" aria-hidden="true">关闭</button>
					  </div>
					</div>
					
					
					
					
				
				</div>
			</div>
  			
  			
  		</div>
  			
	</div>
  	<jsp:include page="/WEB-INF/jsp/part/bottom_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/right_part.jsp"/>
  </body>
</html>
