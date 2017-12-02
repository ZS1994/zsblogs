<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
<link href="<%=path %>/framework/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="<%=path %>/framework/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="<%=path%>/framework/css/mainPagePart.css">
<script type="text/javascript" src="<%=path %>/framework/jquery-easyui/jquery.min.js"></script>
<script type="text/javascript" src="<%=path %>/framework/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="<%=path %>/framework/js/public.js"></script>
<link rel="stylesheet" type="text/css" href="<%=path%>/framework/css/public.css">
<script type="text/javascript" src="<%=path %>/framework/json2/json2.js"></script>
