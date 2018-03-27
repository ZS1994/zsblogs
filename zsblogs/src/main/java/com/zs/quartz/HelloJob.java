package com.zs.quartz;

import java.util.Date;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HelloJob implements Job{

	private static Logger log = LoggerFactory.getLogger(HelloJob.class);
	
	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		log.info("HelloJob调度工作报时：" + new Date().toLocaleString());
	}

}
