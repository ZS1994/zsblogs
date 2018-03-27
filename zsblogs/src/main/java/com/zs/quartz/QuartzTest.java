package com.zs.quartz;

import java.util.Date;
import org.quartz.CronScheduleBuilder;
import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.Trigger;
import org.quartz.TriggerBuilder;
import org.quartz.impl.StdSchedulerFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class QuartzTest {
	
	private static Logger _log = LoggerFactory.getLogger(QuartzTest.class);
	
	public static void main(String[] args) throws SchedulerException {
		ApplicationContext ac = new ClassPathXmlApplicationContext("spring_quartz.xml");
		Scheduler scheduler=(Scheduler) ac.getBean("scheduler");
		scheduler.start();
    }
	
}
