<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>api接口文档管理</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript">
	url="${path}/api/apidoc";
	function gotoInfo(){
		var row=$("#dg").datagrid("getSelected");
		if(row){
			var id=row.id;
			window.location.href="${path}/menu/system/apidoc/info?id="+id;
		}
	}
	function gotoParam(){
		var row=$("#dg").datagrid("getSelected");
		var id="";
		if(row){
			id=row.id;
		}
		window.location.href="${path}/menu/system/apidoc/param?adId="+id;
	}
	$(function(){
		//直接查一次，不查的话第一次进入默认是不查的
		search_toolbar_2();
	});
	</script>
	<style type="text/css">
	</style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/top_part.jsp"/>
  	<div class="p_body table-body">
  			
  			<table id="dg" border="true"
				url="<%=path %>/api/apidoc/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="100" pageList="[100,500,1000,5000]">
				<thead>
					<tr>
						<th field="id" width="70" sortable="true">ID</th>
						<th field="uId" width="70" sortable="true">创建者id</th>
						<th field="uname" width="150" sortable="false" data-options="
						formatter:function(value,row,index){
							if(row.user){
								return row.user.name;
							}else{
								return '[无法获取其信息]';
							}
		             	}">创建者名字</th>
						<th field="createTime" width="200" sortable="true">创建时间</th>
						<th field="name" width="200" sortable="true">api接口名字</th>
						<th field="project" width="200" sortable="true">所属项目名称</th>
						<th field="flag" width="200" sortable="true">flag标签</th>
						<th field="url" width="200" sortable="true">url</th>
						<th field="method" width="200" sortable="true">method</th>
						<th field="returnEg" width="200" sortable="false">返回示例</th>
					</tr>
				</thead>
			</table>
			<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()">添加api接口文档</a>
					<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateObj()">编辑api接口文档</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteObj()">删除api接口文档</a>
					<a class="easyui-linkbutton" iconCls="icon-zs-forward" plain="true" onclick="gotoParam()">api接口参数管理</a>
					<a class="easyui-linkbutton" iconCls="icon-zs-forward" plain="true" onclick="gotoInfo()">查看详细信息</a>
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
				    		api接口名称：<input name ="str1" />
			    		</div>
			    		<div>
			    			所属项目名称：<input name ="str2" />
			    		</div>
			   		</div>
			   		<div class="searchBar-input">
			    		<div>
				    		创建者名字：<input name ="str3" />
			    		</div>
			    		<div>
			    			标签(flag)：<input name ="str4" />
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
			
			<div id="dlg" class="easyui-dialog" 
					closed="true" buttons="#dlg-buttons" modal="true">
				<div class="dlg_widthAndHeight">
					<div class="ftitle">api接口文档</div>
					<hr>
					<form id="fm" method="post" >
						<input type="hidden" name="_method" value="post"/>
						<input type="hidden" name="_token" value="${token}"/>
						<input type="hidden" name="id"/>
						<div class="fitem">
							<label>api接口名称:</label>
							<input name="name" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>所属项目:</label>
							<input name="project" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>flag标签:</label>
							<input name="flag" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>url:</label>
							<input name="url" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>method:</label>
							<select name="method" class="zs-validatebox-select">
								<option value="GET">GET</option>
								<option value="POST">POST</option>
								<option value="PUT">PUT</option>
								<option value="DELETE">DELETE</option>
							</select>
						</div>
						<div class="fitem">
							<label>返回值示例:</label>
							<textarea name="returnEg" rows="" cols=""></textarea>
						</div>
					</form>
				</div>
			</div>
			<div id="dlg-buttons">
				<a class="easyui-linkbutton"  onclick="selectAll()">全选/全不选</a>
				<a class="easyui-linkbutton"  onclick="negated()">反 选</a>
				<a class="easyui-linkbutton" iconCls="icon-ok" onclick="save()">提交</a>
				<a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
			</div>
  			
  			
  		</div>
  	<jsp:include page="/WEB-INF/jsp/part/bottom_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/right_part.jsp"/>
  </body>
</html>
