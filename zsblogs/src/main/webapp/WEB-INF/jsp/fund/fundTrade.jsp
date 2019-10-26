<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>基金交易</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript">
	url="${path}/api/fundTrade";
	$(function(){
		//直接查一次，不查的话第一次进入默认是不查的
		//search_toolbar_2();
		//modify 1 张顺 2019-7-28 基金输入框改为自动补全控件
		initFundInfoAuto($("input[name='str1']"));
		initUsersAuto($("input[name='int1']"));
		//modify -1 张顺 2019-7-28 改为自动补全控件
	});
	function gotoCharts(){
		window.location.href="${path}/menu/fund/fundCharts";
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
				url="<%=path %>/api/fundTrade/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="100" pageList="[100,500,1000,5000]">
				<thead>
					<tr>
						<th field="id" width="100" sortable="true">id</th>
						<th field="uId" width="150" sortable="true" data-options="
						formatter:function(value,row,index){
							if(row.u){
								return row.u.name+'('+row.u.id+')';
							}else{
								return value;
							}
		             	}">用户</th>
						<th field="fiId" width="250" sortable="true" data-options="
						formatter:function(value,row,index){
							if(row.fi){
								return row.fi.name+'('+row.fi.id+')';
							}else{
								return value;
							}
		             	}">基金</th>
						<th field="buyMoney" width="200" sortable="true">买入金额</th>
						<th field="buyNumber" width="200" sortable="true">买入份额</th>
						<th field="createTime" width="250" sortable="true">创建时间</th>
						<th field="type" width="150" sortable="true">类型</th>
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
				    		创建时间开始：<input name="date1" id="d4311" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'d4312\')}' ,dateFmt:'yyyy/MM/dd'})"/>
			    		</div>
			    		<div>
			    			创建时间结束：<input name="date2" id="d4312" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'d4311\')}' ,dateFmt:'yyyy/MM/dd'})"/>
			    		</div>
			   		</div>
			   		<div class="searchBar-input">
			    		<div>
				    		基金编号：
				    		<input name="str1"/>
			    		</div>
			    		<div>
			    			用户：
			    			<input name ="int1"/>
			    		</div>
			   		</div>
			   		<div class="searchBar-input">
			    		<div>
				    		类型：
				    		<select name="str3">
				    			<option value="">--请选择--</option>
								<option value="定投">定投</option>
								<option value="补仓">补仓</option>
								<option value="买入">买入</option>
								<option value="赎回">赎回</option>
							</select>
			    		</div>
			   		</div>
			   	</form>
			   	<div class="clear"></div>
			   	<hr class="hr-geay">
				<a class="easyui-linkbutton" iconCls="icon-search" onclick="search_toolbar()">查询</a>
				<a class="easyui-linkbutton" iconCls="icon-sum" onclick="gotoCharts()">统计</a>
				<a class="easyui-linkbutton" iconCls="icon-print" onclick="" disabled="true">导出</a>
				<div class="pull-away"></div>
			</div>
			
			<div id="dlg" class="easyui-dialog" style="padding: 20px;"
					closed="true" buttons="#dlg-buttons" modal="true">
				<div class="dlg_widthAndHeight">
					<div class="ftitle">基金信息</div>
					<hr>
					<form id="fm" method="post" >
						<input type="hidden" name="_method" value="post"/>
						<input type="hidden" name="_token" value="${token}"/>
						<input type="hidden" name="id"/>
						<div class="fitem">
							<label>基金:</label>
							<input name="fiId" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>买入金额:</label>
							<input name="buyMoney" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>买入时间:</label>
							<input name="createTime" class="Wdate easyui-validatebox" type="text" onFocus="WdatePicker({dateFmt:'yyyy/MM/dd'})" required="true"/>
						</div>
						<div class="fitem">
							<label>类型:</label>
							<select name="type" class="zs-validatebox-select">
								<option value="定投">定投</option>
								<option value="补仓">补仓</option>
								<option value="买入">买入</option>
								<option value="赎回">赎回</option>
							</select>
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
