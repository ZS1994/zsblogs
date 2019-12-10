<%@page import="com.zs.tools.Constans"%>
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
    <title>博客正文</title>
    <script type="text/javascript">
    var bid=${id};
    var page=1,rows=10,pageSize,total;
    $(function(){
    	//填充博客内容
    	pullRequest({
    		urlb:"/api/blog/one?id="+bid,
    		type:"get",
    		isNeedToken:false,
    		success:function(data){
    			console.log(data);
    			$("#blog_title").html(data.title);
    			//modify begin by 张顺 at 2019-12-10 将用户名改为连接，可跳转至个人页面
    			var strTmp = "<a class='blNameA' href='${path }/menu/system/users/own?id="+data.user.id+"'>"+data.user.name+"</a>&nbsp;&nbsp;&nbsp;&nbsp;"+data.createTime+"&nbsp;&nbsp;&nbsp;&nbsp;<a class='blog_read_a' href='${path}/menu/blogList/blog/read?bId="+bid+"'>"+data.readCount+"次阅读</a>";
    			//modify end by 张顺 at 2019-12-10 将用户名改为连接，可跳转至个人页面
    			//如果是作者就显示编辑按钮
    			if (data.user.id == "<%=Constans.getUserFromReq(request).getId()%>") {
    				strTmp += "&nbsp;&nbsp;&nbsp;&nbsp;<a class='blog_read_a' href='${path}/menu/blogList/blog/user/edit?id="+bid+"'>编辑</a>";
				}
    			$("#blog_author").html(strTmp);
    			$("#blog_summary").html("<strong>摘要:</strong>"+data.summary);
    			$("#blog_list").html("<strong>栏目:</strong>"+data.blogListNames);
    			$("#blog_content").html(data.content);
    			//给table全都加上.table
    			$("table").addClass("table");
    		}
    	});
    	//填充评论内容
    	pullRequest({
    		urlb:"/api/blogComment/list",
    		type:"get",
    		isNeedToken:false,
    		data:{page:page,rows:rows,int1:${id},sort:"createTime",order:"asc"},
    		superSuccess:function(data){
    			//判断是否可以 “显示更多”
    			total=data.total;
    			handleBtnMoreAndSuperMore();
    			//追加评论
    			var r=data.rows;
    			appendBlogComment(r);
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
			$("#btn_super_more").attr("class","btn btn-warning");
		}else{
			$("#btn_more").attr("class","btn btn-info disabled");
			$("#btn_super_more").attr("class","btn btn-warning disabled");
		}
    }
    //追加评论
    function appendBlogComment(r){
    	var str="";
		for(var i=0;i<r.length;i++){
			//modify begin by 张顺 at 2019-12-10 将用户名改为连接，可跳转至个人页面
			var userName=r[i].user!=null?"<a class='blNameA' href='${path }/menu/system/users/own?id="+r[i].user.id+"'>"+r[i].user.name+"</a>":"<span class=\"muted\">游客</span>";
			//modify end by 张顺 at 2019-12-10 将用户名改为连接，可跳转至个人页面
			var autor=r[i].isAutor==1?"（作者）":"";
			var userImg=r[i].user!=null?r[i].user.img:"";
			str=str+
			"<div class='media'>"+
				"<a class=\"pull-left\">"+
					"<img class=\"img-polaroid\" src=\""+userImg+"\" onerror=\"this.src='${path }/framework/image/user/superman_1.png'\" width=\"64\" height=\"64\">"+
				"</a>"+
				"<div class=\"media-body\">"+
					"<div class=\"blog_comment\">"+
						"<h5 class=\"media-heading\">"+userName+autor+"&nbsp;&nbsp;&nbsp;&nbsp;"+r[i].createTime+"&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"badge\">"+(parseInt(i)+1+(page-1)*rows)+"楼</span></h5>"+
						r[i].content+
					"</div>"+
				"</div>"+
			"</div>";
		}
		$("#blog_comment").append(str);
    }
    //发表评论
    function addBlogComment(){
    	var con=$("#edit_content").val();
    	if(con && con.trim().length>0){
			//字数不能超过300
			if (con.length > 500) {
				alert("评论内容不能超过500字");
			}else{
	    		pullRequest({
	    			urlb:"/api/blogComment",
	    			type:"post",
	    			isNeedToken:false,
	    			data:{content:con,bId:${id}},
	    			success:function(data){
	    				window.location.href="${path}/menu/blogList/blog/one?id="+bid;
	    			}
	    		});
			}
    	}else{
    		$('#myModal').modal('show');
    	}
    }
    //显示更多，一次追加一页
    function showMore(){
		page++;    	
    	pullRequest({
    		urlb:"/api/blogComment/list",
    		type:"get",
    		isNeedToken:false,
    		data:{page:page,rows:rows,int1:${id},sort:"createTime",order:"asc"},
    		superSuccess:function(data){
    			//判断是否可以 “显示更多”
    			total=data.total;
    			handleBtnMoreAndSuperMore();
    			//追加评论
    			var r=data.rows;
    			appendBlogComment(r);
    		}
    	});
    }
    //显示超级多，相当于点击了5次“显示更多”
    function showSuperMore(){
    	for(var j=0;j<5;j++){
			var superMoreClass=$("#btn_super_more").attr("class");
    		if(superMoreClass=="btn btn-warning"){
    			page++;  
            	pullRequest({
            		urlb:"/api/blogComment/list",
            		type:"get",
            		isNeedToken:false,
            		async:false,
            		data:{page:page,rows:rows,int1:${id},sort:"createTime",order:"asc"},
            		superSuccess:function(data){
            			//判断是否可以 “显示更多”
            			total=data.total;
            			handleBtnMoreAndSuperMore();
            			//追加评论
            			var r=data.rows;
            			appendBlogComment(r);
            		}
            	});
    		}
    	}
    }
    </script>
    <style type="text/css">
    .blog_comment{
    	min-height: 70px;
    }
    .blog_read_a{
    	font-size: 14px;
    }
    .blog_summary{
    	color: gray;
    }
    .blog_list{
	    padding-bottom:30px;
	    color: gray;
    }
    .blNameA{
    	font-size: 12px;
    	cursor: pointer;
    	color: #08c;
    	text-decoration: none; 
    }
    </style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/top_part.jsp"/>
  	<div class="p_body">
		
		<div class="body_top_jiange"></div>		
  		<div class="container" style="width: 90%;">
		    
		    <div id="blog_title" class="blog_title" style="text-align: center;"></div>
		    
		    <legend id="blog_author" class="blog_introduction" style="text-align: center;"></legend>
			
			<div id="blog_summary" class="blog_summary"></div>
			<div id="blog_list" class="blog_list"></div>
			
			<div id="blog_content" style="margin-bottom: 100px;"></div>	
		    
		    <legend "blog_introduction">最新评论</legend>
		    <div id="blog_comment" style="margin-bottom: 30px;white-space: pre-line;">
		    </div>
		    <center style="margin-bottom: 100px;">
		    	<button id="btn_more" type="button" class="btn btn-info" onclick="showMore()">显示更多</button>
		    	<button id="btn_super_more" type="button" class="btn btn-warning" onclick="showSuperMore()">显示超级多</button>
		    </center>

			<legend "blog_introduction">发表评论</legend>
		    <div style="margin-bottom: 100px;">
		    	<form>
		    		<label>评论内容<span class="muted">(可以使用bootstrap样式哦，但别捣乱，我没有作限制。)</span></label>
		    		<textarea id="edit_content" rows="5" style="width: 100%;" required></textarea>
		    		<button type="button" class="btn btn-primary" onclick="addBlogComment()">提交</button>
		    	</form>
		    </div>
		    
		    <div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-hidden="true">
		    	<div class="modal-header">
		    		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		    		<h3 id="myModalLabel">提示</h3>
		    	</div>
		    	<div class="modal-body">
		    		<p><strong>错误！</strong>评论内容不能为空。</p>
		    	</div>
		    </div>
		    
	    </div>
  		
  		
  		
  	</div>
  	<jsp:include page="/WEB-INF/jsp/part/bottom_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/right_part.jsp"/>
  </body>
</html>
