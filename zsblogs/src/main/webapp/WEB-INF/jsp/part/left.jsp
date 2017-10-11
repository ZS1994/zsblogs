<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if(request.getSession().getAttribute("target")==null){
	request.getSession().setAttribute("target", "right");
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'left.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<link rel="stylesheet" type="text/css" href="<%=path %>/framework/jquery-easyui/themes/black/easyui.css">
	<link rel="stylesheet" type="text/css" href="<%=path %>/framework/jquery-easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="<%=path %>/framework/jquery-easyui/demo/demo.css">
	<script type="text/javascript" src="<%=path %>/framework/jquery-easyui/jquery.min.js"></script>
	<script type="text/javascript" src="<%=path %>/framework/jquery-easyui/jquery.easyui.min.js"></script>
	
	<script type="text/javascript" src="<%=path %>/framework/js/myjs.js"></script>
	<link rel="stylesheet" type="text/css" href="<%=path %>/framework/css/mycss.css">

	<style type="text/css">
	a{
		color: #FFAAFF;
	}
	
	</style>
	
	<script type="text/javascript">
	$(function(){
		//$('#tt').tree('collapseAll');
	});
	</script>
	
  </head>
  
<body style="padding: 0px;">

<div class="easyui-accordion" style="width:100%;"
		data-options="fillSpace:true,fit: true,animate: true,selected:false">
	<div title="快件信息" data-options="iconCls:'icon-ok'" style="overflow:auto;padding:10px;">
		<ul id="tt" class="easyui-tree" data-options="animate:true,lines:true">
	        <li><span><a href="<%=path %>/import" target="${target }">导入数据</a></span></li>
       		<li><span><a href="<%=path %>/import/err" target="${target }">错误数据</a></span></li>
	        <li><span><a href="<%=path %>/sourceZm" target="${target }">运单信息查询</a></span></li>
	        <li><span><a href="<%=path %>/sourceTp" target="${target }">运单状态查询</a></span></li>
        </ul>
	</div>
	<div title="报表" data-options="iconCls:'icon-zs-form-table'" style="padding:10px;">
		<ul id="tt" class="easyui-tree" data-options="animate:true,lines:true">
       		<li><span><a href="<%=path %>/reportDate" target="${target }">日报表</a></span></li>
       		<li><span><a href="<%=path %>/reportMonth" target="${target }">月报表</a></span></li>
       		<li><span><a href="<%=path %>/primeReport/Import" target="${target }">成本导入收集</a></span></li>
       		<li><span><a href="<%=path %>/primeReport/collect" target="${target }">成本收集汇总</a></span></li>
       		<li><span><a href="<%=path %>/primeReport/personle" target="${target }">成本按导入人汇总</a></span></li>
       		<li><span><a href="<%=path %>/reportSign" target="${target }">签收报表</a></span></li>
        </ul>
	</div>
	<div title="系统管理" data-options="iconCls:'icon-system'" style="padding:10px;">
		<ul id="tt" class="easyui-tree" data-options="animate:true,lines:true">
       		<li><span><a href="<%=path %>/user" target="${target }">用户管理</a></span></li>
       		<li><span><a href="<%=path %>/role" target="${target }">角色管理</a></span></li>
	        <li><span><a href="<%=path %>/power" target="${target }">权限管理</a></span></li>
	        <li><span><a href="<%=path %>/checklog" target="${target }">查看日志</a></span></li>
        </ul>
	</div>
	<div title="基础信息维护" data-options="iconCls:'icon-data-add'" style="padding:10px;">
		<ul id="tt" class="easyui-tree" data-options="animate:true,lines:true">
	        <li><span><a href="<%=path %>/customer" target="${target }">大客户信息</a></span></li>
	        <li><span><a href="<%=path %>/timeLimit" target="${target }">时效控制信息</a></span></li>
	        <li><span><a href="<%=path %>/provinceCode" target="${target }">一段码省份对照表</a></span></li>
        </ul>
	</div>
	
	<div title="帮助" data-options="iconCls:'icon-help'" style="padding:10px;">
		<ul id="tt" class="easyui-tree" data-options="animate:true,lines:true">
       		<li><span><a href="<%=path %>/jsp/part/error_code.jsp" target="${target }">错误码说明</a></span></li>
       		<li><span><a href="<%=path %>/jsp/help/sourceImport.jsp" target="${target }">导入数据说明</a></span></li>
       		<li><span><a href="<%=path %>/jsp/help/sourceZm.jsp" target="${target }">运单信息查询说明</a></span></li>
       		<li><span><a href="<%=path %>/jsp/help/sourceTp.jsp" target="${target }">运单状态查询说明</a></span></li>
       		<li><span><a href="<%=path %>/jsp/help/user.jsp" target="${target }">用户管理说明</a></span></li>
       		<li><span><a href="<%=path %>/jsp/help/role.jsp" target="${target }">角色管理说明</a></span></li>
       		<li><span><a href="<%=path %>/jsp/help/province.jsp" target="${target }">标准省份名称</a></span></li>
        </ul>
	</div>
	<!-- 
	<div title="测试" data-options="iconCls:'icon-cancel'" style="padding:10px;">
		<ul id="tt" class="easyui-tree" data-options="animate:true,lines:true">
       		<li><span><a href="<%=path %>/jsp/test/test.jsp" target="${target }">快速测试</a></span></li>
        </ul>
	</div>
	 -->
	
</div>

</body>
</html>
