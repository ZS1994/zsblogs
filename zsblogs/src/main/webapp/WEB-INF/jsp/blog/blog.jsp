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
    <title>所有博客</title>
    <script type="text/javascript">
    var page="${page}",total,rows="${rows}",pageSize;
    $(function(){
    	pullRequest({
    		urlb:"/api/blog/list",
    		type:"get",
    		data:{page:page,rows:rows,int1:1,sort:"createTime",order:"desc"},
    		isNeedToken:false,
    		superSuccess:function(data){
    			//先预防是权限问题
    			if(isJson(data)){
    				if(data.result){
    					alert("result："+data.result+"\ncode："+data.code+"\ndata："+data.data);
    				}else{
    					total=data.total;
    	    			if(total%rows==0){
    	    				pageSize=Math.floor(total/rows);
    	    			}else{
    	    				pageSize=Math.floor(total/rows)+1;
    	    			}
    	    			if(page==pageSize){
    	    				$("#page_next").parent().addClass("disabled");
    	    			}else{
    	    				$("#page_next").parent().removeClass("disabled");
    	    			}
    	    			if(page==1){
    	    				$("#page_last").parent().addClass("disabled");
    	    			}else{
    	    				$("#page_last").parent().removeClass("disabled");
    	    			}
    	    			appendBlog(data.rows);
    	    			$("#page_position").html("第"+page+"页，共"+pageSize+"页");//设置当前第几页了
    				}
    			}
    		}
    	});
    });
    //填充博客
    function appendBlog(rows){
    	var str;
		for(var i=0;i<rows.length;i++){
			str="<div class='blog_block'><h4><a class='blog_title' onclick='gotoBlogMain("+rows[i].id+")'>"+rows[i].title+"</a></h4>"+
			"<p>"+rows[i].summary+"</p>"+
			"<div class='blog_introduction'>"+rows[i].user.name+"&nbsp;&nbsp;&nbsp;&nbsp;"+rows[i].createTime+"&nbsp;&nbsp;&nbsp;&nbsp;"+rows[i].blogListNames+"</div>"+
			"</div>";
			$("#blogs").append(str);
		}
    }
    function gotoBlogMain(id){
    	window.location.href="${path}/menu/blogList/blog/one?id="+id;
    }
    function lastPage(){
    	if($("#page_last").parent().attr('class')!="disabled"){
    		page--;
    		window.location.href="${path}/menu/blogList/blog?page="+page+"&rows="+rows+"&sort=createTime&order=desc&int1=1";
    	}
    }
    function nextPage(){
    	if($("#page_next").parent().attr('class')!="disabled"){
    		page++;
    		window.location.href="${path}/menu/blogList/blog?page="+page+"&rows="+rows+"&sort=createTime&order=desc&int1=1";
    	}
    }
    </script>
    <style type="text/css">
    .blog_block{
    	border: 1px solid #e4e4e4;
    	padding: 20px;
    	margin-bottom: 10px;
    }
    .blog_title{
    	font-size: 18px;
    	cursor: pointer;
    }
    a{
    	cursor: pointer;
    }
    </style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body">
			
  			
  			<div class="container" style="width:90%;margin-top: 10px; ">
			    
				
				<div class="input-append">
				  <input class="span3" id="appendedInputButton" type="text" style="height: inherit;">
				  <button class="btn" type="button">搜索</button>
				</div>
							    
			    <div id="blogs">
			    	
			    	
			    </div>
			    
			    <div class="row-fluid">
			    	<div class="span4 offset4">
			    		<div class="pagination pagination-centered">
						  <ul>
						    <li><a id="page_last" onclick="lastPage()">上一页</a></li>
						    <li><a id="page_next" onclick="nextPage()">下一页</a></li>
						  </ul>
						</div>
			    	</div>
			    	<div class="span4">
			    		<div class="pagination pagination-right">
						  <ul>
						    <li><span id="page_position">第1页，共2页</span></li>
						  </ul>
						</div>
			    		
			    	</div>
			    </div>
			    
			    
			    
		    </div>
  			
  		
  		
  	</div>
  	
  </body>
</html>
