<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>任务列表</title>
	<jsp:include page="/WEB-INF/jsp/part/include_bootstrap.jsp"/>
	<script type="text/javascript">
		var url = "${pageContext.request.contextPath}";
		function add(){
			window.location.href = url + "/menu/quartz/toAdd";
		}
		
		function edit(jobName,jobGroup){
			window.location.href = url + "/menu/quartz/toEdit?jobName="+jobName+"&jobGroup="+jobGroup;
		}
		//暂停任务
		function pauseJob(jobName,jobGroupName){
			$.post(url + "/api/quartz/pauseJob",{"jobName":jobName,"jobGroupName":jobGroupName},function(data){
				if(data.data = 'success'){
					window.location.href = window.location.href;
				}else{
					alert("操作失败，请刷新重新！");
				}
			});
		}
		//恢复任务
		function resumeJob(jobName,jobGroupName){
			$.post(url + "/api/quartz/resumeJob",{"jobName":jobName,"jobGroupName":jobGroupName},function(data){
				if(data.data = 'success'){
					window.location.href = window.location.href;
				}else{
					alert("操作失败，请刷新重新！");
				}
			});
		}
		//删除
		function deleteJob(jobName,jobGroupName,triggerName,triggerGroupName){
			$.post(url + "/api/quartz/deleteJob",{"jobName":jobName,"jobGroupName":jobGroupName,"triggerName":triggerName,"triggerGroupName":triggerGroupName},
					function(data){
				if(data.data = 'success'){
					window.location.href = window.location.href;
				}else{
					alert("操作失败，请刷新重新！");
				}
			});
		}
		/* //执行任务
		function triggerJob(a,b){
			var url = "triggerJob";
			var d = {jobName:a,jobGroupName:b};
			$.post(url,d,function(data){
				if(data.data = 'ok'){
					window.location.href = window.location.href;
				}
			});
		} */
	</script>
	<style type="text/css">
	</style>
</head>
  
<body>
<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body">
		<div class="body_top_jiange"></div>
  		<div class="container" style="width: 90%;">
			<h2 style="text-align: center;">任务列表</h2>
			<table id="table_report" class="table table-striped table-bordered table-hover">
				<thead>
	                <tr>
                    <!-- th>序号</th-->
					<th>任务组名称</th>
					<th>定时任务名称</th>
					<!-- <th>触发器组名称</th>
					<th>触发器名称</th> -->
					<th>时间表达式</th>
					<th>上次运行时间</th>
					<th>下次运行时间</th>
					<th>任务状态</th>
					<!-- <th>已经运行时间</th> -->
					<!-- <th>持续运行时间</th> -->
					<th>开始时间</th>
					<th>结束时间</th>
					<th>任务类名</th>
					<!-- <th>方法名称</th> -->
					<!-- <th>jobObject</th> -->
					<!-- <th>运行次数</th> -->
					<th width="15%">操作</th>
	             </tr>
	         	</thead>
             	<tbody>
					<!-- 开始循环 -->
					<c:choose>
                    	<c:when test="${not empty jobInfos && jobInfos.size()>0}">
                        	<c:forEach items="${jobInfos}" var="var" varStatus="vs">
                            	<tr>
                                	<td>${var.jobGroup}</td>
	                                <td>${var.jobName}</td>
	                                <%-- <td>${var.triggerGroupName}</td>
	                                <td>${var.triggerName}</td> --%>
	                                <td>${var.cronExpr}</td>
	                                <td><fmt:formatDate value="${var.previousFireTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	                                <td><fmt:formatDate value="${var.nextFireTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
	                                <td>
	                                    <c:if test="${var.jobStatus == 'NONE'}">
	                                    	<span class="label">未知</span>
	                                    </c:if>
	                                    <c:if test="${var.jobStatus == 'NORMAL'}">
	                                       <span class="label label-success arrowed">正常运行</span>
	                                    </c:if>
	                                    <c:if test="${var.jobStatus == 'PAUSED'}">
	                                       <span class="label label-warning">暂停状态</span>
	                                    </c:if>
	                                    <c:if test="${var.jobStatus == 'COMPLETE'}">
	                                       <span class="label label-important arrowed-in">完成状态</span>
	                                    </c:if>
	                                    <c:if test="${var.jobStatus == 'ERROR'}">
	                                       <span class="label label-info arrowed-in-right arrowed">错误状态</span>
	                                    </c:if>
	                                    <c:if test="${var.jobStatus == 'BLOCKED'}">
	                                       <span class="label label-inverse">锁定状态</span>
	                                    </c:if>
                                  	</td>
									<%-- <td>${var.runTimes}</td> --%>
									<%-- <td>${var.duration}</td> --%>
                                  	<td><fmt:formatDate value="${var.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                              	 	<td><fmt:formatDate value="${var.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                  	<td>${var.jobClass}</td>
									<%-- <td>${var.jobMethod}</td> --%>
									<%-- <td>${var.jobObject}</td> --%>
									<%-- <td>${var.count}</td> --%>
                               	 	<td>
										<%-- <a class="btn btn-minier btn-info" onclick="triggerJob('${var.jobName}','${var.jobGroup}');"><i class="icon-edit"></i>运行</a> --%>
										<a class="btn btn-minier btn-success" onclick="edit('${var.jobName}','${var.jobGroup}');"><i class="icon-edit"></i>编辑</a>
										<a class="btn btn-minier btn-warning" onclick="pauseJob('${var.jobName}','${var.jobGroup}');"><i class="icon-edit"></i>暂停</a>
										<a class="btn btn-minier btn-purple" onclick="resumeJob('${var.jobName}','${var.jobGroup}');"><i class="icon-edit"></i>恢复</a>
										<a class="btn btn-minier btn-danger" onclick="deleteJob('${var.jobName}','${var.jobGroup}','${var.triggerName}','${var.triggerGroupName}');"><i class="icon-edit"></i>删除</a>
                                  	</td>
                              	</tr>
                          	</c:forEach>
                      	</c:when>
                      	<c:otherwise>
                           <tr class="main_info">
                               <td colspan="100">没有相关数据</td>
                           </tr>
                       </c:otherwise>
                   </c:choose>
				</tbody>
			</table>
			
			<div style="width: 90%;margin: 0 auto;text-align: center;margin-top: 25px;">
				<button type="button" onclick="add();" class="btn">新增任务</button>
			</div>
  		
  		</div>
	</div>
</body>
</html>
