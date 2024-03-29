package com.zs.quartz;

import javax.annotation.Resource;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.Scheduler;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Component;

import com.zs.tools.CacheCharts;
import com.zs.tools.SpringUtil;


/**
 * 2020-1-14
 * @author 张顺
 * 爬虫的定时器，爬虫之前是用多线程写的无限循环的任务，通过sleep延时来达到定时执行任务的效果。
 * 但是实装服务器后发现，内存消耗严重，经过多次调试优化代码以及服务器的配置最终依然没有办法，
 * 猜测是因为无限循环的线程会使内存无法回收，导致内存消耗无限增大，最终导致服务器触发内存保护机制，杀死消耗最大的进程（tomcat）。
 * 所以，这次使用quartz，因为它十分成熟，有完善的内存管理机制，所以尝试使用它来实现爬虫的定时任务，待日后观察内存使用情况，是否问题解决。
 * 
 */
public class CrawJob implements Job{

	private CacheCharts cacheCharts;
	
	
	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		
		if (cacheCharts == null) {
			cacheCharts = (CacheCharts) SpringUtil.getBean("cacheCharts");
		}
		
		cacheCharts.refresh();
		
		
	}

	
	
	

}
