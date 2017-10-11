<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<link rel="stylesheet" type="text/css" href="<%=path %>/framework/jquery-easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=path %>/framework/jquery-easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="<%=path %>/framework/jquery-easyui/demo/demo.css">
<script type="text/javascript" src="<%=path %>/framework/jquery-easyui/jquery.min.js"></script>
<script type="text/javascript" src="<%=path %>/framework/jquery-easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=path %>/framework/jquery-easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="<%=path %>/framework/My97DatePicker/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css" href="<%=path %>/framework/css/zs.css">
<script type="text/javascript" src="<%=path %>/framework/js/zs.js"></script>
<script type="text/javascript" src="<%=path %>/framework/json2/json2.js"></script>

<script type="text/javascript">
/*张顺，2017-2-25
 * ajax添加头信息
 * */
$.ajaxSetup({ 
	//headers : {"token":"${user.licence}"},
	error:function(XMLHttpRequest, textStatus, errorThrown){
		alert(textStatus+" : "+XMLHttpRequest.status+"  "+errorThrown);
	}
});
//------------张顺，2017-6-29，第一次进入页面不加载数据（开始）-------------------
var dg_options={};//数据表格的属性
var isDgInit=false;//数据表格是否初始化
/*该方法会在每个需要自定义列模板的jsp页面重写*/
function stylesheet(){
	return null;
}
function setColumns(sst){
	if(sst){
		$('#dg').datagrid({
			columns:sst
		});
	}
}
/*查询方法，如果需要自定义查询，请在自己的jsp中重写该方法*/
function search_toolbar(){
	var f=$('#search');
	if(f.form('validate')){
		isDgInit=true;
		var json=formToJson(f);
		$('#dg').datagrid('load', json);
	}
}
$(function(){
	dg_options.onLoadSuccess=function (data) {
		$(this).datagrid("fixRownumber");
	};
	dg_options.onBeforeLoad=function(param){
		if(isDgInit==false){
			return false;
		}else{
			return true;
		}
	};
	dg_options.loadFilter=function(data){
		var a=eval('('+"{'total':'0',rows:''}"+')');
		if (data){
			if(data.result){
				if(data.result=='error'){
					alert("错误:"+data.code+"  "+data.data);
					return a;
				}
			}else{
				return data;
			}
		}else{
			return a;
		}
	};
	dg_options.onLoadError=function(){
		alert("错误：-1  \n您操作太快了。\n也可能是未知原因，请联系开发者检查原因：(IT部)张顺、黄光辉。\n也可能是您还未登录。");
	};
	var sst=stylesheet();
	if(sst){
		dg_options.columns=sst;
	}
	$('#dg').datagrid(dg_options);
	console.log(dg_options);
	//-------------张顺，2017-6-29，第一次进入页面不加载数据（结束）-----------------------------
});
</script>
<jsp:include page="/WEB-INF/jsp/part/hintModal.jsp"></jsp:include>