<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>新增任务</title>
    <jsp:include page="/WEB-INF/jsp/part/include_bootstrap.jsp"/>
    <script type="text/javascript">
    function cancle(){
    	history.go(-1);
    }
    function save(){
    	$.ajax({
    		url:"${path}/api/quartz/add",
    		type:"POST",
    		data:formToJson($("#ff")),
    		success:function(data){
				alert(data.data);    			
				window.location.href="${path }/menu/quartz/listJob";
    		}
    	});
    }
    </script>
    <style type="text/css">
    </style>
</head>
  
<body>
	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
	<jsp:include page="/WEB-INF/jsp/part/top_part.jsp"/>
  	<div class="p_body">
		<div class="body_top_jiange"></div>	
  		<div class="container" style="width: 90%;">
  			<center>
				<form id="ff">
					<h2>新增Trigger</h2>
					<hr/>
				  	<table id="table_report" class="table table-striped table-bordered table-hover" style="width: 600px;">
						<tr>
							<td>时间表达式（cron）</td>
							<td><input type="text" name="cron" value=""/></td>
						</tr>
						<tr>
							<td>任务类名（clazz）</td>
							<td><input type="text" name="clazz" value=""/></td>
						</tr>
						<tr>
							<td>定时任务名称（jobName）</td><td><input type="text" name="jobName" value=""/></td>
						</tr>
						<tr>
							<td>任务组名称（jobGroup）</td><td><input type="text" name="jobGroupName" value=""/></td>
						</tr>
						<tr>
					 		<td>触发器名称（triggerName）</td><td><input type="text" name="triggerName" value=""/></td>
						</tr>
						<tr>
					 		<td>触发器组名称（triggerGroupName）</td><td><input type="text" name="triggerGroupName" value=""/></td>
						</tr>
						<tr>
							<td></td>
							<td>
								<a class="btn btn-success" onclick="save()">提交</a>
								<a class="btn" onclick="cancle()">返回</a>
				   			</td>
				    	</tr>
					</table>
				</form>
			</center>
  			
  		</div>
	</div>
	<jsp:include page="/WEB-INF/jsp/part/bottom_part.jsp"/>
  	<jsp:include page="/WEB-INF/jsp/part/right_part.jsp"/>
</body>
</html>

