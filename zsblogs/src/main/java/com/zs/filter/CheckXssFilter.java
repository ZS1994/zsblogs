package com.zs.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.apache.log4j.Logger;

/**
 * XSS、特殊字符过滤器
 * @author 张顺 2019-10-26
 */
public class CheckXssFilter implements Filter{

	private Logger log = Logger.getLogger(getClass());
	
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		log.info("XSS过滤器初始化");
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		
		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {
		log.info("XSS过滤器关闭");
	}

}
