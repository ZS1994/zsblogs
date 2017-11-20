package com.zs.listener;


import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;

import com.zs.service.BlogSer;
import com.zs.service.ReportSignSer;
import com.zs.tools.CrawlerTest;

/**
 * 2017-7-19
 * 在web启动时设置一些参数
 * @author 张顺
 *
 */
public class PathListener implements ServletContextListener {
	
	private Logger log=Logger.getLogger(getClass());

	private CrawlerTest crawlerTest;
	
	/*张顺，2017-8-5，本来想使用application缓存token，从而避免每次都从数据库查，当关闭tomcat时将所有缓存存入数据库，当再次启动时，就把缓存取出
	 * 但是，想了想，有点复杂，就留着以后再写吧，毕竟没有这个也不影响功能
	 */
	public void contextDestroyed(ServletContextEvent arg0) {
		log.info("系统服务正在结束");
		//在这里写入栈操作，将现场情况存入数据库lc_stack表中
	}

	public void contextInitialized(ServletContextEvent arg0) {
		log.info("系统服务开始启动");
		//在这里写出栈操作，从数据库lc_stack去除所有数据，全部存入application中，并将lc_stack清空，以此实现恢复上次关闭时的现场情况
		arg0.getServletContext().setAttribute("path", arg0.getServletContext().getContextPath());
		
		
		ServletContext servletContext = arg0.getServletContext();  
        ApplicationContext context = (ApplicationContext) servletContext.getAttribute(  
                WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);   
        //建立对应的service当spring上下文初始化之后  ,使用spring框架中已经初始化的memberService  
        BlogSer blogSer=(BlogSer)context.getBean("blogSer");
		crawlerTest=new CrawlerTest(blogSer);
		crawlerTest.work();
	}


}
