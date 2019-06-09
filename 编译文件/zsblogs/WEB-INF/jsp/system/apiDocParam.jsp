<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>api接口参数管理</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript">
	url="${path}/api/apidoc/param";
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
  	<div class="p_body" style="overflow-y:hidden;">
  			
  			<table id="dg" border="true"
				url="<%=path %>/api/apidoc/param/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="100" pageList="[100,500,1000,5000]">
				<thead>
					<tr>
						<th field="id" width="70" sortable="true">ID</th>
						<th field="adId" width="100" sortable="true">api接口id</th>
						<th field="adName" width="150" sortable="false" data-options="
						formatter:function(value,row,index){
							if(row.apiDoc){
								return row.apiDoc.name;
							}else{
								return '[无法获取其信息]';
							}
		             	}">api接口名称</th>
						<th field="project" width="200" sortable="false" data-options="
						formatter:function(value,row,index){
							if(row.apiDoc){
								return row.apiDoc.project;
							}else{
								return '[无法获取其信息]';
							}
		             	}">api接口所属项目</th>
						<th field="name" width="200" sortable="true">参数</th>
						<th field="type" width="200" sortable="true">类型</th>
						<th field="ismust" width="200" sortable="true" data-options="
						formatter:function(value,row,index){
							if(value=='1'){
								return '是';
							}else if(value=='0'){
								return '否';
							}else{
								return value;
							}
		             	}">是否必须</th>
						<th field="introduce" width="200" sortable="true">解释</th>
						<th field="eg" width="200" sortable="true">示例</th>
					</tr>
				</thead>
			</table>
			<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()">添加参数信息</a>
					<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateObj()">编辑参数信息</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteObj()">删除参数信息</a>
					<a class="easyui-linkbutton" iconCls="icon-help" plain="true" disabled="true">帮助</a>
				</div>
				<div class="clear"></div>
				<hr class="hr-geay">
				<form id="search">
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
				    		api接口id：<input name ="int1" value="${adId }"/>
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
			
			<div id="dlg" class="easyui-dialog" style="padding: 20px;"
					closed="true" buttons="#dlg-buttons" modal="true">
				<div class="dlg_widthAndHeight">
					<div class="ftitle">api接口文档</div>
					<hr>
					<form id="fm" method="post" >
						<input type="hidden" name="_method" value="post"/>
						<input type="hidden" name="_token" value="${token}"/>
						<input type="hidden" name="id"/>
						<div class="fitem">
							<label>api接口id:</label>
							<input name="adId" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>参数:</label>
							<input name="name" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>类型:</label>
							<input name="type" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>是否必须:</label>
							<select name="ismust" class="zs-validatebox-select">
								<option value="1">是</option>
								<option value="0">否</option>
							</select>
						</div>
						<div class="fitem">
							<label>解释:</label>
							<input name="introduce" class="easyui-validatebox" required="true">
							
						</div>
						<div class="fitem">
							<label>示例:</label>
							<textarea name="eg" rows="" cols=""></textarea>
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
