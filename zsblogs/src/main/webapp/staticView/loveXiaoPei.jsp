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
    <title>LoveXiaoPei</title>
    <script type="text/javascript">
    var zs="zs",xp="xp";
    
    var dd,now;
    $(function(){
    	$('#myModal').window('close');
    });
    
    function init(){
    	$.ajax({
    		url:"${path}/api/loveXiaoPei/init",
    		async:false,
    		success:function(data){
    			dd=data;
    			openMessage(data);
    		}
    	});
    }
    function selectById(start,id){
    	if (start.id==id) {
    		now=start;
			return;
		}else{
			if(start.child){
				$.each(start.child,function(i,item){
					selectById(item,id)
				});
			}else{
		    	return;
			}
		}
    }
    
    function next(id){
    	selectById(dd,id);
    	//console.log(now);
    	if(now){
	    	openMessage(now);
    	}
    }
    function last(){
    	$('#myModal').window('open');
    }
    
    function openMessage(option){
    	var isWorkXp=false;
    	setTimeout(function(){
    		//先恢复动画
    		$("#title").html("张顺");
    		//再做别的事
	    	if(option.author=="zs" && (option.child && option.child.length>0 && option.child[0].author=="xp") ){
		    	$("#message-mod").html(option.message);
		    	if(option.child){
		    		var str="";
		    		$.each(option.child,function(i,item){
		    			str=str+"<button class=\"btn\" onclick='next("+item.id+")'>"+item.message+"</button>";
		    		});
		    		$('#xuanxiang').html(str);
		    	}
		    	console.log("------我开启了---------");
		    	$('#myModal').window('open');
	    	}else{
	    		if (option.child && option.child.length>0 && option.child[0].author=="zs") {
	    			isWorkXp=true;
				}
	    		$("#message-mod").html("");
	    		$('#xuanxiang').html("<button class=\"easyui-linkbutton\" iconCls=\"icon-cancel\" onclick=\"javascript:$('#myModal').dialog('close')\">关闭</button>");
	    		console.log("------我关闭了---------");
	    		$('#myModal').window('close');
	    	}
	    	var img="";
	    	if (option.author=="zs") {
	    		img="<img alt=\"张顺\" src=\"${path }/framework/image/love/zs.jpg\" width=\"30\" height=\"30\">"
		    	$("#daPingMu").append("<div class='zhangshun'>"+"&nbsp;"+img+option.message+"</div>");
			}else{
				img="<img alt=\"小佩\" src=\"${path }/framework/image/love/xiaopei.jpg\" width=\"30\" height=\"30\">"
				$("#daPingMu").append("<div class='xiaopei'>"+option.message+"&nbsp;"+img+"</div>");
			}
	    	if (isWorkXp==true) {
	    		next(option.child[0].id);
			}
    	},option.delay);
    	
    	//这里写动画效果
    	if (option.delay!=0) {
			$("#title").html("张顺  对方正在输入 ......");
		}else{
			$("#title").html("张顺");
		}
    	
    	return option.message;
    }
    function sleep(numberMillis) { 
    	var now = new Date(); 
    	var exitTime = now.getTime() + numberMillis; 
    	while (true) { 
    		now = new Date(); 
    		if (now.getTime() > exitTime) 
    		return; 
    	}
   	}
    </script>
    <style type="text/css">
    #title{
    	padding: 5px;
    	background-color: #393A3E;
    	color: white;
    }
    .zhangshun{
    	text-align: left;
    	background-color: white;
    }
    .xiaopei{
    	text-align: right;
    	background-color: #B0DD42;
    }
    </style>
  </head>
  
  <body style="margin: 0px;padding: 0px;">
  	<div style="background-color: #E6F7FF;height: 100%;height: 100%;">
  		<div id="title">
  			张顺
  		</div>
  		<button class="btn" onclick="init()">AnNiu_Init</button>
  		<button class="btn" onclick="next()">AnNiu_Next</button>
  		<button class="btn" onclick="last()">AnNiu_Last</button>
  		<div id="daPingMu" style="width: 100%;height: 80%;overflow-y: scroll;">
  		
  		</div>
  	</div>
  
	
	<div id="xuanxiang">
		<button class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#myModal').dialog('close')">关闭</button>
	</div>
	<div id="myModal" class="easyui-dialog" title="ZS" style="width:80%;height:200px;max-width:800px;padding:10px"
		buttons="#xuanxiang" closable="false" modal="true"
		data-options="
			iconCls:'icon-save',
			onResize:function(){
				$(this).dialog('center');
			}">
		<div id="message-mod"></div>
	</div>
  
  </body>
</html>
