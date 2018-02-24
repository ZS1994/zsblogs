<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>图表统计</title>
    <jsp:include page="/WEB-INF/jsp/part/common.jsp"/>
    <script type="text/javascript" src="${path }/framework/ECharts/echarts.js"></script>
    <script type="text/javascript">
    	var maxtotal=99999;//最大条数，尝试获取所有
   		// 基于准备好的dom，初始化echarts实例
   		var myChart;
   		// 指定图表的配置项和数据
   		var option = {
   		    color:['#0080C0','#F90000'],
   		    tooltip:{
   		    	trigger: 'axis',
   		    	formatter:'{b}<br/>{a0}: {c0}%<br/>{a1}: {c1}%'
   		    },
   		    yAxis:{
   		    	type: 'value',
   		    	axisLabel:{
   		    		formatter:'{value}%'
   		    	}
   		    },
   		    legend: {
   		        data:['净值变化率','收益率']
   		    }
   		};
   		$(function(){
   			myChart = echarts.init($("#main")[0]);
   			handleFundAndUser();
   			searchProfit();
   		});
    	function searchProfit(){
    		var dtmp=formToJson($("#search"));
    		if (dtmp && dtmp.date1 && dtmp.date2 && dtmp.str1 && dtmp.int1) {
    			pullRequest({
            		urlb:"/api/fundTrade/profit",
            		type:"POST",
            		data:dtmp,
            		success:function(data){
            			option.title={
           					top:20,
               		        text: data.fundName
               		    },
            			option.xAxis={
           					type:'category',
             			    data:data.xTime
           				};
            			var arr1=new Array();
            			$.each(data.marks,function(i,v){
							arr1[i]={
								coord:[v.time,v.dou1],
								value:v.str1
							};            				
            			});
            			option.series=[
            		    	{
        	    		        name: '净值变化率',
        	    		        type: 'line',
        	    		        smooth: false,
        	    		        color:"",
        	    		        data: data.yRate1
            		    	},
            		    	{
        	    		        name: '收益率',
        	    		        type: 'line',
        	    		        smooth: false,
        	    		        data: data.yRate2,
        	    		        markPoint:{
        	    		        	symbol:'pin',
        	    		        	symbolSize:15,
        	    		        	label:{
        	    		        		offset:[0,-15],
        	    		        		formatter: function(param){
	        	    		        		return param.value;
	        	    		        	},
	        	    		        	color:'auto'
            		    			},
        	    		        	data:arr1
        	    		        }
            		    	}
            		    ];
            			// 使用刚指定的配置项和数据显示图表。
                		myChart.setOption(option);
            		}
            	});
			}
    	}
    	function handleFundAndUser(){
    		pullRequest({
    			urlb:"/api/fundInfo/list",
    			type:"GET",
    			async:false,
    			data:{
    				page:1,
    				rows:maxtotal
    			},
    			superSuccess:function(data){
    				var str="";
    				$.each(data.rows,function(i,v){
    					str=str+"<option value='"+v.id+"'>"+"("+v.id+")"+v.name+"</option>";
    				});
    				$("#str1").append(str);
    			}
    		});
    		pullRequest({
    			urlb:"/api/users/list",
    			type:"GET",
    			async:false,
    			data:{
    				page:1,
    				rows:maxtotal
    			},
    			superSuccess:function(data){
    				var str="";
    				$.each(data.rows,function(i,v){
    					str=str+"<option value='"+v.id+"'>"+v.name+"("+v.usernum+")"+"</option>";
    				});
    				$("#int1").append(str);
    			}
    		});
    		$("#str1").find("option[value = '${accept.str3 }']").attr("selected","selected");
    		$("#int1").find("option[value = '${accept.int1 }']").attr("selected","selected");
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
  	<div class="p_body" style="overflow-y:hidden;">
  		
  		<div style="padding-left: 3px;padding-right: 3px;">
  		
	  		
			<form id="search">
				<div class="searchBar-input">
		    		<div>
			    		时间开始：<input name="date1" id="d4311" class="Wdate" type="text" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'d4312\')}' ,dateFmt:'yyyy/MM/dd'})" value="${accept.str1 }"/>
		    		</div>
		    		<div>
		    			时间结束：<input name="date2" id="d4312" class="Wdate" type="text" onFocus="WdatePicker({minDate:'#F{$dp.$D(\'d4311\')}' ,dateFmt:'yyyy/MM/dd'})" value="${accept.str2 }"/>
		    		</div>
		   		</div>
		   		<div class="searchBar-input">
		    		<div>
			    		基金编号：
			    		<%-- <input name ="str1" value="${accept.str3 }"/> --%>
			    		<select name="str1" id="str1">
			    			<option>--请选择--</option>
			    		</select>
		    		</div>
		    		<div>
		    			用户id：
		    			<%-- <input name ="int1" value="${accept.int1 }"/> --%>
		    			<select name="int1" id="int1">
			    			<option>--请选择--</option>
			    		</select>
		    		</div>
		   		</div>
		   	</form>
		   	<div class="clear"></div>
		   	<hr class="hr-geay">
			<a class="easyui-linkbutton" iconCls="icon-sum" onclick="searchProfit()">查看统计数据</a>
			<div class="pull-away"></div>
	  		
			<div id="main" style="width: 100%;height:80%;background-color: red;"></div>
  		</div>
  			
	</div>
  	
  </body>
</html>
