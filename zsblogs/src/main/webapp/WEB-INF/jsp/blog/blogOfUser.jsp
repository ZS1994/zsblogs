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
	function addObj(){
		window.location.href="${path}/menu/blogList/blog/user/edit";
	}
	function updateObj(){
		var row=$("#dg").datagrid("getSelected");
		if(row){
			window.location.href="${path}/menu/blogList/blog/user/edit?id="+row.id;
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
				"您确定要删除吗？删除将会将旗下评论和阅读信息也删除。",
				function(data){
					if(data){
						pullRequest({
							urlb:"/api/blog/one?id="+id,
							type:"delete",
							success:function(data){
								alert(data);
								$('#dg').datagrid('reload');
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
			int2:${not empty acc.int2 ? acc.int2 : "null"}
		});
	}
	$(function(){
		//填充博客栏目内容
		pullRequest({
			urlb:"/api/blogList/user/all",
    		type:"get",
			success:function(data){
				var str="";
				for(var i=0;i<data.length;i++){
					str=str+"<option value=\""+data[i].id+"\">"+data[i].name+"</option>";
				}
				$("#selBlogList").append(str);
				//选择博客栏目，根据上个页面传过来的int3定
				var int3="${acc.int3}";
				var selitem=$("#selBlogList").find("option[value='"+int3+"']").attr("selected","true");
				//直接查一次，不查的话第一次进入默认是不查的
				mySearchToolbar();
			}
		});
	});
	function gotoBlogMain(id){
		var row=$("#dg").datagrid("getSelected");
		var id=row.id;
		if(row){
	    	window.location.href="${path}/menu/blogList/blog/one?id="+id;
		}
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
  	<jsp:include page="/WEB-INF/jsp/part/top_part.jsp"/>
  	<div class="p_body" style="overflow-y:hidden;">
  			
  			<table id="dg" border="true"
				url="${path }/api/blog/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……" nowrap="false"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="100" pageList="[100,500,1000,5000]">
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
		             	<th field="readCount" width="300" sortable="false" data-options="
						formatter:function(value,row,index){
							return row.readCount+'次阅读';
		             	}">阅读次数</th>
					</tr>
				</thead>
			</table>
			<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()">创建博客</a>
					<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateObj()">编辑博客</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteObj()">删除博客</a>
					<a class="easyui-linkbutton" iconCls="icon-zs-forward" plain="true" onclick="gotoBlogMain()">查看该博客</a>
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
				    		标题：<input name ="str1" />
			    		</div>
			    		<div>
			    			摘要：<input name ="str2" />
			    		</div>
			   		</div>
			   		<div class="searchBar-input">
			    		<div>
				    		博客栏目：
				    		<select id="selBlogList" name="int3">
				    			<option value="">所有</option>
				    		</select>
			    		</div>
			   		</div>
			   	</form>
			   	<div class="clear"></div>
			   	<hr class="hr-geay">
				<a class="easyui-linkbutton" iconCls="icon-search" onclick="mySearchToolbar()">查询</a>
				<a class="easyui-linkbutton" iconCls="icon-sum" disabled="true">统计</a>
				<a class="easyui-linkbutton" iconCls="icon-print" onclick="excel_export()" disabled="true">导出</a>
				<div class="pull-away"></div>
			</div>
			
  			
  			
  		</div>
  	<jsp:include page="/WEB-INF/jsp/part/bottom_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/right_part.jsp"/>
  </body>
</html>
