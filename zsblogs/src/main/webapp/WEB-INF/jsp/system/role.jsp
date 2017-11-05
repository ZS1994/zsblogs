<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>角色管理</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript">
	var url;
	function addObj(){
		$("#dlg").dialog("open").dialog("setTitle","新建");	
		$("#fm").form("clear");
		$("#fm input[name='_method']").val("post");
		$("#fm input[name='_token']").val("${token}");
		url="${path}/api/role";
	}
	function updateObj(){
		var row=$("#dg").datagrid("getSelected");
		if(row){
			$("#dlg").dialog("open").dialog("setTitle","修改");
			var ss=row.pids.split(",");
			row.pids=ss;
			$("#fm").form("load",row);
			$("#fm input[name='_method']").val("put");
			$("#fm input[name='_token']").val("${token}");
			url="${path}/api/role";
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
							url:"${path}/api/role/one?id="+id,
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
	function selectAll(){
		var a = $('#pers>input');
		if(a[0].checked){
			for(var i = 0;i<a.length;i++){
				if(a[i].type == "checkbox") a[i].checked = false;
			}
		}else{
			for(var i = 0;i<a.length;i++){
				if(a[i].type == "checkbox") a[i].checked = true;
			}
		}
	}
	function negated(){
		$("#pers input:checkbox").each(function () {  
	        this.checked = !this.checked;  
	     }) 
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
				url="<%=path %>/api/role/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……" nowrap="false"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="100" pageList="[100,500,1000,5000]">
				<thead>
					<tr>
						<th field="id" width="50" sortable="true">ID</th>
						<th field="name" width="200" sortable="true">名字</th>
						<th field="introduction" width="500" sortable="true">介绍</th>
						<th field="pids" width="500" sortable="true">权限id序列</th>
					</tr>
				</thead>
			</table>
			<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()">添加角色</a>
					<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateObj()">编辑角色</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteObj()">删除角色</a>
				</div>
				<div class="btn-separator">
					<a class="easyui-linkbutton" iconCls="icon-help" plain="true" disabled="true">帮助</a>
				</div>
				<br class="clear"/>
				<hr class="hr-geay">
				<form id="search">
			   		<div class="searchBar-input" style="margin-left: -50px;">
			    		<div>
				    		名字：<input name ="str1" />
			    		</div>
			    		<div>
			    			介绍：<input name ="str2" />
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
			
			<div id="dlg" class="easyui-dialog" style="width:600px;height:65%;padding:10px 20px"
					closed="true" buttons="#dlg-buttons" modal="true">
				<div class="ftitle">角色</div>
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
						<label>介绍:</label>
						<input name="introduction" class="easyui-validatebox" required="true">
					</div>
					<div class="fitem">
						<label style="width: 100%;">权限:（权限至少要选择一个）</label>
						<div id="pers" style="line-height: normal;font-size: 14px;">
						</div>
					</div>
				</form>
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
