<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>index</title>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
<script type="text/javascript">
function testCors(){
	$.ajax({
		url:"${path}/api/test/testCors",
		type:"post",
		data:{a:"你好"},
		beforeSend: function(request) {
            request.setRequestHeader("token", "5171437139167");
        },
		success:function(data){
			console.log(data);
		}
	});
}
function getToken(){
	$.ajax({
		url:"${path}/api/login/token",
		type:"post",
		data:{usernumber:"admin",userpassword:"123456"},
		success:function(data){
			console.log(data);
		}
	});
}
</script>

	<a class="easyui-linkbutton" iconCls="icon-search" href="<%=path%>/menu/index">测试easyui样式和controller是否起作用</a>
	<a class="easyui-linkbutton" iconCls="icon-search" onclick="testCors()">测试 跨域、权限、时间轴是否生效</a>
	<a class="easyui-linkbutton" iconCls="icon-search" onclick="getToken()">获取token</a>
	
	<a class="easyui-linkbutton" iconCls="icon-search" href="<%=path%>/staticView/test.jsp">本地接口测试工具</a>
	
	
</body>
</html>
