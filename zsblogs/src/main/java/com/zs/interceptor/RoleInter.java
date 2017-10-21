package com.zs.interceptor;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import com.google.gson.Gson;
import com.zs.controller.rest.BaseRestController;
import com.zs.controller.rest.BaseRestController.Code;
import com.zs.entity.Permission;
import com.zs.entity.Role;
import com.zs.entity.Timeline;
import com.zs.entity.Token;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.Result;
import com.zs.service.LicenceSer;
import com.zs.service.PerSer;
import com.zs.service.RoleSer;
import com.zs.service.TimeLineSer;
import com.zs.service.UserSer;
import com.zs.tools.Constans;
import com.zs.tools.StringHelper;


/**2017-2-27，张顺
 * 权限拦截器
 * 2017-3-6，张顺
 * 时间轴拦截器也整合其中
 * 2017-8-5
 * 改为token判断身份信息
 * @author 张顺
 */
public class RoleInter extends HandlerInterceptorAdapter{

	@Resource
	private UserSer userSer;
	@Resource
	private RoleSer roleSer;
	@Resource
	private PerSer perSer;
	@Resource
	private LicenceSer licenceSer;
	@Resource
	private TimeLineSer timeLineSer;
	
	private Gson gson=new Gson();
	private Logger log=Logger.getLogger(RoleInter.class);
	private HttpServletRequest req;
	private HttpServletResponse resp;
	private String url;
	String reqPamrs;
	private String method;
	HttpSession session;
	Users user;
	List<Role> roles;
	String token;
	String tokenS;
	Token lcToken;
	boolean isTimeout=false;//是否过期
	
	private void init(HttpServletRequest request, HttpServletResponse response){
		req=request;
		resp=response;
		resp.reset();
		resp.setCharacterEncoding("utf-8");
		String lId=request.getHeader("licence");
		method=req.getMethod();
		//获取其他信息
	    session = req.getSession();  
	    //获得url
	    url=req.getRequestURI();
	    reqPamrs = req.getQueryString();//后面的参数
	    token=req.getHeader("token");
	    tokenS=(String)req.getSession().getAttribute("token");
	    if(token==null && tokenS!=null){
	    	token=tokenS;
	    }
	    
	}
	
	private final String GET="GET",POST="POST",PUT="PUT",DELETE="DELETE";
	
	//给例外列表用的
	private boolean allowThrough(String turl,String tmethod){
		String urla="/zsblogs";
		/*if(StringHelper.checkStar(url, (urla+turl)) && tmethod.equals(method)){
			return true;
		}*/
		if((urla+turl).equals(url) && tmethod.equals(method)){
			return true;
		}
		return false;
	}
	
	/*权限判断+时间轴记录*/
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		init(request, response);
		initUserAndRoleFromToken();
		
//		log.info("url:"+url+"  method:"+method+"  token:"+token+"  isTimeout:"+isTimeout+"  username:"+(user!=null?user.getName():"null"));
		
		//例外列表
		if (
				allowThrough("/api/login/token", POST) ||
				allowThrough("/api/login/token/clear", DELETE) ||
				allowThrough("/menu/index", GET) ||
				allowThrough("/menu/part", GET) ||
				
				allowThrough("/menu/blogList/blog", GET) ||
				allowThrough("/api/blog/list", GET) ||
				allowThrough("/menu/blogList/blog/one", GET) ||
				allowThrough("/api/blog/one", GET) || //看博客正文
				allowThrough("/api/blogComment/list", GET) || //看博客的评论
				allowThrough("/api/blogComment", POST) || //发表评论
				
				allowThrough("/menu/system/login", GET)
				) {
			//张顺，2017-10-19。即使访问的是例外列表，也得看看token，因为后续的user是从这里获取的，如果有token，不管它是不是例外，都去获取user，以便后续使用
			if(user!=null){
				user.setRoles(roles);
				request.setAttribute(Constans.USER, user);
			}
			return true;
		}
		if (method.equals("OPTIONS")
				) {
			return true;
		}
		
