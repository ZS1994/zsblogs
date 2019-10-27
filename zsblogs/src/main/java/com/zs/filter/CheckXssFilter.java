package com.zs.filter;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.zs.controller.rest.BaseRestController;
import com.zs.controller.rest.BaseRestController.Code;
import com.zs.entity.other.Result;

/**
 * XSS、特殊字符过滤器
 * @author 张顺 2019-10-26
 */
public class CheckXssFilter implements Filter{

	private Logger log = Logger.getLogger(getClass());
	private String desc = "请不要输入敏感字符";
	private Gson gson = new Gson();
	private List<String> xssStrs = null;
	//白名单
	private List<Whrite> whriteList = null;
	
	private String url;
	private String method;
	private HttpServletRequest req;
	private HttpServletResponse resp;
	
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		log.info("XSS过滤器初始化");
		//以后改为字典组配置
		xssStrs = new ArrayList<>();
		xssStrs.add("<");
		xssStrs.add(">");
		xssStrs.add("\"");
		xssStrs.add("\'");
		xssStrs.add("script");
		xssStrs.add("alert");
		//初始化白名单
		whriteList = new ArrayList<>();
		whriteList.add(new Whrite("/api/blog", "POST", "content"));
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		//得到请求信息
		req = (HttpServletRequest) request;
		resp = (HttpServletResponse) response;
		url = req.getRequestURI();
		method = req.getMethod();
		//开始遍历输入参数
		Enumeration<String> parNames = request.getParameterNames();
		while (parNames.hasMoreElements()) {
			//检查参数名有没有特殊字符
			String parName = (String) parNames.nextElement();
			//白名单直接放行
			boolean isAccess = false;
			for (Whrite whrite : whriteList) {
				if (url.contains(whrite.getUrl()) && method.equals(whrite.getMethod()) && parName.equals(whrite.getParName())) {
					isAccess = true;
					break;
				}
			}
			if (isAccess) {
				continue;
			}
			String result1 = isHasXss(parName);
			if (result1 != null) {
				response.setCharacterEncoding("utf-8");
				response.setContentType("application/json; charset=utf-8");  
				PrintWriter pw=response.getWriter();
				Result<String> result=new Result<String>(BaseRestController.ERROR, Code.ERROR, desc + ":" + result1, desc + ":" + result1);
				pw.write(gson.toJson(result));
				pw.flush();
				pw.close();
				return;
			}
			//检查参数值有没有特殊字符
			String parValue = request.getParameter(parName);
			//首先判断是否是json，如果不是json，则检查敏感字
			if (!validateJson(parValue)) {
				String result2 = isHasXss(parValue);
				if (result2 != null) {
					response.setCharacterEncoding("utf-8");
					response.setContentType("application/json; charset=utf-8");  
					PrintWriter pw=response.getWriter();
					Result<String> result=new Result<String>(BaseRestController.ERROR, Code.ERROR, desc + ":" + result2, desc + ":" + result2);
					pw.write(gson.toJson(result));
					pw.flush();
					pw.close();
					return;
				}
			}
		}
		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {
		log.info("XSS过滤器关闭");
	}

	
	//检查是否有敏感字符，其中就是包括了xss攻击的一些字符
	private String isHasXss(String txt) {
		for (String str : xssStrs) {
			if (txt.contains(str)) {
				return txt;
			}
		}
		return null;
	}
	
	private boolean validateJson(String jsonStr) {
        JsonElement jsonElement;
        try {
            jsonElement = new JsonParser().parse(jsonStr);
        } catch (Exception e) {
            return false;
        }
        if (jsonElement == null) {
            return false;
        }
        if (!jsonElement.isJsonObject() && !jsonElement.isJsonArray()) {
            return false;
        }
        return true;
    }
	
	private class Whrite{
		private String url;
		private String method;
		private String parName;
		public String getUrl() {
			return url;
		}
		public void setUrl(String url) {
			this.url = url;
		}
		public String getMethod() {
			return method;
		}
		public void setMethod(String method) {
			this.method = method;
		}
		public String getParName() {
			return parName;
		}
		public void setParName(String parName) {
			this.parName = parName;
		}
		public Whrite(String url, String method, String parName) {
			super();
			this.url = url;
			this.method = method;
			this.parName = parName;
		}
	}
}
