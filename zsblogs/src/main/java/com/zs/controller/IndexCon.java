package com.zs.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.quartz.CronTrigger;
import org.quartz.JobDataMap;
import org.quartz.JobDetail;
import org.quartz.JobKey;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import org.quartz.TriggerKey;
import org.quartz.impl.matchers.GroupMatcher;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.zs.dao.FundHistoryMapper;
import com.zs.dao.FundInfoMapper;
import com.zs.entity.FundInfo;
import com.zs.entity.Role;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.JobEntity;
import com.zs.service.QuartzSer;
import com.zs.tools.Constans;

@Controller
@RequestMapping("/menu")
public class IndexCon{
	
	@Resource
	private FundInfoMapper fundInfoMapper;
	@Resource
	private FundHistoryMapper fundHistoryMapper;
	@Resource
	private Scheduler scheduler;
	
	@RequestMapping("/index")
	public String gotoIndex(){
		return "/index";
	}
	
	//----测试、构建项目初期使用----------
	@RequestMapping("/part")
	public String gotoPart(){
		return "/part/left_center";
	}
	
	
	//----博客类-------
	@RequestMapping("/user/blogList")
	public String gotoUserBlogList(){
		return "/blog/blogList";
	}
	//我的博客
	@RequestMapping("/user/blog")
	public String gotoUserBlog(HttpServletRequest req,EasyUIAccept accept){
		req.setAttribute("acc", accept);
		if(accept!=null && accept.getInt2()==null){
			try {
				Users u=Constans.getUserFromReq(req);
				if(u!=null) accept.setInt2(u.getId());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return "/blog/blogOfUser";
	}
	//最新博客，所有博客
	@RequestMapping("/blogList/blog")
	public String gotoBlog(HttpServletRequest req,EasyUIAccept accept){
		req.setAttribute("acc", accept);
		return "/blog/blog";
	}
	//写博客
	@RequestMapping("/blogList/blog/user/edit")
	public String gotoBlogEdit(HttpServletRequest req,String id){
		req.setAttribute("id", id);
		return "/blog/blogEdit";
	}
	
	@RequestMapping("/blogList/blog/one")
	public String gotoBlogMain(String id,HttpServletRequest req){
		req.setAttribute("id", id);
		return "/blog/blogMainInfo";
	}
	
	
	@RequestMapping("/blogList/blog/blogComment")
	public String gotoBlogComment(){
		return "/blog/blogComment";
	}
	
	@RequestMapping("/blogList/blog/read")
	public String gotoRead(String bId,HttpServletRequest req){
		req.setAttribute("bId", bId);
		return "/blog/blogRead";
	}
	
	//----系统功能类-------------
	@RequestMapping("/system/login")
	public String gotoLogin(){
		return "/system/login";
	}
	
	@RequestMapping("/system/permission")
	public String gotoPermission(){
		return "/system/permission";
	}
	
	@RequestMapping("/system/role")
	public String gotoRole(){
		return "/system/role";
	}
	
	@RequestMapping("/system/users")
	public String gotoUsers(){
		return "/system/users";
	}
	
	@RequestMapping("/system/timeline")
	public String gotoTimeLine(){
		return "/system/timeline";
	}
	
	//我的信息
	@RequestMapping("/system/users/own")
	public String gotOwnInfo(HttpServletRequest req,Users user){
		try {
			user=Constans.getUserFromReq(req);
			if(user!=null){
				SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				if(user.getCreateTime()!=null){
					String date=sdf.format(user.getCreateTime());
					req.setAttribute("createTime", date);
				}
				if(user.getRoles()!=null){
					String str="";
					for (Role r : user.getRoles()) {
						str=str+r.getName()+",";
					}
					str=str.substring(0, str.lastIndexOf(","));
					user.setRoleNames(str);
				}
			}
			req.setAttribute("user", user);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "/system/own";
	}
	
	
	//注册一个
	@RequestMapping("/system/users/logup")
	public String gotoLogup(){
		return "/system/logup";
	}
	
	//---爬虫---------------
	@RequestMapping("/crawler/manager")
	public String gotoCrawlerManager(){
		return "/crawler/crawlerManager";
	}
	
	//---api接口文档管理----------------------
	@RequestMapping("/system/apidoc")
	public String gotoApiDocList(){
		return "/system/apiDocList";
	}
	//接口详情
	@RequestMapping("/system/apidoc/info")
	public String gotoApiDocInfo(String id,HttpServletRequest req){
		req.setAttribute("id", id);
		return "/system/apiDocInfo";
	}
	//接口参数
	@RequestMapping("/system/apidoc/param")
	public String gotoApiDocParam(String adId,HttpServletRequest req){
		req.setAttribute("adId", adId);
		return "/system/apiDocParam";
	}
	
	//-----基金管理----------------------------------------
	@RequestMapping("/fund/fundHistory")
	public String gotoFundHistory(){
		return "/fund/fundHistory";
	}
	@RequestMapping("/fund/fundInfo")
	public String gotoFundInfo(){
		return "/fund/fundInfo";
	}
	@RequestMapping("/fund/fundTrade")
	public String gotoFundTrade(String username,HttpServletRequest req){
		Users u=(Users) req.getAttribute(Constans.USER);
		req.setAttribute("username", u.getName());
		return "/fund/fundTrade";
	}
	//图表分析
	@RequestMapping("/fund/fundCharts")
	public String gotoFundCharts(HttpServletRequest req){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
		EasyUIAccept accept=new EasyUIAccept();
		Users u=(Users) req.getAttribute(Constans.USER);
		List<FundInfo> fis=fundInfoMapper.selectAllFundByUser(u.getId());
		String fiId=fis.size()>0?fis.get(0).getId():"110022";//这里传一个基金编号，本想是传该用户持有之一，但是没办法，暂时就传一个固定的
		Date edate=fundHistoryMapper.getEndDate(fiId);
		//这里默认显示最近一个月的数据
		//张顺，2019-7-14，1,一个月数据不直观，改为默认3个月
		accept.setStr2(sdf.format(edate));
		Calendar calendar=Calendar.getInstance();
		calendar.setTime(edate);
		calendar.add(Calendar.MONTH, -3);
		//张顺，2019-7-14，-1
		Date bdate=calendar.getTime();
		accept.setStr1(sdf.format(bdate));
		accept.setInt1(u.getId());
		accept.setStr3(fiId);
		req.setAttribute("accept", accept);
		return "/fund/fundCharts";
	}
	
	
	
	//------------quartz实验室-----------------------------
	private List<JobEntity> getSchedulerJobInfo() throws SchedulerException {
		List<JobEntity> jobInfos = new ArrayList<JobEntity>();
		List<String> triggerGroupNames = scheduler.getTriggerGroupNames();
		for (String triggerGroupName : triggerGroupNames) {
			Set<TriggerKey> triggerKeySet = scheduler
					.getTriggerKeys(GroupMatcher
							.triggerGroupEquals(triggerGroupName));
			for (TriggerKey triggerKey : triggerKeySet) {
				Trigger t = scheduler.getTrigger(triggerKey);
				if (t instanceof CronTrigger) {
					CronTrigger trigger = (CronTrigger) t;
					JobKey jobKey = trigger.getJobKey();
					JobDetail jd = scheduler.getJobDetail(jobKey);
					JobEntity jobInfo = new JobEntity();
					jobInfo.setJobName(jobKey.getName());
					jobInfo.setJobGroup(jobKey.getGroup());
					jobInfo.setTriggerName(triggerKey.getName());
					jobInfo.setTriggerGroupName(triggerKey.getGroup());
					jobInfo.setCronExpr(trigger.getCronExpression());
					jobInfo.setNextFireTime(trigger.getNextFireTime());
					jobInfo.setPreviousFireTime(trigger.getPreviousFireTime());
					jobInfo.setStartTime(trigger.getStartTime());
					jobInfo.setEndTime(trigger.getEndTime());
					jobInfo.setJobClass(jd.getJobClass().getCanonicalName());
					// jobInfo.setDuration(Long.parseLong(jd.getDescription()));
					Trigger.TriggerState triggerState = scheduler
							.getTriggerState(trigger.getKey());
					jobInfo.setJobStatus(triggerState.toString());// NONE无,
																	// NORMAL正常,
																	// PAUSED暂停,
																	// COMPLETE完全,
																	// ERROR错误,
																	// BLOCKED阻塞
					JobDataMap map = scheduler.getJobDetail(jobKey)
							.getJobDataMap();
					if (null!=map && map.size()!=0) {
						jobInfo.setCount(map.get("count")!=null?Integer.parseInt((String)map.get("count")):0);
						jobInfo.setJobDataMap(map);
					} else {
						jobInfo.setJobDataMap(new JobDataMap());
					}
					jobInfos.add(jobInfo);
				}
			}
		}
		return jobInfos;
	}
	
	/**
	 * 定时列表页
	 */
	@RequestMapping(value="/quartz/listJob")
	public String listJob(HttpServletRequest request,HttpServletResponse response) throws SchedulerException {
		List<JobEntity> jobInfos = this.getSchedulerJobInfo();
		request.setAttribute("jobInfos", jobInfos);
		return "/quartz/listjob";
	}
	
	/**
	 * 跳转到新增
	 */
	@RequestMapping(value="/quartz/toAdd")
	public String toAdd(HttpServletRequest request,HttpServletResponse response) throws SchedulerException {
		return "/quartz/addjob";
	}
	
	/**
	 * 跳转到编辑
	 */
	@RequestMapping(value="/quartz/toEdit")
	public String toEdit(HttpServletRequest request,HttpServletResponse response) throws SchedulerException {
		String jobName = request.getParameter("jobName");
		String jobGroup = request.getParameter("jobGroup");
		
		JobKey jobKey = JobKey.jobKey(jobName, jobGroup);
		JobDetail jd = scheduler.getJobDetail(jobKey);
		@SuppressWarnings("unchecked")
		List<CronTrigger> triggers = (List<CronTrigger>) scheduler
				.getTriggersOfJob(jobKey);
		CronTrigger trigger = triggers.get(0);
		TriggerKey triggerKey = trigger.getKey();
		String cron = trigger.getCronExpression();
		Map<String, String> pd = new HashMap<String, String>();
		pd.put("jobName", jobKey.getName());
		pd.put("jobGroup", jobKey.getGroup());
		pd.put("triggerName", triggerKey.getName());
		pd.put("triggerGroupName", triggerKey.getGroup());
		pd.put("cron", cron);
		pd.put("clazz", jd.getJobClass().getCanonicalName());

		request.setAttribute("pd", pd);
		request.setAttribute("msg", "edit");
		
		return "/quartz/editjob";
	}
	
	/**
	 * 跳转到其他菜单
	 * @author 张顺 2019-10-27
	 */
	@RequestMapping(value="/system/otherMenu")
	public String toOtherMenu(HttpServletRequest request,HttpServletResponse response) throws SchedulerException {
		return "/system/otherMenu";
	}
}


