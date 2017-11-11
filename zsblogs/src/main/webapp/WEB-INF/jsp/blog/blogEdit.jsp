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
	<link rel="stylesheet" type="text/css" href="${path }/framework/css/blog.css">
    <base href="<%=basePath%>">
    <title>编辑博客</title>
    <script type="text/javascript">
    var result_hint_num=1;//提示框计数器
    var id="${id}";
    $(function(){
    	//获取博客栏目
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
    	//判断是添加还是修改，id为空：添加，否则为修改，修改的话就将其内容填充
    	if(id && id!=null && id!=""){
    		pullRequest({
    			urlb:"/api/blog/one",
    			type:"get",
    			data:{id:id},
    			success:function(data){
    				$("#ff [name='title']").val(data.title);
    				$("#ff [name='content']").val(data.content);
    				$("#ff [name='summary']").val(data.summary);
    				$("#ff [name='ishide'][value='"+data.ishide+"']").attr("checked","checked");
    				var blidss=data.blIds.split(",");
    				for(var i=0;i<blidss.length;i++){
    					$("input[name='blIds'][value='"+blidss[i]+"']").attr("checked", true);;
    				}
    			}
    		});
    	}
    });
    
    function preview(){
    	$("#blog_preview").html($("#blog_content").val());
    }
    
    //保存成功的小特效，不足一提
    function saveSuccHint(){
    	var str="<div id='alert_"+result_hint_num+"' class='alert alert-success fade in'>"+
    	"<a class='close' href='#' data-dismiss='alert'>&times;</a>"+
    	"<strong>成功！</strong>保存成功。</div>";
    	$("#result_hint").append(str);
    	var index="alert_"+result_hint_num;
    	setTimeout(function(){
    		$("#"+index).alert('close');
    	},5000);
    	result_hint_num++;
    }
    
    function save(){
    	var d=formToJson($("#ff"));
    	//为空检查
    	if(d!=null && d.title!=null && d.content!=null && d.summary!=null && d.blIds!=null && d.ishide){
    		/*字数检查
    		标题：100个字符
    		正文：500000个字符
    		摘要：600个字符
    		*/
    		console.log(d.title.length);
    		console.log(d.content.length);
    		console.log(d.summary.length);
    		if(d.title.length<=100 && d.content.length<=500000 && d.summary.length<=600){
    			saveSuccHint();
    			d.blIds=JSON.stringify(d.blIds);
        		if(id && id!=""){//修改
        			d.id=id;
        			d._method="put";
        			pullRequest({
            			urlb:"/api/blog",
            			type:"post",
            			data:d,
            			success:function(data){
            				window.location.href="${path}/menu/blogList/blog/one?id="+id;
            			},
            			error:function(code,data){
            				$("#hintDialog_body").html("<strong>错误！</strong>["+code+"]"+data+"。");
            				$("#hintDialog").modal("show");
            			}
            		});
        		}else{//添加
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
        		}
    			
    		}else{
    			$("#hintDialog_body").html("<strong>错误！</strong>字数超过限制。<br><br>以下是字数最大限制：<ul><li>标题：100个字符</li><li>正文：500000个字符</li><li>摘要：600个字符。</li></ul><span class=\"muted\">注意：1个汉字=2个字符</span>");
        		$("#hintDialog").modal("show");
    		}
    	}else{
    		$("#hintDialog_body").html("<strong>错误！</strong>标题、正文、摘要、文章分类、是否公开都不能为空。<br><span class='muted'>如果你是因为文章分类为空而无法选择导致，那么，请你先去创建一个文章分类再来写博客，提醒一下，文章分类也叫博客栏目。<span>");
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
		
		<div class="body_top_jiange"></div>	
		<div class="row-fluid" style="margin-bottom: 100px;">
			
			
			<div class="span6">
				
				<div class="container" style="width: 90%;padding-top: 0px;">
					
					<form id="ff">
					
					    <legend>请使用第三方编辑器编写，写完将其拷贝至文本域中</legend>
					    
					    <lable>标题<span class="muted">（最大字数限制：100个字符）</span></lable>
					    <input id="blog_title" name="title" type="text" placeholder="请输入标题..." style="width: 100%;height: inherit;" required>
					    
					    <lable>正文<span class="muted">（最大字数限制：500000个字符）</span></lable>
					    <textarea id="blog_content" name="content" rows="15" style="width: 100%;" required></textarea>
					    <span class="help-block">样式使用的是bootstrap</span>
					    
					    <lable>摘要<span class="muted">（最大字数限制：600个字符）</span></lable>
					    <textarea id="blog_summary" name="summary" rows="4" style="width: 100%;" required></textarea>
					    
					    <lable>选择文章分类</lable>
					    <div id="blog_list">
					    </div>
					    
					    <lable>是否公开</lable>
					    <div id="blog_ishide">
							<label class="radio inline">
								<input type="radio" name="ishide" id="optionsRadios1" value="1"/>
								私有
							</label>
							<label class="radio inline">
								<input type="radio" name="ishide" id="optionsRadios2" value="0" checked="checked"/>
								公开
							</label>
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
			
				<div class="container" style="width: 90%;padding-top: 0px;">
				    <legend>预览博客</legend>
				    
				    <div id="blog_preview"></div>
				    
			    </div>
			
			</div>
		</div>	
  		
  		
  	</div>
  	
  </body>
</html>
