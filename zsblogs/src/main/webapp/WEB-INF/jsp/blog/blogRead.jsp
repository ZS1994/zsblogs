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
    <title>博客阅读信息</title>
    <script type="text/javascript">
    var bId="${bId}",page=1,rows=100,pageSize,total;
    $(function(){
    	pullRequest({
    		urlb:"/api/read/list",
    		type:"get",
    		data:{int1:bId,page:page,rows:rows,sort:"createTime",order:"desc"},
    		superSuccess:function(data){
    			console.log(data);
    			//判断是否可以 “显示更多”
    			total=data.total;
    			handleBtnMoreAndSuperMore();
    			//追加
    			var r=data.rows;
    			appendReadInfo(r);
    		}
    	});
    });
 	//处理“显示更多”和“显示超级多”是否禁用
    function handleBtnMoreAndSuperMore(){
    	if(total%rows==0){
			pageSize=Math.floor(total/rows);
		}else{
			pageSize=Math.floor(total/rows)+1;
		}
		if(page<pageSize){
			$("#btn_more").attr("class","btn btn-info");
		}else{
			$("#btn_more").attr("class","btn btn-info disabled");
		}
    }
  	//追加阅读信息
    function appendReadInfo(r){
    	var str="";
		for(var i=0;i<r.length;i++){
			var userName=r[i].user!=null?r[i].user.name:"<span class=\"muted\">游客</span>";
			var userImg=r[i].user!=null?r[i].user.img:"";
			str=str+
			"<tr>"+
				"<td>"+
				((parseInt(i)+1)+((parseInt(page)-1)*parseInt(rows)))+
				"</td>"+
				"<td>"+
					"<img class=\"img-rounded\" src=\""+userImg+"\" onerror=\"this.src='${path }/framework/image/user/superman_1.png'\" style=\"width:20px;height:20px;\">"+
					userName+
				"</td>"+
				"<td>"+
					new Date(r[i].createTime).Format("yyyy年MM月dd日 hh:mm:ss")+
				"</td>"+
			"</tr>";
		}
		$("#readTableBody").append(str);
    }
  	//显示更多，一次追加一页
    function showMore(){
		page++;    	
    	pullRequest({
    		urlb:"/api/read/list",
    		type:"get",
    		isNeedToken:false,
    		data:{page:page,rows:rows,int1:bId,sort:"createTime",order:"desc"},
    		superSuccess:function(data){
    			//判断是否可以 “显示更多”
    			total=data.total;
    			handleBtnMoreAndSuperMore();
    			//追加评论
    			var r=data.rows;
    			appendReadInfo(r);
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
			
  		<div class="container" style="width: 90%;margin-top: 50px;">
		    
		    <table class="table table-striped">
		    	<thead>
		    		<tr>
		    			<td>序号</td>
		    			<td>用户</td>
		    			<td>时间</td>
		    		</tr>
		    	</thead>
		    	<tbody id="readTableBody">
		    	</tbody>
		    </table>
		    <center style="margin-bottom: 100px;">
		    	<button id="btn_more" type="button" class="btn btn-info" onclick="showMore()">显示更多</button>
		    </center>
		    
	    </div>
  		
  		
  		
  	</div>
  	
  </body>
</html>
