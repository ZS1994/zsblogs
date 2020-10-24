<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>货品信息列表</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript">
	url="${path}/api/familyshop/goods";
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
				url="<%=path %>/api/familyshop/goods/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="100" pageList="[100,500,1000,5000]">
				<thead>
					<tr>
						<th field="name" width="150" sortable="true">货品名称</th>
						<th field="img" width="150" sortable="false">货品图片</th>
						<th field="otherInfo" width="200" sortable="false">其他信息</th>
						<th field="quantity" width="100" sortable="true">库存数量</th>
						<th field="quantityUnit" width="100" sortable="true">数量单位</th>
						<th field="unitPrice" width="100" sortable="true">单价(元)</th>
						<th field="purchasePrice" width="100" sortable="true">进价(元)</th>
					</tr>
				</thead>
			</table>
			<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()">添加货品</a>
					<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateObj()">修改货品</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteObj()">删除货品</a>
					<a class="easyui-linkbutton" iconCls="icon-help" plain="true" disabled="true">帮助</a>
				</div>
				<div class="clear"></div>
				<hr class="hr-geay">
				<form id="search">
					<div class="searchBar-input">
			    		<div>
				    		货品名称：<input name="str1"/>
			    		</div>
			    		<div>
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
					<div class="ftitle">货品</div>
					<hr>
					<form id="fm" method="post" >
						<input type="hidden" name="_method" value="post"/>
						<input type="hidden" name="_token" value="${token}"/>
						<input type="hidden" name="id"/>
						<div class="fitem">
							<label>货品名称:</label>
							<input name="name" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>图片:</label>
							<input type="file" name="img">
						</div>
						<div class="fitem">
							<label>详细信息:</label>
							<textarea name="otherInfo" rows="" cols=""></textarea>
						</div>
						<div class="fitem">
							<label>数量单位:</label>
							<input name="quantityUnit" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>进价:</label>
							<input type="number" name="purchasePrice" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>单价:</label>
							<input type="number" name="unitPrice" class="easyui-validatebox" required="true">
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
