package com.zs.controller.rest;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.StringUtils;
import org.quartz.CronTrigger;
import org.quartz.JobDataMap;
import org.quartz.JobDetail;
import org.quartz.JobKey;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import org.quartz.TriggerKey;
import org.quartz.impl.matchers.GroupMatcher;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.alibaba.fastjson.JSONObject;
import com.zs.controller.rest.BaseRestController.Code;
import com.zs.entity.other.JobEntity;
import com.zs.entity.other.Result;
import com.zs.service.QuartzSer;
import com.zs.tools.Trans;

@RestController
@RequestMapping("/api/quartz")
public class QuartzConR {

	@Resource
	private Scheduler scheduler;
	@Resource
	private QuartzSer quartzSer;
	
	
	/**
	 * 新增job
	 * 
	 * @return
	 * @throws SchedulerException
	 * @throws ClassNotFoundException 
	 */
	@RequestMapping(value="/add",method=RequestMethod.POST)
	public Result<String> add(HttpServletRequest request,HttpServletResponse response) throws SchedulerException, ClassNotFoundException {
		String jobName = request.getParameter("jobName");
		String jobGroupName = request.getParameter("jobGroupName");
		String triggerName = request.getParameter("triggerName");
		String triggerGroupName = request.getParameter("triggerGroupName");
		String clazz = request.getParameter("clazz");
		Class cls = Class.forName(clazz);
		String cron = request.getParameter("cron");
		quartzSer.addJob(jobName, jobGroupName, triggerName, triggerGroupName, cls, cron);
		return new Result<String>(BaseRestController.SUCCESS,Code.SUCCESS,"添加任务成功!");
	}
	
	
	/**
	 * 编辑job
	 * 
	 * @return
	 * @throws SchedulerException
	 * @throws ClassNotFoundException
	 */
	@RequestMapping(value="/edit",method=RequestMethod.POST)
	public Result<String> edit(HttpServletRequest request,HttpServletResponse response){
		try {
			String msg="";
			String jobName = request.getParameter("jobName");
			String jobGroupName = request.getParameter("jobGroupName");
			String triggerName = request.getParameter("triggerName");
			String triggerGroupName = request.getParameter("triggerGroupName");
			String clazz = request.getParameter("clazz");
			Class cls = Class.forName(clazz);
			String cron = request.getParameter("cron");
			String oldjobName = request.getParameter("oldjobName");
			String oldjobGroup = request.getParameter("oldjobGroup");
			String oldtriggerName = request.getParameter("oldtriggerName");
			String oldtriggerGroup = request.getParameter("oldtriggerGroup");
			boolean result = quartzSer.modifyJobTime(oldjobName, oldjobGroup, oldtriggerName, oldtriggerGroup, 
					jobName, jobGroupName, triggerName, triggerGroupName, cron);
			if(result){
				msg="修改任务成功!";
			}else{
				msg="修改任务失败!";
			}
			return new Result<String>(BaseRestController.SUCCESS,Code.SUCCESS,msg);
		} catch (Exception e) {
			return new Result<String>(BaseRestController.SUCCESS,Code.SUCCESS,Trans.strToHtml(e,request));
		}
	}

	@RequestMapping(value="/pauseJob",method=RequestMethod.POST)
	public Result<String> pauseJob(@RequestParam("jobName") String jobName,@RequestParam("jobGroupName") String jobGroupName){
		JSONObject json = new JSONObject();
		String status="";
		if(StringUtils.isEmpty(jobName) || StringUtils.isEmpty(jobGroupName)){
			status="wrong";
		}else{
			quartzSer.pauseJob(jobName, jobGroupName);
			status="success";
		}
		return new Result<String>(BaseRestController.SUCCESS,Code.SUCCESS,status);
	}
	
	@RequestMapping(value="/resumeJob",method=RequestMethod.POST)
	public Result<String> resumeJob(@RequestParam("jobName") String jobName,@RequestParam("jobGroupName") String jobGroupName){
		JSONObject json = new JSONObject();
		String status="";
		if(StringUtils.isEmpty(jobName) || StringUtils.isEmpty(jobGroupName)){
			status="wrong";
		}else{
			quartzSer.resumeJob(jobName, jobGroupName);
			status="success";
		}
		return new Result<String>(BaseRestController.SUCCESS,Code.SUCCESS,status);
	}
	
	@RequestMapping(value="/deleteJob",method=RequestMethod.POST)
	public Result<String> deleteJob(@RequestParam("jobName") String jobName,@RequestParam("jobGroupName") String jobGroupName,
			@RequestParam("triggerName") String triggerName,@RequestParam("triggerGroupName") String triggerGroupName ){
		JSONObject json = new JSONObject();
		String status="";
		if(StringUtils.isEmpty(jobName) || StringUtils.isEmpty(jobGroupName) || 
				StringUtils.isEmpty(triggerName) || StringUtils.isEmpty(triggerGroupName) ){
			status="wrong";
		}else{
			 quartzSer.removeJob(jobName, jobGroupName, triggerName, triggerGroupName);
			 status="success";
		}
		return new Result<String>(BaseRestController.SUCCESS,Code.SUCCESS,status);
	}
	
	
	
}
