<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>库存单管理</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript">
	url="${path}/api/familyshop/stock";
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
				url="<%=path %>/api/familyshop/stock/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="100" pageList="[100,500,1000,5000]">
				<thead>
					<tr>
						<th field="gId" width="150" sortable="true" data-options="
						formatter:function(value,row,index){
							if(row.goods){
								return row.goods.name;
							}else{
								return '[无法获取其信息]';
							}
		             	}">货品名称</th>
						<th field="quantity" width="100" sortable="true">库存数量</th>
						<th field="state" width="100" sortable="true">状态</th>
						<th field="time" width="200" sortable="true">创建时间</th>
						<th field="purchasePrice" width="100" sortable="true">进价(元)</th>
						<th field="people" width="100" sortable="true">相关人员</th>
						<th field="traId" width="150" sortable="true">交易单编号</th>
					</tr>
				</thead>
			</table>
			<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()">新增入库单</a>
					<%--<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateObj()">编辑库存单信息</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteObj()">删除库存单信息</a>--%>
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
				    		货品名称：<input name ="str1" />
			    		</div>
			    		<div>
			    			交易单编号：<input name ="int1" />
			    		</div>
			   		</div>
			   		<div class="searchBar-input">
			    		<div>
				    		相关人员：<input name ="str2" />
			    		</div>
			    		<div>
			    			状态：<input name ="str3" />
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
					<div class="ftitle">交易单</div>
					<hr>
					<form id="fm" method="post" >
						<input type="hidden" name="_method" value="post"/>
						<input type="hidden" name="_token" value="${token}"/>
						<input type="hidden" name="id"/>
						<div class="fitem">
							<label>货品id:</label>
							<input name="gId" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>库存数量:</label>
							<input type="number" name="quantity" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>状态:</label>
							<select name="state">
								<option value="入库">入库</option>
								<option value="出库">出库</option>
							</select>
						</div>
						<div class="fitem">
							<label>相关人员:</label>
							<input name="people" class="easyui-validatebox" required="true">
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
