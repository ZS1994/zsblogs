<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>基金历史</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript">
	url="${path}/api/fundHistory";
	$(function(){
		//modify 1 张顺 2019-7-28 基金输入框改为自动补全控件
		//初始化表格控件
		pullRequest({
			urlb:"/api/fundInfo/list",
			type:"GET",
			async:true,
			data:{
				page:1,
				rows:MAXTOTAL
			},
			superSuccess:function(data){
				var array=[];
				$.each(data.rows,function(i,v){
					array.push({value:"("+v.id+")"+v.name,data:v.id});
				});
				//初始化自动补全控件
				$("#str1").autocomplete({
					lookup:array,
					lookupLimit:SHOW_MAX_TOTALS,
					onSelect:function (suggestion) {
						$("#str1").val(suggestion.data);
					},
					width:SHOW_WIDTH,
					maxHeight:SHOW_MAXHEIGHT
				});
			}
		});
		//直接查一次，不查的话第一次进入默认是不查的
		//search_toolbar_2();
		//modify -1 张顺 2019-7-28 改为自动补全控件
	});
	function styleRate(val){
		if (val>0) {
			return "<font color='red'>"+val+"%</font>";
		}else if(val<0){
			return "<font color='green'>"+val+"%</font>";
		}else{
			return "<font color='black'>"+val+"%</font>";
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
  	<div class="p_body table-body">
  			
  			<table id="dg" border="true"
				url="<%=path %>/api/fundHistory/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="100" pageList="[100,500,1000,5000]">
				<thead>
					<tr>
						<th field="id" width="100" sortable="true">ID</th>
						<th field="fiId" width="300" sortable="true" data-options="
						formatter:function(value,row,index){
							if(row.fi){
								return row.fi.name+'('+row.fi.id+')';
							}else{
								return value;
							}
		             	}">基金</th>
						<th field="time" width="200" sortable="true">时间</th>
						<th field="netvalue" width="200" sortable="true">净值</th>
						<th field="rate" width="200" sortable="true" data-options="
						formatter:function(value,row,index){
							return styleRate(value);
		             	}">涨幅</th>
					</tr>
				</thead>
			</table>
			<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()">添加</a>
					<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateObj()">修改</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteObj()">删除</a>
					<a class="easyui-linkbutton" iconCls="icon-help" plain="true" disabled="true">帮助</a>
				</div>
				<div class="clear"></div>
				<hr class="hr-geay">
				<form id="search">
					<div class="searchBar-input">
			    		<div>
				    		时间开始：<input name="date1" id="d4311" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'d4312\')}' ,dateFmt:'yyyy/MM/dd'})"/>
			    		</div>
			    		<div>
			    			时间结束：<input name="date2" id="d4312" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'d4311\')}' ,dateFmt:'yyyy/MM/dd'})"/>
			    		</div>
			   		</div>
			   		<div class="searchBar-input">
			    		<div>
				    		基金编码：
				    		<input id=str1 name="str1" autocomplete="off"/>
			    		</div>
			   		</div>
			   	</form>
			   	<div class="clear"></div>
			   	<hr class="hr-geay">
				<a class="easyui-linkbutton" iconCls="icon-search" onclick="search_toolbar()">查询</a>
				<a class="easyui-linkbutton" iconCls="icon-sum" disabled="true">统计</a>
				<a class="easyui-linkbutton" iconCls="icon-print" onclick="" disabled="true">导出</a>
				<div class="pull-away"></div>
			</div>
			
			<div id="dlg" class="easyui-dialog" style="padding: 20px;"
					closed="true" buttons="#dlg-buttons" modal="true">
				<div class="dlg_widthAndHeight">
					<div class="ftitle">基金历史</div>
					<hr>
					<form id="fm" method="post" >
						<input type="hidden" name="_method" value="post"/>
						<input type="hidden" name="_token" value="${token}"/>
						<input type="hidden" name="id"/>
						<div class="fitem">
							<label>基金编码:</label>
							<input name="fiId" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>时间:</label>
							<input name="time" class="Wdate" type="text" onFocus="WdatePicker({dateFmt:'yyyy/MM/dd'})"/>
						</div>
						<div class="fitem">
							<label>净值:</label>
							<input name="netvalue" class="easyui-validatebox" required="true">
						</div>
					</form>
				</div>
			</div>
			<div id="dlg-buttons">
				<a class="easyui-linkbutton" iconCls="icon-ok" onclick="save()">提交</a>
				<a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
			</div>
  			
  			
  		</div>
  	<jsp:include page="/WEB-INF/jsp/part/bottom_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/right_part.jsp"/>
  </body>
</html>
