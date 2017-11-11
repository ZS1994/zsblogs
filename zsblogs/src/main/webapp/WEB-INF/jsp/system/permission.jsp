<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>权限管理</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript">
	var url;
	function addObj(){
		$("#dlg").dialog("open").dialog("setTitle","新建");	
		$("#fm").form("clear");
		$("#fm input[name='_method']").val("post");
		$("#fm input[name='_token']").val("${token}");
		url="${path}/api/permission";
	}
	function updateObj(){
		var row=$("#dg").datagrid("getSelected");
		if(row){
			$("#dlg").dialog("open").dialog("setTitle","修改");
			$("#fm").form("load",row);
			$("#fm input[name='_method']").val("put");
			$("#fm input[name='_token']").val("${token}");
			url="${path}/api/permission";
		}
	}
	function save(){
		$("#fm").form("submit",{
			url:url,		
			onSubmit:function(){
				return $(this).form('validate');
			},
			success:function(data){
				if(data){
					var json;
					if(isJson(data)){
						json=data;
					}else{
						json=JSON.parse(data);
					}
					if(json.result=='success'){
						$('#dg').datagrid('reload');
						$("#dlg").dialog("close");
					}else{
						alert("错误:["+json.code+"]"+json.data);
					}
				}else{
					alert("错误:返回值为空。");
				}
			}
		});
	}
	function deleteObj(){
		var row=$("#dg").datagrid("getSelected");
		var id=row.id;
		if(row){
			$.messager.confirm(
				"操作提示",
				"您确定要删除吗？",
				function(data){
					if(data){
						$.ajax({
							url:"${path}/api/permission/one?id="+id,
							type:"delete",
							success:function(data){
								var json;
								if(isJson(data)){
									json=data;
								}else{
									json=JSON.parse(data);
								}
								if(json.result=='success'){
									$('#dg').datagrid('reload');
								}else{
									alert("错误:["+json.code+"]"+json.data);
								}
							}
						});
					}
				}
			);
		}
	}
	$(function(){
		//直接查一次，不查的话第一次进入默认是不查的
		search_toolbar();
	});
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
				url="<%=path %>/api/permission/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……" nowrap="true"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="100" pageList="[100,500,1000,5000]">
				<thead>
					<tr>
						<th field="id" width="50" sortable="true">ID</th>
						<th field="name" width="200" sortable="true">名字</th>
						<th field="url" width="500" sortable="true">url</th>
						<th field="method" width="100" sortable="true">method</th>
						<th field="type" width="100" sortable="true" data-options="
						formatter:function(value,row,index){
							if(value=='menu'){
								return '菜单权限';
							}else if(value=='api'){
								return 'api接口权限';
							}else{
								return value;
							}
		             	}">类型</th>
						<th field="flag" width="100" sortable="true">标签</th>
						<th field="menuOrder" width="200" sortable="true">菜单序号(菜单时有效)</th>
						<th field="menuImg" width="200" sortable="true">菜单图标(菜单时有效)</th>
						<th field="menuParentId" width="200" sortable="true">菜单上级菜单id(菜单时有效)</th>
					</tr>
				</thead>
			</table>
			<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()">添加权限</a>
					<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateObj()">编辑权限</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteObj()">删除权限</a>
					<a class="easyui-linkbutton" iconCls="icon-help" plain="true" disabled="true">帮助</a>
				</div>
				<div class="clear"></div>
				<hr class="hr-geay">
				<form id="search">
			   		<div class="searchBar-input" style="margin-left: -50px;">
			    		<div>
				    		名字：<input name ="str1" />
			    		</div>
			    		<div>
			    			url：<input name ="str2" />
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
					<div class="ftitle">权限</div>
					<hr>
					<form id="fm" method="post" >
						<input type="hidden" name="_method" value="post"/>
						<input type="hidden" name="_token" value="${token}"/>
						<input type="hidden" name="id"/>
						<div class="fitem">
							<label>名字:</label>
							<input name="name" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>url:</label>
							<input name="url" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>method:</label>
							<select name="method">
								<option value="GET">GET</option>
								<option value="POST">POST</option>
								<option value="PUT">PUT</option>
								<option value="DELETE">DELETE</option>
							</select>
						</div>
						<div class="fitem">
							<label>类型:</label>
							<select name="type">
								<option value="menu">菜单权限</option>
								<option value="api">api接口权限</option>
							</select>
						</div>
						<div class="fitem">
							<label>标签:</label>
							<input name="flag" class="easyui-validatebox">
						</div>
						<div class="fitem">
							<label>菜单图标:</label>
							<input name="menuImg" class="easyui-validatebox">
						</div>
						<div class="fitem">
							<label>菜单序号:</label>
							<input name="menuOrder" class="easyui-validatebox">
						</div>
						<div class="fitem">
							<label>菜单上级菜单id:</label>
							<input name="menuParentId" class="easyui-validatebox">
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
  	
  </body>
</html>
