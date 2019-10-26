<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>基金列表信息</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript">
	url="${path}/api/fundInfo";
	$(function(){
		//直接查一次，不查的话第一次进入默认是不查的
		search_toolbar_2();
		initFundInfoAuto($("input[name='str1']"));
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
  	<jsp:include page="/WEB-INF/jsp/part/top_part.jsp"/>
  	<div class="p_body table-body">
  			
  			<table id="dg" border="true"
				url="<%=path %>/api/fundInfo/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……" nowrap="false"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="100" pageList="[100,500,1000,5000]">
				<thead>
					<tr>
						<th field="id" width="100" sortable="true">基金编码</th>
						<th field="name" width="200" sortable="true">基金名称</th>
						<th field="manager" width="150" sortable="true">基金经理</th>
						<th field="scale" width="150" sortable="true">基金规模</th>
						<th field="type" width="100" sortable="true">基金类型</th>
						<th field="company" width="200" sortable="true">基金公司</th>
						<th field="grade" width="100" sortable="true">基金评级</th>
						<th field="buyMin" width="120" sortable="true">最小购买</th>
						<th field="buyRate" width="120" sortable="true">前端费率</th>
						<th field="selloutRateOne" width="120" sortable="true">赎回费率<br>(&lt;1年)</th>
						<th field="selloutRateTwo" width="120" sortable="true">赎回费率<br>(>=1年,&lt;2年)</th>
						<th field="selloutRateThree" width="120" sortable="true">赎回费率<br>(>2年)</th>
						<th field="managerRate" width="120" sortable="true">管理费率</th>
						<th field="createDate" width="150" sortable="true">成立日</th>
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
				    		成立时间开始：<input name="date1" id="d4311" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'d4312\')}' ,dateFmt:'yyyy/MM/dd'})"/>
			    		</div>
			    		<div>
			    			成立时间结束：<input name="date2" id="d4312" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'d4311\')}' ,dateFmt:'yyyy/MM/dd'})"/>
			    		</div>
			   		</div>
			   		<div class="searchBar-input">
			    		<div>
				    		基金：<input name="str1" />
			    		</div>
			   		</div>
			   		<div class="searchBar-input">
			    		<div>
				    		基金经理：<input name="str3" />
			    		</div>
			    		<div>
			    			基金公司：<input name="str4" />
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
					<div class="ftitle">基金信息</div>
					<hr>
					<form id="fm" method="post" >
						<input type="hidden" name="_method" value="post"/>
						<input type="hidden" name="_token" value="${token}"/>
						<div class="fitem">
							<label>基金编码:</label>
							<input name="id" class="easyui-validatebox" data-options="required:true,validType:['number','length[0,10]']">
						</div>
						<div class="fitem">
							<label>基金名称:</label>
							<input name="name" class="easyui-validatebox" data-options="required:true,validType:['text','length[0,20]']">
						</div>
						<div class="fitem">
							<label>基金经理:</label>
							<input name="manager" class="easyui-validatebox" data-options="required:true,validType:['text','length[0,10]']">
						</div>
						<div class="fitem">
							<label>基金规模:</label>
							<input name="scale" class="easyui-validatebox" data-options="required:true,validType:['text','length[0,10]']">
						</div>
						<div class="fitem">
							<label>基金类型:</label>
							<input name="type" class="easyui-validatebox" data-options="required:true,validType:['text','length[0,10]']">
						</div>
						<div class="fitem">
							<label>基金公司:</label>
							<input name="company" class="easyui-validatebox" data-options="required:true,validType:['text','length[0,10]']">
						</div>
						<div class="fitem">
							<label>基金评级:</label>
							<input name="grade" class="easyui-validatebox" data-options="required:true,validType:['number','length[0,1]']">
						</div>
						<div class="fitem">
							<label>最小购买:</label>
							<input name="buyMin" class="easyui-validatebox" data-options="required:true,validType:['number','length[0,10]']">
						</div>
						<div class="fitem">
							<label>前端费率:</label>
							<input name="buyRate" class="easyui-validatebox" data-options="required:true,validType:['number','length[0,10]']">
						</div>
						<div class="fitem">
							<label>赎回费率(&lt;1年):</label>
							<input name="selloutRateOne" class="easyui-validatebox" data-options="required:true,validType:['number','length[0,10]']">
						</div>
						<div class="fitem">
							<label>赎回费率(>=1年,&lt;2年):</label>
							<input name="selloutRateTwo" class="easyui-validatebox" data-options="required:true,validType:['number','length[0,10]']">
						</div>
						<div class="fitem">
							<label>赎回费率(>2年):</label>
							<input name="selloutRateThree" class="easyui-validatebox" data-options="required:true,validType:['number','length[0,10]']">
						</div>
						<div class="fitem">
							<label>管理费率:</label>
							<input name="managerRate" class="easyui-validatebox" data-options="required:true,validType:['number','length[0,10]']">
						</div>
						<div class="fitem">
							<label>成立日:</label>
							<input name="createTime" class="Wdate easyui-validatebox" type="text" onFocus="WdatePicker({dateFmt:'yyyy/MM/dd'})" required="true"/>
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
