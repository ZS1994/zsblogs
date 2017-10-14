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
    <title>中间部分（测试组件是否正常）</title>
    <script type="text/javascript">
    var url="<%=path%>/api/blog/list";
    var page=1,total,rows=10,pageSize;
    
    $(function(){
    	$.ajax({
    		url:url,
    		type:"get",
    		data:{page:page,rows:rows},
    		success:function(data){
    			total=data.total;
    			if(total%rows==0){
    				pageSize=total/rows;
    			}else{
    				pageSize=total/rows+1;
    			}
    			if(page>=pageSize){
    				$("#page_next").parent().addClass("disabled");
    			}else{
    				$("#page_next").parent().removeClass("disabled");
    			}
    			if(page>=1){
    				$("#page_last").parent().addClass("disabled");
    			}else{
    				$("#page_last").parent().removeClass("disabled");
    			}
    			appendBlog(data.rows);
    		}
    		
    	});
    });
    function appendBlog(rows){
    	var str;
		for(var i=0;i<rows.length;i++){
			str="<div class='blog_block'><h4>"+rows[i].title+"</h4>"+
			"<p>"+rows[i].context+"</p></div>";
			console.log(str);
			$("#blogs").append(str);
		}
    }
    function lastPage(){
    	if($("#page_last").parent().attr('class')!="disabled"){
    		page--;
    		$("#page_next").parent().removeClass("disabled");//去除下一页禁止
    		$("#blogs").html("");//清空博客
    		if(page>=1){
				$("#page_last").parent().addClass("disabled");
			}else{
				$("#page_last").parent().removeClass("disabled");
			}
        	$.ajax({
        		url:url,
        		type:"get",
        		data:{page:page,rows:rows},
        		success:function(data){
        			total=data.total;
        			appendBlog(data.rows);
        		}
        	});
    	}
    }
    function nextPage(){
    	if($("#page_next").parent().attr('class')!="disabled"){
    		page++;
    		$("#page_last").parent().removeClass("disabled");//去除上一页禁止
    		$("#blogs").html("");//清空博客
        	$.ajax({
        		url:url,
        		type:"get",
        		data:{page:page,rows:rows},
        		success:function(data){
        			total=data.total;
        			if(total%rows==0){
        				pageSize=total/rows;
        			}else{
        				pageSize=total/rows+1;
        			}
        			if(page>=pageSize){
        				$("#page_next").parent().addClass("disabled");
        			}else{
        				$("#page_next").parent().removeClass("disabled");
        			}
        			appendBlog(data.rows);
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
    </style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body">
  		<jsp:include page="/WEB-INF/jsp/part/right_part.jsp"/>
  		
  		
  		
  		<div class="p_body_body">
  			
  			<div class="container" style="padding-top: 50px;">
			    
			    
			    <div id="blogs">
			    	
			    	
			    </div>
			    
			    <div class="pagination pagination-centered">
				  <ul>
				    <li><a id="page_last" onclick="lastPage()">上一页</a></li>
				    <li><a id="page_next" onclick="nextPage()">下一页</a></li>
				  </ul>
				</div>
			    
			    
		    </div>
  			
  		</div>
  		
  		
  	</div>
  	
  </body>
</html>
