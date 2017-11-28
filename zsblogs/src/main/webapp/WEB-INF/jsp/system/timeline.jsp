<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>操作日志</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript">
	$(function(){
		//直接查一次，不查的话第一次进入默认是不查的
		search_toolbar();
		//组装角色复选框
		handleRoles();
	});
	//组装角色复选框
	function handleRoles(){
		var rs=$("#pers"); 
		pullRequest({
			urlb:"/api/permission/all",
			type:"get",
			success:function(data){
				var str="";
				for (var i = 0; i < data.length; i++) {
					var p=data[i];					
					str=str+"<input class=\"zs_checkbox\" type=\"checkbox\" name=\"pids\" value=\""+p.id+"\">["+p.id+"]"+p.name+"（"+p.url+"┃"+p.method+"┃"+p.type+"）"+"<br>";
				}
				rs.append(str);
			}
		});
	}
	</script>
	<style type="text/css">
	.img-circle {
	    -webkit-border-radius: 500px;
	    -moz-border-radius: 500px;
	    border-radius: 500px;
	}
	img {
	    width: auto\9;
	    height: auto;
	    max-width: 100%;
	    vertical-align: middle;
	    border: 0;
	    -ms-interpolation-mode: bicubic;
	}
	</style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body" style="overflow-y:hidden;">
  			
  			<table id="dg" border="true"
				url="<%=path %>/api/timeline/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……" nowrap="true"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="100" pageList="[100,500,1000,5000]">
				<thead>
					<tr>
						<th field="id" width="50" sortable="true">ID</th>
						<th field="uId" width="100" sortable="true">uId</th>
						<th field="user_name" width="200" sortable="false" data-options="
						formatter:function(value,row,index){
							if(row.user){
								return row.user.name;
							}else{
								return [找不到该用户];
							}
		             	}">用户名字</th>
						<th field="pId" width="100" sortable="true">pId</th>
						<th field="per_name" width="200" sortable="false" data-options="
						formatter:function(value,row,index){
							if(row.per){
								return row.per.name;
							}else{
								return [找不到该操作项];
							}
		             	}">操作项</th>
						<th field="createTime" width="200" sortable="true">创建时间</th>
						<th field="info" width="700" sortable="true">参数信息</th>
					</tr>
				</thead>
			</table>
			<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()" disabled="true">添加日志</a>
					<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateObj()" disabled="true">编辑日志</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteObj()" disabled="true">删除日志</a>
					<a class="easyui-linkbutton" iconCls="icon-help" plain="true" disabled="true">帮助</a>
				</div>
				<div class="clear"></div>
				<hr class="hr-geay">
				<form id="search">
			   		<div class="searchBar-input">
			    		<div>
				    		创建时间开始：<input name="date1" id="d4311" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'d4312\')}' ,dateFmt:'yyyy/MM/dd HH:mm:ss'})"/>
			    		</div>
			    		<div>
			    			创建时间结束：<input name="date2" id="d4312" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'d4311\')}' ,dateFmt:'yyyy/MM/dd HH:mm:ss'})"/>
			    		</div>
			   		</div>
			   		<div class="searchBar-input">
			    		<div>
				    		用户名字：<input name ="str1" />
			    		</div>
			    		<div>
			    			操作项：<input name ="str2" />
			    		</div>
			   		</div>
			   	</form>
			   	<div class="clear"></div>
			   	<hr class="hr-geay">
				<a class="easyui-linkbutton" iconCls="icon-search" onclick="search_toolbar()">查询</a>
				<a class="easyui-linkbutton" iconCls="icon-sum" disabled="true">统计</a>
				<a class="easyui-linkbutton" iconCls="icon-print" onclick="excel_export()" disabled="true">导出</a>
				<div class="pull-away"></div>
			</div>
  			
  		</div>
  	
  </body>
</html>
