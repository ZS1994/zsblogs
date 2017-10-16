<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>博客栏目</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript">
	var url;
	function addObj(){
		$("#dlg").dialog("open").dialog("setTitle","新建");	
		$("#fm").form("clear");
		$("#fm input[name='_method']").val("post");
		$("#fm input[name='_header']").val("${user.licence }");
		url="<%=path %>/api/provinceCode";
	}
	function updateObj(){
		var row=$("#dg").datagrid("getSelected");
		if(row){
			$("#dlg").dialog("open").dialog("setTitle","修改");
			$("#fm").form("load",row);
			$("#fm input[name='_method']").val("put");
			$("#fm input[name='_header']").val("${licence }");
			url="<%=path%>/api/provinceCode/"+row.provinceCode;
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
						json = eval('('+data+')');
					}
					if(json.result=='success'){
						$('#dg').datagrid('reload');
						$("#dlg").dialog("close");
					}else{
						alert("错误:"+json.code);
					}
				}else{
					alert("错误:网络错误");
				}
			}
		});
	}
	function deleteObj(){
		var row=$("#dg").datagrid("getSelected");
		var id=row.provinceCode;
		if(row){
			$.messager.confirm(
				"操作提示",
				"您确定要删除吗？",
				function(data){
					if(data){
						$.ajax({
							url:"<%=path%>/api/provinceCode/"+id,
							type:"delete",
							success:function(data){
								var json;
								if(isJson(data)){
									json=data;
								}else{
									json = eval('('+data+')');
								}
								if(json.result=='success'){
									$('#dg').datagrid('reload');
								}else{
									alert("错误:"+json.code);
								}
							}
						});
					}
				}
			);
		}
	}
	function excel_export(){
		$("#search").form("submit",{
			url:"<%=path%>/api/timeLimit/excelExport",
			method:"get",
			onSubmit: function(){   
		        // do some check   
		        // return false to prevent submit;   
		    },   
		    success:function(data){   
				if(data!=null){
			    	var d = eval('('+data+')');
			    	window.location.href=d.data;
				}
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
				url="<%=path %>/api/blogList/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="25" pageList="[25,40,50,100]">
				<thead>
					<tr>
						<th field="id" width="100" sortable="true">ID</th>
						<th field="name" width="200" sortable="true">名称</th>
					</tr>
				</thead>
			</table>
			<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()">添加数据</a>
					<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateObj()">编辑数据</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteObj()">删除数据</a>
				</div>
				<div class="btn-separator">
					<a class="easyui-linkbutton" iconCls="icon-help" plain="true" onclick="$('#dlg_help').dialog('open')">帮助</a>
				</div>
				<br class="clear"/>
				<hr class="hr-geay">
				<form id="search">
			   		<div class="searchBar-input">
			    		<div>
				    		省份名称：<input name ="str1" />
			    		</div>
			    		<div>
			    			一段码：<input name ="str2" />
			    		</div>
			   		</div>
			   	</form>
			   	<div class="clear"></div>
			   	<hr class="hr-geay">
				<a class="easyui-linkbutton" iconCls="icon-search" onclick="search_toolbar()">查询</a>
				<a class="easyui-linkbutton" iconCls="icon-search" disabled="true">统计</a>
				<a class="easyui-linkbutton" iconCls="icon-search" onclick="excel_export()" disabled="true">导出</a>
				<div class="pull-away"></div>
			</div>
			
			<div id="dlg" class="easyui-dialog" style="width:600px;height:500px;padding:10px 20px"
					closed="true" buttons="#dlg-buttons" modal="true">
				<div class="ftitle">省份码</div>
				<hr>
				<form id="fm" method="post" >
					<input type="hidden" name="_method" value="post"/>
					<input type="hidden" name="_header" value="${licence }"/>
					<div class="fitem">
						<label>一段码:</label>
						<input name="provinceCode" class="easyui-validatebox" required="true">
					</div>
					<div class="fitem">
						<label>省份:</label>
						<input name="province" class="easyui-validatebox" required="true">
					</div>
				</form>
			</div>
			<div id="dlg-buttons">
				<a class="easyui-linkbutton" iconCls="icon-ok" onclick="save()">提交</a>
				<a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
			</div>
  			
  			
  		</div>
  	
  </body>
</html>
