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
    <title>注册</title>
    <script type="text/javascript">
    $(function(){
    	$('#myTab a:first').tab('show');
    });
    function logup1(){
    	var d=formToJson($("#f1"));
    	var ed=$("#err_dialog"); 
		var edc=$("#err_dialog_content");
		console.log(d);
    	if(d.usernum!=null && d.userpass!=null && d.name!=null){
    		var p1=$("#f1p1").val();
    		var p2=$("#f1p2").val();
    		if(p1==p2){
    			if(d.usernum.length<=30 && d.userpass.length<=30 && d.name.length<=30){
    				if(isPhone(d.usernum)){
    					d.phone=d.usernum;
	    				pullRequest({
	    					urlb:"/api/login/logup",
	    					type:"post",
	    					data:d,
	    					isNeedToken:false,
	    					success:function(data){
	    						window.location.href="${path}/menu/system/login";
	    					}
	    				});
    				}else{
    					edc.html("<strong>账号不是手机号的格式！</strong>");
               			ed.modal("show");
    				}
    			}else{
    				edc.html("<strong>超过最大长度限制！</strong>");
           			ed.modal("show");
    			}
    		}else{
    			edc.html("<strong>两次密码不一致！</strong>");
       			ed.modal("show");
    		}
    	}else{
    		edc.html("<strong>请输入完整信息！</strong>账号、密码、重复密码、昵称均不能为空。");
   			ed.modal("show");
    	}
    }
    function logup2(){
    	var d=formToJson($("#f2"));
    	var ed=$("#err_dialog"); 
		var edc=$("#err_dialog_content");
		console.log(d);
    	if(d.usernum!=null && d.userpass!=null && d.name!=null){
    		var p1=$("#f2p1").val();
    		var p2=$("#f2p2").val();
    		if(p1==p2){
    			if(d.usernum.length<=30 && d.userpass.length<=30 && d.name.length<=30){
    				if(isEmail(d.usernum)){
    					d.mail=d.usernum;
	    				pullRequest({
	    					urlb:"/api/login/logup",
	    					type:"post",
	    					data:d,
	    					isNeedToken:false,
	    					success:function(data){
	    						window.location.href="${path}/menu/system/login";
	    					}
	    				});
    				}else{
    					edc.html("<strong>账号不是邮箱的格式！</strong>");
               			ed.modal("show");
    				}
    			}else{
    				edc.html("<strong>超过最大长度限制！</strong>");
           			ed.modal("show");
    			}
    		}else{
    			edc.html("<strong>两次密码不一致！</strong>");
       			ed.modal("show");
    		}
    	}else{
    		edc.html("<strong>请输入完整信息！</strong>账号、密码、重复密码、昵称均不能为空。");
   			ed.modal("show");
    	}
    }
    function isPhone(str){
    	var reg=/^[1][3,4,5,7,8][0-9]{9}$/;
    	return reg.test(str);
    }
    function isEmail(str){
    	reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/;
   	    return reg.test(str);
    }
    </script>
    <style type="text/css">
    
    </style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body">
			
  		<div class="container" style="width: 90%;margin-top: 50px;">
		    
		    <ul id="myTab" class="nav nav-tabs">
				<li><a href="#phone" data-toggle="tab">通过手机号注册</a></li>
				<li><a href="#email" data-toggle="tab">通过邮箱注册</a></li>
			</ul>
			
			<div class="tab-content">
				<div class="tab-pane fade" id="phone">
					<form id="f1">
						<fieldset>
							<label>手机号<span class="muted">(最大长度：30个字符)</span></label>
							<input type="text" name="usernum" placeholder="请输入手机号…" style="height: auto;">
							<label>密码<span class="muted">(最大长度：30个字符)</span></label>
							<input type="password" name="userpass" id="f1p1" style="height: auto;">
							<label>重复密码<span class="muted">(最大长度：30个字符)</span></label>
							<input type="password" id="f1p2" style="height: auto;">
							<label>昵称<span class="muted">(最大长度：30个字符)</span></label>
							<input type="text" name="name" style="height: auto;">
							<br>
							<button type="button" class="btn" onclick="logup1()">注册</button>
						</fieldset>
					</form>
				</div>
				<div class="tab-pane fade" id="email">
					<form id="f2">
						<fieldset>
							<label>邮箱<span class="muted">(最大长度：30个字符)</span></label>
							<input type="text" name="usernum" placeholder="请输入邮箱…" style="height: auto;">
							<label>密码<span class="muted">(最大长度：30个字符)</span></label>
							<input type="password" name="userpass" id="f2p1" style="height: auto;">
							<label>重复密码<span class="muted">(最大长度：30个字符)</span></label>
							<input type="password" id="f2p2" style="height: auto;">
							<label>昵称<span class="muted">(最大长度：30个字符)</span></label>
							<input type="text" name="name" style="height: auto;">
							<br>
							<button type="button" class="btn" onclick="logup2()">注册</button>
						</fieldset>
					</form>
				</div>
			</div>
			
			
			
			<div id="err_dialog" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<h3 id="myModalLabel">错误</h3>
				</div>
				<div class="modal-body">
					<p id="err_dialog_content"></p>
				</div>
				<div class="modal-footer">
					<button class="btn" data-dismiss="modal" aria-hidden="true">关闭</button>
				</div>
			</div>
			
			
			
			
			
	    </div>
  		
  		
  		
  	</div>
  	
  </body>
</html>
