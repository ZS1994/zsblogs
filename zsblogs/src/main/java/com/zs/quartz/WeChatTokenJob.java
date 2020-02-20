package com.zs.quartz;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import com.zs.tools.CrawlerNo1;
import com.zs.tools.SpringUtil;
import com.zs.tools.WeChatConstans;


/**
 * 2020-1-30
 * @author 张顺
 * 定时获取公众号的token
 * 
 */
public class WeChatTokenJob implements Job{

	private WeChatConstans weChatConstans;
	
	
	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		
		if (weChatConstans == null) {
			weChatConstans = (WeChatConstans) SpringUtil.getBean("weChatConstans");
		}
		try {
			weChatConstans.refreshToken();
		} catch (Exception e) {
			e.printStackTrace();
		};
	}

	
	
	

}
