<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
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
    var url="<%=path%>/api/blog/list";
    var page=1,total,rows=3,pageSize;
    
    $(function(){
    	$.ajax({
    		url:url,
    		type:"get",
    		data:{page:page,rows:rows},
    		success:function(data){
    			total=data.total;
    			if(total%rows==0){
    				pageSize=Math.floor(total/rows);
    			}else{
    				pageSize=Math.floor(total/rows)+1;
    			}
    			console.log(pageSize);
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
    		
    	});
    });
    function appendBlog(rows){
    	var str;
		for(var i=0;i<rows.length;i++){
			str="<div class='blog_block'><h4><a class='blog_title' onclick='gotoBlogMain("+rows[i].id+")'>"+rows[i].title+"</a></h4>"+
			"<legend class='blog_introduction'>"+new Date(rows[i].createTime).Format("yyyy年MM月dd日 hh:mm:ss")+"</legend>"+
			"<p>"+rows[i].summary+"</p>"+
			"</div>";
			$("#blogs").append(str);
		}
    }
    function gotoBlogMain(id){
    	window.location.href="<%=path%>/menu/blogList/blog/"+id;
    }
    function lastPage(){
    	if($("#page_last").parent().attr('class')!="disabled"){
    		page--;
        	$.ajax({
        		url:url,
        		type:"get",
        		data:{page:page,rows:rows},
        		success:function(data){
        			$("#page_next").parent().removeClass("disabled");//去除下一页禁止
            		$("#blogs").html("");//清空博客
        			appendBlog(data.rows);
        			if(page>=1){
        				$("#page_last").parent().addClass("disabled");
        			}else{
        				$("#page_last").parent().removeClass("disabled");
        			}
        			$("#page_position").html("第"+page+"页，共"+pageSize+"页");//设置当前第几页了
        		}
        	});
    	}
    }
    function nextPage(){
    	if($("#page_next").parent().attr('class')!="disabled"){
    		page++;
        	$.ajax({
        		url:url,
        		type:"get",
        		data:{page:page,rows:rows},
        		success:function(data){
        			$("#page_last").parent().removeClass("disabled");//去除上一页禁止
            		$("#blogs").html("");//清空博客
        			appendBlog(data.rows);
        			if(page>=pageSize){
        				$("#page_next").parent().addClass("disabled");
        			}else{
        				$("#page_next").parent().removeClass("disabled");
        			}
        			$("#page_position").html("第"+page+"页，共"+pageSize+"页");//设置当前第几页了
        		}
        	});
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
