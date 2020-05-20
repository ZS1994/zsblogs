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
		
		//计算总计金额
		$("#doSelectGoods").datagrid({
			onLoadSuccess:function(data){
				console.log(data);
				var result = 0;
				for (var i = 0; i < data.rows.length; i++) {
					result = (parseFloat(result) + parseFloat(data.rows[i].addMoney)).toFixed(2);
				}
				$("#allMoney").val(result);
			}
		});
	});
	
	//获得选择的商品
	function getSelectGoods() {
		var rows = $('#dgGoods').datagrid('getSelections');
		//增加3个信息的属性：数量，值为1;另一个是是否添加的标志，默认false;合计价格=单价*1
		for (var j = 0; j < rows.length; j++) {
			rows[j].purchaseQuantity = parseFloat(1).toFixed(2);
			rows[j].isAdd = false;
			rows[j].addMoney = (parseFloat(rows[j].purchaseQuantity) * parseFloat(rows[j].unitPrice)).toFixed(2);
			rows[j].gId = rows[j].id;
		}
		//得到原来已添加的数据，然后组合成一个新的
		var oldArr =  $("#doSelectGoods").datagrid('getData');
		
		console.log(rows);
		console.log(oldArr);
		for (var i = 0; i < oldArr.rows.length; i++) {
			//判断是否重复，如果重复就把数量+1，否则就增加一行
			for (var k = 0; k < rows.length; k++) {
				if (oldArr.rows[i].id == rows[k].id){
					oldArr.rows[i].purchaseQuantity = (parseFloat(oldArr.rows[i].purchaseQuantity) + 1).toFixed(2);
					oldArr.rows[i].addMoney = (parseFloat(oldArr.rows[i].purchaseQuantity) * parseFloat(oldArr.rows[i].unitPrice)).toFixed(2);
					rows[k].isAdd = true;
				}
			}
		}
		//再次检查是否有遗漏，当表单表格没有，而选择表格有，那么就会出现遗漏
		for (var h = 0; h < rows.length; h++) {
			if (rows[h].isAdd == false) {
				oldArr.rows.push(JSON.parse(JSON.stringify(rows[h])));
			}
		}
		//如果是第一次，那么特殊处理
		if (oldArr.rows.length == 0){
			//json互转一次，相当于克隆，防止互相影响
			for (var h = 0; h < rows.length; h++) {
				oldArr.rows.push(JSON.parse(JSON.stringify(rows[h])));
			}
		}
		$("#doSelectGoods").datagrid('loadData', oldArr.rows);
		$('#dlgGoods').dialog('close');
    }
	//删除选中的商品
	function deleteSelectGoods(){
		$.messager.confirm('警告', '请确认是否删除所选中的商品', function(r){
			if (r == true){
				var rows = $('#doSelectGoods').datagrid('getSelections');
				var oldArr = $('#doSelectGoods').datagrid('getData');
				for (var i = 0; i < oldArr.rows.length; i++) {
					for (var j = 0; j < rows.length; j++) {
						if (oldArr.rows[i].id == rows[j].id) {
							oldArr.rows.splice(i, 1);
						}
					}
				}
				$("#doSelectGoods").datagrid('loadData', oldArr.rows);
			}
		});
	}
	//商品选择的查询
	function goods_search_toolbar(){
		var f=$('#goods_search');
		if(f.form('validate')){
			isDgInit=true;
			var json=formToJson(f);
			$('#dgGoods').datagrid('load', json);
		}
	}
	//重写save函数
	function save(){
		var formData = formToJson($("#fm"));
		var traDetList = $('#doSelectGoods').datagrid('getData').rows;
		formData.traDets = traDetList;
		//验证表单输入
		if($("#fm").form('validate') && validate_zs($("#fm")) && traDetList.length != 0){
			pullRequest({
				urlb:"/api/familyshop/transaction",
				type:"post",
				async:false,
                contentType:"application/json",
				data:JSON.stringify(formData),
				success:function(data){
                    $('#dg').datagrid('reload');
                    $("#dlg").dialog("close");
				}
			});
		}
	}
	//打开还款窗口
    function repayment(){
        var rows = $("#dg").datagrid("getSelections");
        if (rows.length != 1){
            alert("请先选中一条交易单");
            return;
        }
        $("#dlgRepay").dialog("open");
        $("#fmRepay").form("load",rows[0]);
        //填充购买的商品信息
		var traDets = rows[0].traDets;
		console.log(traDets);
        $("#doSelectGoodsReplay").datagrid("loadData",traDets);
	}
	//提交还款
	function submitRepayment(){
        var formData = formToJson($("#fmRepay"));
        var traDetList = $('#doSelectGoodsReplay').datagrid('getData').rows;
        formData.traDets = traDetList;
        //验证表单输入
		if (!(parseFloat($("#newPayMoney").val()) <= parseFloat($("#creditMoney").val()) && parseFloat($("#newPayMoney").val()) > 0)){
            $.messager.alert("警告", "本次付款金额的范围在0~剩余赊账金额之间，请检查你的输入", "warning", function(data){});
            return;
		}
        if($("#fmRepay").form('validate') && validate_zs($("#fmRepay")) && traDetList.length != 0){
            pullRequest({
                urlb:"/api/familyshop/transaction",
                type:"put",
                async:false,
                contentType:"application/json",
                data:JSON.stringify(formData),
                success:function(data){
                    $('#dg').datagrid('reload');
                    $("#dlgRepay").dialog("close");
                }
            });
        }
	}

	//调整数量
	function doPurchaseQuantityUpdate(value,row,index){
        return "<span style='text-decoration: underline;color: blue;' onclick='reloadSelectGoods("+ index +")'>调整</span>";
	}

	//配合上一个函数使用
	function reloadSelectGoods(indexRow){
        var oldArr =  $("#doSelectGoods").datagrid('getData');

		$.messager.prompt("购买数量", "请输入你需要修改为的购买数量", function(val){
		    if(val){
		        var isAccess = false;

				var reg = /^[0-9]+.?[0-9]*$/;
                if (reg.test(val)) {
                    isAccess = true;
                }

				if(isAccess == true){
                    console.log(val);
                    oldArr.rows[indexRow].purchaseQuantity = parseFloat(val).toFixed(2);
                    oldArr.rows[indexRow].addMoney = (parseFloat(val) * parseFloat(oldArr.rows[indexRow].unitPrice)).toFixed(2);
                    console.log(oldArr.rows);
                    $("#doSelectGoods").datagrid("loadData",oldArr.rows);
                }
			}
		});
	}
	function gotoBill(){
        rows = $("#dg").datagrid("getSelections");
        if(!rows || rows.length != 1){
            $.messager.alert("警告", "请先选中一个交易单", "warning", function () {
            });
			return;
		}
        var traId = rows[0].id;
        window.open("${path}/menu/familyshop/bill?int1=1&str4=" + traId);
	}
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
						<th field="state" width="100" sortable="true" data-options="formatter:function(val,row){
							if(val == 'full payment'){
								return '全额付款';
							}else if(val == 'credit'){
								return '赊账';
							}else{
								return val;
							}
						}">付款方式</th>
						<th field="amountMoney" width="100" sortable="false">应付金额（元）</th>
						<th field="payMoney" width="100" sortable="false">实付金额（元）</th>
						<th field="creditMoney" width="100" sortable="false" data-options="formatter:function(val,row){
							if(val > 0){
								return '<span style=\'color:red;\'>' + val + '</span>';
							}else{
								return val;
							}
						}">赊账金额（元）</th>
						<th field="traDets" width="400" sortable="false" data-options="formatter:function(val,row){
							if(val){
								var resVal = '';
								for(var i=0;i<val.length;i++){
									var qunit = val[i].quantityUnit;
									resVal += val[i].name + '(' + val[i].quantity + qunit.substring(qunit.indexOf('/')+1,qunit.length) + ')' + '    ';
								}
								return resVal;
							}else{
								return val;
							}
						}">购买的商品概况</th>
						<th field="note" width="300" sortable="false">备注</th>
					</tr>
				</thead>
			</table>
		<div id="toolbar">
				<div class="btn-separator-none">
					<a class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addObj()">添加交易单</a>
					<a class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="repayment()">还款</a>
					<a class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteObj()">删除交易单</a>
					<a class="easyui-linkbutton" iconCls="icon-zs-forward" plain="true" onclick="gotoBill()">查看该交易单的账单</a>
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
					<div class="searchBar-input">
						<div>
							交易单编号：<input name ="str3" />
						</div>
						<div>
							只查未付清：<input name ="int1" />
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
							<label>顾客:</label>
							<input name="customer" class="easyui-validatebox" required="true">
						</div>
						<div style="height: 200px;">
							<label>商品明细:</label>
							<table id="doSelectGoods" border="false" class="easyui-datagrid"
								   loadMsg="数据加载中请稍后……"
								   striped="true" toolbar="#doSelectGoods-toolbar"
								   rownumbers="true" fitColumns="false"
								   singleSelect="false" fit="true">
								<thead>
								<tr>
									<th field="id" width="150" hidden="true">ID</th>
									<th field="name" width="150" sortable="false">货品名称</th>
									<th field="unitPrice" width="100" sortable="false">单价(元)</th>
									<th field="purchaseQuantity" width="100">购买数量</th>
									<th field="purchaseQuantityUpdate" width="100" formatter="doPurchaseQuantityUpdate">调整数量</th>
									<th field="addMoney" width="100" sortable="false">合计(元)</th>
								</tr>
								</thead>
							</table>
							<div id="doSelectGoods-toolbar">
								<div class="btn-separator-none">
									<a class="easyui-linkbutton" iconCls="icon-add" plain="true"
									   onclick="javascript:$('#dlgGoods').dialog('open');$('#dgGoods').datagrid('reload');">添加货品</a>
								   <a class="easyui-linkbutton" iconCls="icon-add" plain="true"
								   	   onclick="deleteSelectGoods()">删除货品</a>
								</div>
							</div>
						</div>
						<div class="fitem">
							<label>备注:</label>
							<input name="note" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>付款方式:</label>
							<select name="state">
								<option value="full payment">全额付款</option>
								<option value="credit ">赊账</option>
							</select>
						</div>
						<div class="fitem">
							<label>总金额:</label>
							<input id="allMoney" name="allMoney" readonly="readonly" class="easyui-validatebox" required="true">
						</div>
					</form>
				</div>
			</div>
			<div id="dlg-buttons">
				<a class="easyui-linkbutton" iconCls="icon-ok" onclick="save()">提交</a>
				<a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">取消</a>
			</div>
  			
  			
  			<!-- 选择商品的窗口 -->
			<div id="dlgGoods" title="货品信息" class="easyui-dialog" style="width:90%;height:50%;" closed="true" resizable="true" buttons="#dlgGoods-buttons" modal="true">
				<table id="dgGoods" border="false" class="easyui-datagrid"
					   url="<%=path %>/api/familyshop/goods/list"
					   method="get" toolbar="#dgGoods-toolbar"
					   loadMsg="数据加载中请稍后……"
					   striped="true" pagination="true"
					   rownumbers="true" fitColumns="false"
					   singleSelect="false" fit="true"
					   pageSize="100" pageList="[100,500,1000,5000]">
					<thead>
					<tr>
						<th field="id" width="150" hidden="true">ID</th>
						<th field="name" width="150" sortable="true">货品名称</th>
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
				<div id="dgGoods-toolbar">
					<form id="goods_search">
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
					<a class="easyui-linkbutton" iconCls="icon-search" onclick="goods_search_toolbar()">查询</a>
				</div>
			</div>
			<div id="dlgGoods-buttons">
				<a class="easyui-linkbutton" iconCls="icon-ok" onclick="getSelectGoods()">选择</a>
				<a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgGoods').dialog('close')">取消</a>
			</div>

			<!-- 还款的窗口 -->
			<div id="dlgRepay" class="easyui-dialog" title="还款"
				 closed="true" buttons="#dlg-buttons-repay" modal="true">
				<div class="dlg_widthAndHeight">
					<div class="ftitle">交易单</div>
					<hr>
					<form id="fmRepay" method="post" >
						<input type="hidden" name="_method" value="post"/>
						<input type="hidden" name="_token" value="${token}"/>
						<input type="hidden" name="id"/>
						<div class="fitem">
							<label>顾客:</label>
							<input name="customer" readonly="readonly">
						</div>
						<div style="height: 200px;">
							<label>商品明细:</label>
							<table id="doSelectGoodsReplay" border="false" class="easyui-datagrid"
								   loadMsg="数据加载中请稍后……"
								   striped="true"
								   rownumbers="true" fitColumns="false"
								   singleSelect="false" fit="true">
								<thead>
								<tr>
									<th field="gId" width="150" hidden="true">货品编号</th>
									<th field="name" width="150" sortable="false">货品名称</th>
									<th field="unitPrice" width="100" sortable="false">单价(元)</th>
									<th field="quantity" width="100" sortable="false">购买数量</th>
									<th field="addMoney" width="100" sortable="false">合计(元)</th>
								</tr>
								</thead>
							</table>
						</div>
						<div class="fitem">
							<label>备注:</label>
							<input name="note" class="easyui-validatebox" required="true">
						</div>
						<div class="fitem">
							<label>总计应付金额:</label>
							<input name="amountMoney" readonly="readonly">
						</div>
						<div class="fitem">
							<label>已付金额:</label>
							<input name="payMoney" readonly="readonly">
						</div>
						<div class="fitem">
							<label>剩余赊账金额:</label>
							<input id="creditMoney" name="creditMoney" readonly="readonly">
						</div>
						<div class="fitem">
							<label>本次还款金额:</label>
							<input id="newPayMoney" name="newPayMoney" type="number" class="easyui-validatebox" required="true">
						</div>
					</form>
				</div>
			</div>
			<div id="dlg-buttons-repay">
				<a class="easyui-linkbutton" iconCls="icon-ok" onclick="submitRepayment()">提交</a>
				<a class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlgRepay').dialog('close')">取消</a>
			</div>
  		</div>
  	<jsp:include page="/WEB-INF/jsp/part/bottom_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/right_part.jsp"/>
  </body>
</html>
