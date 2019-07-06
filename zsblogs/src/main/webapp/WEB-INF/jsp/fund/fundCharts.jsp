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
    
	    //alert("浏览器分辨率是"+document.documentElement.clientWidth+"*"+document.documentElement.clientHeight );  
	    //alert("屏幕分辨率是"+window.screen.width+"*"+window.screen.height);  
    
    	var maxtotal=99999;//最大条数，尝试获取所有
   		// 基于准备好的dom，初始化echarts实例
   		var myChart;
   		// 指定图表的配置项和数据
   		var option = {
   		    color:['#0080C0','#F90000','rgba(255, 102, 0, 0.56)','#800000','#800080'],
   		    yAxis:{
   		    	type: 'value',
   		    	axisLabel:{
   		    		formatter:'{value}%'
   		    	}
   		    },
   		    legend: {
   		    	top: 60,
   		        data:['净值变化率','收益率','指数收益率']
   		    },
   		 	grid: {
   		 		top: 100 
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
           					left: 'center',
           					textStyle:{
           						fontWeight:'normal',
           						fontSize:14
           					},
               		        text: data.fundName
               		    };
               		 	option.tooltip={
            		    	trigger: 'axis',
            		    	formatter:function(params,ticket,callback){
            		    		console.log(params);
            		    		var str="";
            		    		if (params) {
            		    			str=params[0].axisValue;
								}
            		    		if (params) {
									$.each(params,function(ind,ite){
										if (ite.seriesName=="收益率") {
											str=str+"<br><div class='biaodian' style='background-color:"+ite.color+";'></div>"+ite.seriesName+"："+ite.data+"%（同比:"+data.yRate3[ite.dataIndex]+"%）";
										}else{
											str=str+"<br><div class='biaodian' style='background-color:"+ite.color+";'></div>"+ite.seriesName+"："+ite.data+"%";
										}
									});
								}
            		    		return str;
            		    	}
            		    };
            			option.xAxis={
           					type:'category',
             			    data:data.xTime
           				};
            			var arr1=new Array();
            			$.each(data.marks,function(i,v){
							arr1[i]={
								coord:[v.time,v.dou1],
								value:v.str1,
								symbol:v.str3,
								label:{
									color:v.str2
								},
								itemStyle:{
									color:v.str2
								}
							};            				
            			});
            			option.series=[
            		    	{
        	    		        name: '净值变化率',
        	    		        type: 'bar',
        	    		        smooth: false,
        	    		        data: data.yRate1
            		    	},
            		    	{
        	    		        name: '收益率',
        	    		        type: 'line',
        	    		        smooth: false,
        	    		        data: data.yRate2,
        	    		        markPoint:{
        	    		        	symbolSize:15,
        	    		        	label:{
        	    		        		offset:[0,-15],
        	    		        		formatter: function(param){
	        	    		        		return param.value;
	        	    		        	},
	        	    		        	fontWeight:'bold'
            		    			},
        	    		        	data:arr1
        	    		        }
            		    	},
            		    	{
        	    		        name: '指数收益率',
        	    		        type: 'line',
        	    		        smooth: false,
        	    		        data: data.yRateJs
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
    	function zhedieOrZhankai(){
    		var a=$("#search").attr("isZhedie");
    		if (a) {
	    		$("#search").show();
	    		$("#search").removeAttr("isZhedie");
			}else{
				$("#search").hide();
				$("#search").attr("isZhedie","zhedie");
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
	.biaodian{
		float:left;
		width: 10px;
        height: 10px;
        border-radius: 5px;
        margin-top: 6px;
        margin-right: 4px;
	}
	#main{
		width: 100%;
		height:80%;
		min-width:620px;
		min-height:360px;
		background-color: #FFB786;
	}
	</style>
  </head>
  
  <body style="padding: 0px;margin: 0px;">
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/top_part.jsp"/>
  	<div class="p_body">
  		
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
			<a class="easyui-linkbutton" iconCls="icon-sum" onclick="zhedieOrZhankai()">折叠/展开</a>
			<div class="pull-away"></div>
	  		
			<div id="main"></div>
  		</div>
  			
	</div>
  	<jsp:include page="/WEB-INF/jsp/part/bottom_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/right_part.jsp"/>
  </body>
</html>
