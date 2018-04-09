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
    <title>我的信息</title>
    <script type="text/javascript">
    $(function(){
    	$("img[name='uimg']").click(function(){
    		$("img[name='uimg']").removeClass("selected");
			$(this).addClass("selected");
    	});
    	
    });
    function selectUserImg(){
    	var path=$("img.img-polaroid.uimg.selected").attr("src");
    	console.log(path);
    	if (path) {
			pullRequest({
				urlb:"/api/users",
				type:"POST",
				data:{_method:"PUT",id:${user.id},img:path},
				success:function(data){
					document.location.reload();
				}
			});
		}
    }
    </script>
    <style type="text/css">
    .selected{
    	border-color: red;
    	border-width: 2px;
    	width: 148px;
    	height: 148px;
    }
    .uimg{
    	cursor: pointer;
    	margin-bottom: 3px;
    }
    </style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/top_part.jsp"/>
  	<div class="p_body">
		
		<div class="body_top_jiange"></div>	
  		<div class="container" style="width: 90%;">
		    
			<div class='media'>
				<a class="pull-left">
			    	<img class="img-polaroid" src="${user.img }" onerror="this.src='${path }/framework/image/user/superman_1.png'" style="width: 200px;height: 200px;"/>
			    	<br>
			    	<button href="#myModal" role="button" class="btn" data-toggle="modal" style="width: 210px;margin-top: 5px;"><i class="icon-pencil"> </i>更换头像</button>
			    </a>
			    <div class="media-body">
			    	<legend>${user.name }${user.id }</legend>
			    	账号：${user.usernum }
			    	<br>
			    	邮箱：${user.mail }
			    	<br>
			    	手机：${user.phone }
			    	<br>
			    	是否被注销：${user.isdelete }
			    	<br>
			    	创建时间：${createTime }
			    	<br>
			    	拥有的角色：${user.roleNames }
			    	
			    </div>
			</div>
		    
		    
		    
			<!-- Modal -->
			<div id="myModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			  <div class="modal-header">
			    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			    <span id="myModalLabel" style="font-weight: bold;">选择头像</span>
			  </div>
			  <div class="modal-body">
			  	<img name="uimg" src="${path }/framework/image/user/superman_1.png" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/001.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/002.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/003.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/004.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/005.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/006.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/007.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/008.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/009.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/010.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/011.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/012.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/013.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/014.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/016.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/017.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/018.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  	<img name="uimg" src="${path }/framework/image/user/019.jpg" class="img-polaroid uimg" width="150" height="150"/>
			  </div>
			  <div class="modal-footer">
			    <button class="btn" type="button" data-dismiss="modal" aria-hidden="true">关闭</button>
			    <button class="btn btn-primary" type="button" onclick="selectUserImg()">提交</button>
			  </div>
			</div>
		    
	    </div>
  		
  		
  		
  	</div>
  	<jsp:include page="/WEB-INF/jsp/part/bottom_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/right_part.jsp"/>
  </body>
</html>
