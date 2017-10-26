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
			if(row.blogsNum!=null || row.blogsNum!=0){
				$.messager.alert("警告","仅当该栏目的博客数为0时才能删除，那不是0怎么办呢？你可以把它旗下的所有博客全部移到别的栏目下，你就能删除了。");  
			}else{
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
	function gotoTheBlogs(){
		var row=$("#dg").datagrid("getSelected");
		var id=row.id;
		if(row){
			window.location.href="${path}/menu/user/blog?int2="+row.user.id+"&int3="+id;
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
						<th field="createTime" width="200" sortable="true">创建时间</th>
						<th field="blOrder" width="100" sortable="true">序号</th>
						<th field="uId" width="200" sortable="true" data-options="
						formatter:function(value,row,index){
		                    if(row.user){
								return row.user.name;
		                    }
		             	}">用户</th>
		             	<th field="blogsNum" width="100" sortable="false" data-options="
						formatter:function(value,row,index){
		                    if(row.blogsNum){
								return row.blogsNum;
		                    }else{
		                    	return 0;
		                    }
		             	}">博客数量</th>
					</tr>
				</thead>
			</table>
			<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()">添加博客栏目</a>
					<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateObj()">编辑博客栏目</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteObj()">删除博客栏目</a>
				</div>
				<div class="btn-separator">
					<a class="easyui-linkbutton" iconCls="icon-zs-forward" plain="true" onclick="gotoTheBlogs()">查看该栏目的博客</a>
					<a class="easyui-linkbutton" iconCls="icon-help" plain="true" disabled="true">帮助</a>
				</div>
				<br class="clear"/>
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
				    		ID：<input name ="int2" />
			    		</div>
			    		<div>
			    			名称：<input name ="str1" />
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
			
			<div id="dlg" class="easyui-dialog" style="width:600px;height:50%;padding:10px 20px"
					closed="true" buttons="#dlg-buttons" modal="true">
				<div class="ftitle">博客栏目</div>
				<hr>
				<form id="fm" method="post" >
					<input type="hidden" name="_method" value="post"/>
					<input type="hidden" name="_token" value="${token}"/>
					<input type="hidden" name="id"/>
					<div class="fitem">
						<label>名称:</label>
						<input name="name" class="easyui-validatebox" required="true">
					</div>
					<div class="fitem">
						<label>序号:</label>
						<input name="blOrder" class="easyui-validatebox" required="true">
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
