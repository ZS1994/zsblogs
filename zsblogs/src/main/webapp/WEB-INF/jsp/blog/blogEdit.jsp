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
    <title>编辑博客</title>
    <script type="text/javascript">
    var result_hint_num=1;//提示框计数器
    
    $(function(){
    	pullRequest({
    		urlb:"/api/blogList/user/all",
    		type:"get",
    		success:function(data){
    			var str="";
    			for(var i=0;i<data.length;i++){
    				str=str+"<label class='checkbox inline'>"+
    				"<input type='checkbox' name='blIds' value='"+data[i].id+"'>"+data[i].name+"</label>";
    			}
    			$("#blog_list").html(str);
    		}
    	});
    });
    
    function preview(){
    	$("#blog_preview").html($("#blog_content").val());
    }
    
    function save(){
    	var str="<div id='alert_"+result_hint_num+"' class='alert alert-success fade in'>"+
    	"<a class='close' href='#' data-dismiss='alert'>&times;</a>"+
    	"<strong>成功！</strong>保存成功。</div>";
    	$("#result_hint").append(str);
    	var index="alert_"+result_hint_num;
    	setTimeout(function(){
    		$("#"+index).alert('close');
    	},5000);
    	result_hint_num++;
    	
    	var d=formToJson($("#ff"));
    	if(d!=null && d.title!=null && d.content!=null && d.summary!=null &&d.blIds!=null){
    		d.blIds=JSON.stringify(d.blIds);
    		console.log(d.blIds);
    		pullRequest({
    			urlb:"/api/blog",
    			type:"post",
    			data:d,
    			success:function(data){
    				window.location.href="${path}/menu/blogList/blog/one?id="+data;
    			},
    			error:function(code,data){
    				$("#hintDialog_body").html("<strong>错误！</strong>["+code+"]"+data+"。");
    				$("#hintDialog").modal("show");
    			}
    		});
    	}else{
    		$("#hintDialog_body").html("<strong>错误！</strong>标题、正文、摘要、文章分类都不能为空。");
    		$("#hintDialog").modal("show");
    	}
    }
    </script>
    <style type="text/css">
    
    </style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body">
		
		
		<div class="row-fluid" style="margin-top: 30px;margin-bottom: 100px;">
			
			
			<div class="span6">
				
				<div class="container" style="width: 90%;padding-top: 20px;">
					
					<form id="ff">
					
					    <legend>请使用第三方编辑器编写，写完将其拷贝至文本域中</legend>
					    
					    <lable>标题</lable>
					    <input id="blog_title" name="title" type="text" placeholder="请输入标题..." style="width: 100%;height: inherit;" required>
					    
					    <lable>正文</lable>
					    <textarea id="blog_content" name="content" rows="15" style="width: 100%;" required></textarea>
					    <span class="help-block">样式使用的是bootstrap</span>
					    
					    <lable>摘要</lable>
					    <textarea id="blog_summary" name="summary" rows="4" style="width: 100%;" required></textarea>
					    
					    <lable>选择文章分类</lable>
					    <div id="blog_list">
					    </div>
					    
					    <center>
					    	<button class="btn" type="button" onclick="save()">保存</button>
					    	<button class="btn" type="button" onclick="preview()">预览</button>
					    </center>
					    
					    <div id="result_hint" style="margin-top: 10px;">
					    </div>
				    </form>
				    
				    <div id="hintDialog" class="modal hide fade" aria-hidden="true">
						<div class="modal-header">
						    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						    <h3>结果</h3>
						</div>
						<div class="modal-body">
						  <p id="hintDialog_body"></p>
						</div>
						<div class="modal-footer">
						  <button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
						</div>
					</div>
				    
				    
			    </div>
				
			</div>
			<div class="span6" style="border-left: 1px solid #e5e5e5;min-height:1400px;">
			
				<div class="container" style="width: 90%;padding-top: 20px;">
				    <legend>预览博客</legend>
				    
				    <div id="blog_preview"></div>
				    
			    </div>
			
			</div>
		</div>	
  		
  		
  	</div>
  	
  </body>
</html>
