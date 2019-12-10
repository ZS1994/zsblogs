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
    var uId="${id}",page=1,rows=100,pageSize,total;
    var relaId = "";
    $(function(){
    	//首先查一下该用户的信息
    	pullRequest({
    		urlb:"/api/users/one",
    		type:"get",
    		data:{id:"${id}"},
    		superSuccess:function(data){
    			console.log(data);
    			//将信息填充到展示页面
    			var str = "";
    			var userTmp = data.data;
    			str += "ID:" + userTmp.id + "<br>";
    			str += "账号：" + userTmp.usernum + "<br>";
    			str += "邮箱：" + userTmp.mail + "<br>";
    			str += "手机：" + userTmp.phone + "<br>";
    			str += "是否被注销：" + userTmp.isdelete + "<br>";
    			str += "创建时间：" + userTmp.createTime + "<br>";
    			str += "拥有的角色：" + userTmp.roleNames + "<br>";
    			$("#theUserInfo").html(str);
    			//用户名字
    			$("#userName").html(userTmp.name);
    			//用户头像
    			$("#userImg").attr("src",userTmp.img);
    		}
    	});
    	
    	
    	//绑定图片点击事件
    	$("img[name='uimg']").click(function(){
    		$("img[name='uimg']").removeClass("selected");
			$(this).addClass("selected");
    	});
    	//默认显示第一个tab页
    	$('#myTab a:first').tab('show');
    	//第一次先查一次关注的人
    	pullRequest({
    		urlb:"/api/usersRela/list",
    		type:"get",
    		data:{int1:uId,page:page,rows:rows,sort:"createTime",order:"desc"},
    		superSuccess:function(data){
    			//判断是否可以 “显示更多”
    			total=data.total;
    			handleBtnMoreAndSuperMore();
    			//追加
    			var r=data.rows;
    			appendReadInfo(r);
    		}
    	});
    	//判断按钮【关注】是否显示,如果该用户的id就是本人id，那么就不显示
		pullRequest({
    		urlb:"/api/usersRela/list",
    		type:"get",
    		data:{int1:"${userMeId }",page:1,rows:99999},
    		superSuccess:function(data){
    			var isFlow = "0";
    			if (data && data.rows){
    				for (var i = 0; i < data.rows.length; i++) {
						var flower = data.rows[i];
    					//如果登陆者的关注列表中存在受访者的id，那么就说明已经关注过他了
						if (flower.flowerId == $("#uIdTmp").val()){
							isFlow = "1";
							//如果找到是关注过了TA，那么就把你们之间的关系id存起来
							relaId = flower.id;
							break;
						}
					}
    			}
    			//另外如果受访者和登录这是同一个人，那么也代表关注过了,另外，如果是同一个人，那么久显示更换头像的按钮，否则不显示
    			if("${userMeId }" == $("#uIdTmp").val()){
    				isFlow = "2";
    				$("#btn_changeImg").show();
    	    	}else {
    	    		$("#btn_changeImg").hide();
				}
    			//如果关注了，那么就显示取消关注，否则就显示关注
    			if (isFlow == "1") {//关注了
    	    		$("#btn_flower").hide();
    	    		$("#btn_unflower").show();
				}else if(isFlow == "0"){//没关注
					$("#btn_flower").show();
    	    		$("#btn_unflower").hide();
				}else if(isFlow == "2"){//是本人
					$("#btn_flower").hide();
    	    		$("#btn_unflower").hide();
				}
    		}
    	});
    	
    });
    function selectUserImg(){
    	var path=$("img.img-polaroid.uimg.selected").attr("src");
    	if (path) {
			pullRequest({
				urlb:"/api/users",
				type:"POST",
				data:{_method:"PUT",id:uId,img:path},
				success:function(data){
					document.location.reload();
				}
			});
		}
    }
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
			var userName=r[i].flowerName!=null?r[i].flowerName:"<span class=\"muted\">游客</span>";
			var userImg=r[i].userImg!=null?r[i].userImg:"";
			str=str+
			"<tr>"+
				"<td>"+
				((parseInt(i)+1)+((parseInt(page)-1)*parseInt(rows)))+
				"</td>"+
				"<td>"+
					"<a href='javascript:void(0);' onclick='gotoTheUser("+r[i].flowerId+")'>"+
					"<img class=\"uimg_2\" src=\""+userImg+"\" onerror=\"this.src='${path }/framework/image/user/superman_1.png'\">"+
					userName+
					"</a>"+
				"</td>"+
				"<td>"+
					new Date(r[i].createTime).Format("yyyy年MM月dd日 hh:mm:ss")+
				"</td>"+
			"</tr>";
		}
		$("#flowerBody").append(str);
    }
    //显示更多，一次追加一页
    function showMore(){
		page++;    	
    	pullRequest({
    		urlb:"/api/usersRela/list",
    		type:"get",
    		isNeedToken:false,
    		data:{int1:uId,page:page,rows:rows,sort:"createTime",order:"desc"},
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
    //关注该用户
    function flowTheUser(){
    	//受访者用户的id
    	var theUIdTmp = $("#uIdTmp").val();
    	//先影藏按钮，防止多次点击
    	$("#btn_flower").hide();
    	pullRequest({
    		urlb:"/api/usersRela",
    		type:"post",
    		isNeedToken:true,
    		data:{flowerId:theUIdTmp},
    		superSuccess:function(data){
    			if(data && data.result == "success"){
    				alert("关注成功");
    				//立刻刷新一次页面
    				location.reload();
    			}
    		}
    	});
    }
    //取消关注该用户
    function unflowTheUser(){
    	//与受访者之间的关系ID
    	if (relaId == "") {
			alert("数据仍在加载中，请稍后再试");
			return false;
		}
    	//先影藏按钮，防止多次点击
    	$("#btn_unflower").hide();
    	pullRequest({
    		urlb:"/api/usersRela/one?id=" + relaId,
    		type:"delete",
    		isNeedToken:true,
    		superSuccess:function(data){
    			if (data && data.result == "success"){
    				alert("已取消关注");
    				//立刻刷新一次页面
    				location.reload();
    			}
    		}
    	});
    }
    //访问该用户theUserId是该用户的id 
    function gotoTheUser(theUserId){
    	var url = "${path }/menu/system/users/own?id=" + theUserId;
    	window.location.href = url;
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
    .uimg_2{
		width: 30px;
		height: 30px;
		margin-right: 4px;
    }
    </style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/top_part.jsp"/>
  	<div class="p_body">
		
		<div class="body_top_jiange"></div>	
  		<div class="container" style="width: 90%;">
  			<!-- 受访者的id-->
		    <input type="hidden" id="uIdTmp" value="${id }"/>
			<div class='media'>
				<a class="pull-left">
			    	<img class="img-polaroid" id="userImg" onerror="this.src='${path }/framework/image/user/superman_1.png'" style="width: 200px;height: 200px;"/>
			    	<br>
			    	<button id="btn_changeImg" href="#myModal" role="button" class="btn" data-toggle="modal" style="width: 210px;margin-top: 5px;display: none;"><i class="icon-pencil"> </i>更换头像</button>
			    </a>
			    <div class="media-body">
			    	<legend>
			    		<span id="userName"></span>
			    		&nbsp;&nbsp;
			    		<button id="btn_flower" type="button" class="btn btn-small btn-danger" style="display: none;" onclick="flowTheUser()">关注</button>
			    		<button id="btn_unflower" type="button" class="btn btn-small btn-danger" style="display: none;" onclick="unflowTheUser()">取消关注</button>
		    		</legend>
		    		<div id="theUserInfo">
				    	ID:
				    	<br>
				    	账号：
				    	<br>
				    	邮箱：
				    	<br>
				    	手机：
				    	<br>
				    	是否被注销：
				    	<br>
				    	创建时间：
				    	<br>
				    	拥有的角色：
		    		</div>
			    	
			    </div>
			</div>
		    
		    
		    <ul id="myTab" class="nav nav-tabs" style="margin-top: 5px;">
				<li><a href="#news" data-toggle="tab">最新动态</a></li>
				<li><a href="#love" data-toggle="tab">关注的人</a></li>
				<li><a href="#loved" data-toggle="tab">被关注的人</a></li>
			</ul>
			
			<div class="tab-content">
				<!-- 最新动态 -->
				<div class="tab-pane fade" id="news">
					
				</div>
				<!-- 关注的人 -->
				<div class="tab-pane fade" id="love">
					<table class="table table-striped">
				    	<thead>
				    		<tr>
				    			<td>序号</td>
				    			<td>用户</td>
				    			<td>时间</td>
				    		</tr>
				    	</thead>
				    	<tbody id="flowerBody">
				    	</tbody>
				    </table>
				    <center style="margin-bottom: 100px;">
				    	<button id="btn_more" type="button" class="btn btn-info" onclick="showMore()">显示更多</button>
				    </center>
				</div>
				<!-- 被关注的人 -->
				<div class="tab-pane fade" id="loved">
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
