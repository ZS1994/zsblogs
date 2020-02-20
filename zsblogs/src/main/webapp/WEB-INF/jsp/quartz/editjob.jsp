<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>编辑任务</title>
	<jsp:include page="/WEB-INF/jsp/part/include_bootstrap.jsp"/>
	<script type="text/javascript">
	function cancle(){
    	history.go(-1);
    }
	function save(){
    	$.ajax({
    		url:"${path}/api/quartz/edit",
    		type:"POST",
    		data:formToJson($("#ff")),
    		success:function(data){
				window.location.href="${path }/menu/quartz/listJob";
    		}
    	});
    }
	</script>
</head>
  
<body>
	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
	<jsp:include page="/WEB-INF/jsp/part/top_part.jsp"/>
  	<div class="p_body">
		<div class="body_top_jiange"></div>	
  		<div class="container" style="width: 90%;">
			<center>
				<form id="ff">
					<input type="hidden" name="oldjobName" value="${pd.jobName}" >
					<input type="hidden" name="oldjobGroup" value="${pd.jobGroup}" >
					<input type="hidden" name="oldtriggerName" value="${pd.triggerName}" >
					<input type="hidden" name="oldtriggerGroup" value="${pd.triggerGroupName}" >
					<h2>编辑Trigger</h2>
					<hr/>
					<table id="table_report" class="table table-striped table-bordered table-hover" style="width: 600px;">
						<tr>
							<td>时间表达式（cron）</td>
							<td><input type="text" name="cron" value="${pd.cron}"/></td>
						</tr>
						<tr>
							<td>任务类名（clazz）</td>
							<td>
								<select name="clazz" value="${pd.clazz}">
									<option value="com.zs.quartz.CacheJob">缓存刷新任务</option>
									<option value="com.zs.quartz.Craw1Job">爬虫1号爬取博客任务</option>
									<option value="com.zs.quartz.Craw2Job">爬虫2号爬取基金历史净值任务</option>
									<option value="com.zs.quartz.Craw3Job">爬虫3号爬取基金列表任务</option>
									<option value="com.zs.quartz.HelloJob">定时器测试任务（周期打印时间）</option>
									<option value="com.zs.quartz.WeChatTokenJob">获取微信公众号token任务</option>
									<option value="com.zs.quartz.WeChatAddNewsJob">微信公众号自动上传博客任务</option>
									<option value="com.zs.quartz.WeChatDelAllNewsJob">微信公众号删除所有素材任务</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>定时任务名称（jobName）</td>
							<td><input type="text" name="jobName" value="${pd.jobName}"/></td>
						</tr>
						<tr>
							<td>任务组名称（jobGroup）</td>
							<td><input type="text" name="jobGroupName" value="${pd.jobGroup}"/></td>
						</tr>
						<tr>
							<td>触发器名称（triggerName）</td>
							<td><input type="text" name="triggerName" value="${pd.triggerName}"/></td>
						</tr>
						<tr>
							<td>触发器组名称（triggerGroupName）</td>
							<td><input type="text" name="triggerGroupName" value="${pd.triggerGroupName}"/></td>
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
