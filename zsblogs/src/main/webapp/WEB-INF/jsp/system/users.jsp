<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	
    <base href="<%=basePath%>">
    <title>用户管理</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript">
	var url;
	function addObj(){
		$("#dlg").dialog("open").dialog("setTitle","新建");	
		$("#fm").form("clear");
		$("#fm input[name='_method']").val("post");
		$("#fm input[name='_token']").val("${token}");
		url="${path}/api/users";
	}
	function updateObj(){
		var row=$("#dg").datagrid("getSelected");
		if(row){
			$("#dlg").dialog("open").dialog("setTitle","修改");
			var ss=row.rids.split(",");
			row.rids=ss;
			$("#fm").form("load",row);
			$("#fm input[name='_method']").val("put");
			$("#fm input[name='_token']").val("${token}");
			url="${path}/api/users";
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
	$(function(){
		//直接查一次，不查的话第一次进入默认是不查的
		search_toolbar();
		//组装角色复选框
		handleRoles();
	});
	/*将img拼接成html代码*/
	function imgStrToHtml(img){
		return "<img class=\"uimg\" src=\""+img+"\" onerror=\"this.src='${path }/framework/image/user/superman_1.png'\">";
	}
	function isdeleteToHtml(value){
		if(value==0){
			return "<span class='green'>否</span>";
		}else if(value==1){
			return "<span class='red'>是</span>";
		}else{
			return value;
		}
	}
	//组装角色复选框
	function handleRoles(){
		var rs=$("#roles"); 
		pullRequest({
			urlb:"/api/role/all",
			type:"get",
			success:function(data){
				var str="";
				for (var i = 0; i < data.length; i++) {
					var r=data[i];					
					str=str+"<input class=\"zs_checkbox\" type=\"checkbox\" name=\"rids\" value=\""+r.id+"\">["+r.id+"]"+r.name+"（"+r.introduction+"）"+"<br>";
				}
				rs.append(str);
			}
		});
	}
	function selectAll(){
		var a = $('#roles>input');
		if(a[0].checked){
			for(var i = 0;i<a.length;i++){
				if(a[i].type == "checkbox") a[i].checked = false;
			}
		}else{
			for(var i = 0;i<a.length;i++){
				if(a[i].type == "checkbox") a[i].checked = true;
			}
		}
	}
	function negated(){
		$("#roles input:checkbox").each(function () {  
	        this.checked = !this.checked;  
	     }) 
	}
	</script>
	<style type="text/css">
	.green{
		color:green;
		font-weight: bold;
	}
	.red{
		color: red;
		font-weight: bold;
	}
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
	.uimg{
		width: 30px;
		height: 30px;
	}
	</style>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/top_part.jsp"/>
  	<div class="p_body table-body">
  			
  			<table id="dg" border="true"
				url="<%=path %>/api/users/list"
				method="get" toolbar="#toolbar"
				loadMsg="数据加载中请稍后……"
				striped="true" pagination="true"
				rownumbers="true" fitColumns="false" 
				singleSelect="true" fit="true"
				pageSize="100" pageList="[100,500,1000,5000]">
				<thead>
					<tr>
						<th field="id" width="50" sortable="true">ID</th>
						<th field="usernum" width="200" sortable="true">账号</th>
						<th field="userpass" width="200" sortable="true">密码</th>
						<th field="name" width="150" sortable="true">名字</th>
						<th field="mail" width="150" sortable="true">邮箱</th>
						<th field="phone" width="200" sortable="true">手机号</th>
						<th field="isdelete" width="80" sortable="true" data-options="
						formatter:function(value,row,index){
							return isdeleteToHtml(value);
		             	}">是否被注销</th>
						<th field="createTime" width="200" sortable="true">创建时间</th>
						<th field="rids" width="200" sortable="true">角色id序列</th>
						<th field="roleNames" width="200" sortable="false">角色名字序列</th>
						<th field="uimg" width="100" sortable="false" data-options="
						formatter:function(value,row,index){
							return imgStrToHtml(row.img);
		             	}">头像</th>
						<th field="img" width="200" sortable="true">头像路径</th>
					</tr>
				</thead>
			</table>
			<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()">添加用户</a>
					<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="updateObj()">编辑用户</a>
					<a class="easyui-linkbutton" iconCls="icon-help" plain="true" disabled="true">帮助</a>
				</div>
				<div class="clear"></div>
				<hr class="hr-geay">
				<form id="search">
					<input type="hidden" name="int1" value="1"/>
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
				    		账号：<input name ="str1" />
			    		</div>
			    		<div>
			    			名字：<input name ="str2" />
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
					<div class="ftitle">用户</div>
					<hr>
					<form id="fm" method="post" >
						<input type="hidden" name="_method" value="post"/>
						<input type="hidden" name="_token" value="${token}"/>
						<input type="hidden" name="id"/>
						<div class="fitem">
							<label>账号:</label>
							<input name="usernum" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>密码:</label>
							<input name="userpass" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>名字:</label>
							<input name="name" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>邮箱:</label>
							<input name="mail" class="easyui-validatebox" >
						</div>
						<div class="fitem">
							<label>手机:</label>
							<input name="phone" class="easyui-validatebox" >
						</div>
						<div class="fitem">
							<label>是否被注销:</label>
							<select name="isdelete">
								<option value="1">是</option>
								<option value="0">否</option>
							</select>
						</div>
						<div class="fitem">
							<label style="width: 100%;">角色:（角色至少要选择一个）</label>
							<div id="roles" style="line-height: normal;font-size: 14px;">
							</div>
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
