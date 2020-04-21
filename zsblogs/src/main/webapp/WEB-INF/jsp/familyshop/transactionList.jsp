<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>交易单管理</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript">
	url="${path}/api/familyshop/transaction";
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
				url="<%=path %>/api/familyshop/transaction/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="100" pageList="[100,500,1000,5000]">
				<thead>
					<tr>
						<th field="id" width="100" sortable="true">交易单编号</th>
						<th field="customer" width="150" sortable="true">顾客</th>
						<th field="time" width="200" sortable="true">交易时间</th>
						<th field="state" width="100" sortable="true">状态</th>
						<th field="note" width="300" sortable="false">备注</th>
						<th field="note" width="400" sortable="false">商品概况</th>
					</tr>
				</thead>
			</table>
			<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()">添加交易单</a>
					<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateObj()">编辑交易单</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteObj()">删除交易单</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="">查看交易单详情</a>
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
				    		顾客：<input name ="str1" />
			    		</div>
			    		<div>
			    			购买商品：<input name ="str2" />
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
					<div class="ftitle">交易单</div>
					<hr>
					<form id="fm" method="post" >
						<input type="hidden" name="_method" value="post"/>
						<input type="hidden" name="_token" value="${token}"/>
						<input type="hidden" name="id"/>
						<div class="fitem">
							<label>顾客:</label>
							<input name="customer" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>状态:</label>
							<select name="state">
								<option value="已完成">已完成</option>
								<option value="赊账">赊账</option>
							</select>
						</div>
						<div class="fitem">
							<label>备注:</label>
							<input name="note" class="easyui-validatebox" required="true">
						</div>
						
						<div class="fitem">
							<label>商品明细:</label>
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