		if (isTimeout) {
			gotoHadle(Code.LICENCE_TIMEOUT);
			return false;
		}else if (user==null) {
			gotoHadle(Code.LICENCE_NO);
			return false;
		}else if(roles==null){
			gotoHadle(Code.ROLE_USER_NO_ROLE);
			return false;
		}else{
			Permission per=perSer.get(url, method);
			if(per==null){
				gotoHadle(Code.PERMISSION_NO_EXIST);
				return false;
			}else{
				if (roleSer.isPerInRoles(per, roles)) {
					timeLineSer.add(new Timeline(user.getId(),per.getId(), gson.toJson(req.getParameterMap())));
					if(lcToken!=null){
						Calendar calendar=Calendar.getInstance();
						calendar.add(Calendar.DAY_OF_MONTH, 1);//加一天
						lcToken.setInvalidTime(calendar.getTime());
						licenceSer.updateToken(lcToken);
					}
					user.setRoles(roles);
					if(req==null){
						log.error("[req==null]"+(req==null));
					}
					request.setAttribute(Constans.USER, user);
					return true;
				}else{
					gotoHadle(Code.ROLE_USER_NO_PERMISSION);
					return false;
				}
			}
		}
	}

	/* 跳转和返回值处理*/
	private void gotoHadle(int code){
		Result<String> result;
		try {
			switch (code) {
			case Code.LICENCE_NO:
				if (url.contains("/api/")) {
					resp.setCharacterEncoding("utf-8");
					resp.setContentType("application/json; charset=utf-8"); 
					PrintWriter pw=resp.getWriter();
					result=new Result<String>(BaseRestController.ERROR, code, "身份验证失败，请重新获取token。");
					pw.write(gson.toJson(result));
					pw.flush();
					pw.close();
				}else if(url.contains("/menu/")){
					resp.sendRedirect("/zsblogs/staticView/error_noToken.jsp");
				}
				break;
			case Code.ROLE_USER_NO_ROLE:
				if (url.contains("/api/")) {
					resp.setCharacterEncoding("utf-8");
					resp.setContentType("application/json; charset=utf-8"); 
					PrintWriter pw=resp.getWriter();
					result=new Result<String>(BaseRestController.ERROR, code, "您没有被分配角色，请联系管理员。");
					pw.write(gson.toJson(result));
					pw.flush();
					pw.close();
				}else if(url.contains("/menu/")){
					resp.sendRedirect("/zsblogs/staticView/error_noRole.jsp");
				}		
				break;
			case Code.ROLE_USER_NO_PERMISSION:
				if (url.contains("/api/")) {
					resp.setCharacterEncoding("utf-8");
					resp.setContentType("application/json; charset=utf-8");  
					PrintWriter pw=resp.getWriter();
					result=new Result<String>(BaseRestController.ERROR, code, "您没有该权限，请联系管理员。");
					pw.write(gson.toJson(result));
					pw.flush();
					pw.close();
				}else if(url.contains("/menu/")){
					resp.sendRedirect("/zsblogs/staticView/error_noPer.jsp");
				}
				break;
			case Code.PERMISSION_NO_EXIST:
				if (url.contains("/api/")) {
					resp.setCharacterEncoding("utf-8");
					resp.setContentType("application/json; charset=utf-8"); 
					PrintWriter pw=resp.getWriter();
					result=new Result<String>(BaseRestController.ERROR, code, "该模块还没有设计权限，请联系管理员。");
					pw.write(gson.toJson(result));
					pw.flush();
					pw.close();
				}else if(url.contains("/menu/")){
					
				}
				break;
			case Code.LICENCE_TIMEOUT:
				if (url.contains("/api/")) {
					resp.setCharacterEncoding("utf-8");
					resp.setContentType("application/json; charset=utf-8"); 
					PrintWriter pw=resp.getWriter();
					result=new Result<String>(BaseRestController.ERROR, code, "身份信息过期。");
					pw.write(gson.toJson(result));
					pw.flush();
					pw.close();
				}else if(url.contains("/menu/")){
					
				}
				break;
			default:
				break;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/*2017-8-5，张顺，根据token初始化相关参数*/
	private void initUserAndRoleFromToken(){
		if(token!=null && !token.equals("null")){
			lcToken=licenceSer.geLcToken(token);
			if (lcToken!=null) {
				if(lcToken.getInvalidTime().before(new Date())){
					isTimeout=true;
					return;
				}
				user=userSer.get(lcToken.getuId());
				if(user!=null && user.getRids()!=null){
					roles=roleSer.getRolesFromRids(user.getRids());
				}
			}
		}
	}
}
