<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>我的博客</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript">
	var url;
	function addObj(){
		$("#dlg").dialog("open").dialog("setTitle","新建");	
		$("#fm").form("clear");
		$("#fm input[name='_method']").val("post");
		$("#fm input[name='_token']").val("${token}");
		url="${path}/api/blogList";
	}
	function updateObj(){
		var row=$("#dg").datagrid("getSelected");
		if(row){
			$("#dlg").dialog("open").dialog("setTitle","修改");
			$("#fm").form("load",row);
			$("#fm input[name='_method']").val("put");
			$("#fm input[name='_token']").val("${token}");
			url="${path}/api/blogList";
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
							url:"${path}/api/blogList/one?id="+id,
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
	function mySearchToolbar(){
		search_toolbar_2({
			int2:${not empty acc.int2 ? acc.int2 : "null"},
			int3:${not empty acc.int3 ? acc.int3 : "null"}
		});
	}
	$(function(){
		//直接查一次，不查的话第一次进入默认是不查的
		mySearchToolbar();
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
				url="${path }/api/blog/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……" nowrap="false"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="25" pageList="[25,40,50,100]">
				<thead>
					<tr>
						<th field="id" width="100" sortable="true">ID</th>
						<th field="title" width="300" sortable="true">标题</th>
						<th field="summary" width="500" sortable="true">摘要</th>
						<th field="createTime" width="200" sortable="true">创建时间</th>
						<th field="ishide" width="100" sortable="true">是否隐藏</th>
		             	<th field="blogListNames" width="300" sortable="false" data-options="
						formatter:function(value,row,index){
		                    if(row.blogListNames){
								return row.blogListNames;
		                    }else{
		                    	return '';
		                    }
		             	}">所属栏目</th>
					</tr>
				</thead>
			</table>
			<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()">创建博客</a>
					<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateObj()">编辑博客</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteObj()" disabled="true">删除博客</a>
				</div>
				<div class="btn-separator">
					<a class="easyui-linkbutton" iconCls="icon-help" plain="true" disabled="true">帮助</a>
				</div>
				<br class="clear"/>
				<hr class="hr-geay">
				<form id="search">
			   		<div class="searchBar-input">
			    		<div>
				    		创建时间开始：<input name ="date1" />
			    		</div>
			    		<div>
			    			创建时间结束：<input name ="date2" />
			    		</div>
			   		</div>
			   		<div class="searchBar-input">
			    		<div>
				    		标题：<input name ="str1" />
			    		</div>
			    		<div>
			    			摘要：<input name ="str2" />
			    		</div>
			   		</div>
			   		<div class="searchBar-input">
			    		<div>
				    		博客栏目：<input name ="int3" />
			    		</div>
			   		</div>
			   	</form>
			   	<div class="clear"></div>
			   	<hr class="hr-geay">
				<a class="easyui-linkbutton" iconCls="icon-search" onclick="mySearchToolbar()">查询</a>
				<a class="easyui-linkbutton" iconCls="icon-search" disabled="true">统计</a>
				<a class="easyui-linkbutton" iconCls="icon-search" onclick="excel_export()" disabled="true">导出</a>
				<div class="pull-away"></div>
			</div>
			
			<div id="dlg" class="easyui-dialog" style="width:600px;height:50%;padding:10px 20px"
					closed="true" buttons="#dlg-buttons" modal="true">
				<div class="ftitle">博客栏目</div>
				<hr>
				<form id="fm" method="post" >
					<input type="hidden" name="_method" value="post"/>
					<input type="hidden" name="_token" value="${token}"/>
					<input type="hidden" name="id"/>
					<div class="fitem">
						<label>创建时间开始:</label>
						<input name="date1" class="easyui-validatebox" required="true">
					</div>
					<div class="fitem">
						<label>创建时间结束:</label>
						<input name="date2" class="easyui-validatebox" required="true">
					</div>
					<div class="fitem">
						<label>标题:</label>
						<input name="name" class="easyui-validatebox" required="true">
					</div>
					<div class="fitem">
						<label>摘要:</label>
						<input name="blOrder" class="easyui-validatebox" required="true">
					</div>
					<div class="fitem">
						<label>博客栏目:</label>
						<input name="int3" class="easyui-validatebox" required="true">
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
