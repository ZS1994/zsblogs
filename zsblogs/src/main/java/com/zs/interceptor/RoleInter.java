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

import org.apache.commons.lang3.StringUtils;
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
import com.zs.tools.HttpHelper;
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
	String ip=null;//ip地址
	
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
	    ip=HttpHelper.getIp2(request);
	}
	
	private final String GET="GET",POST="POST",PUT="PUT",DELETE="DELETE";
	
	//给例外列表用的
	private boolean allowThrough(String turl,String tmethod){
		String urla="/zsblogs";
		/*if(StringHelper.checkStar(url, (urla+turl)) && tmethod.equals(method)){
			return true;
		}已抛弃不用，要问为何，那是因为我改变url命名思路了*/
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
				allowThrough("/api/login/token", POST) || //登录
				allowThrough("/api/login/token/clear", DELETE) || //登出
				allowThrough("/menu/index", GET) ||
				allowThrough("/menu/part", GET) ||
				
				allowThrough("/menu/blogList/blog", GET) ||
				allowThrough("/api/blog/list", GET) ||
				allowThrough("/menu/blogList/blog/one", GET) ||
				allowThrough("/api/blog/one", GET) || //看博客正文
				allowThrough("/api/blogComment/list", GET) || //看博客的评论
				allowThrough("/api/blogComment", POST) || //发表评论
				
				allowThrough("/menu/system/login", GET) || //登录
				allowThrough("/menu/system/users/logup", GET) || //注册
				allowThrough("/api/login/logup", POST) ||//注册
				
				/*张顺，2017-12-19，发现有多个上海ip查询api信息，考虑到安全因素，故将其排除例外列表
				allowThrough("/api/apidoc/one", GET) || //某api信息展示接口
				allowThrough("/menu/system/apidoc/info", GET) || //某api信息展示页面
				allowThrough("/api/system/apitest", POST) //api测试接口
				*/
				
				/*张顺，2018-3-10，小佩礼物相关接口*/
				allowThrough("/api/loveXiaoPei/init", GET) ||//初始化
				allowThrough("/api/loveXiaoPei/next", GET) ||//取下一节点
				allowThrough("/api/loveXiaoPei/last", GET) //取上一节点
				
				) {
			/*张顺，2017-12-19,如果是游客，那么：
			1、查一下这个账号为这个ip的用户有没有
			2、有就获取该用户，没有就先创建再获取
			3、给他相应的记录
			*/
			if(user==null && ip!=null){
				Users u2=userSer.getByNum(ip);
				if (u2==null) {
					try {
						u2=new Users(ip, "ZS1994", "游客("+ip+")", new Date(), "3");
						userSer.add(u2);
					} catch (Exception e) {
						e.printStackTrace();
					}
					u2=userSer.getByNum(ip);
				}
				user=u2;
			}
			//张顺，2017-10-19。即使访问的是例外列表，也得看看token，因为后续的user是从这里获取的，如果有token，不管它是不是例外，都去获取user，以便后续使用
			if(user!=null){
				user.setRoles(roles);
				request.setAttribute(Constans.USER, user);
				//张顺，2017-12-1，也要尝试存储操作日志
				Permission p=perSer.get(url, method);
				if (user!=null && user.getId()!=null && p!=null) {
					Timeline tl=new Timeline(user.getId(), p.getId(), gson.toJson(req.getParameterMap()));
					try {
						timeLineSer.add(tl);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
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
					resp.sendRedirect("/zsblogs/staticView/error_per_no_exist.jsp");
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
					resp.sendRedirect("/zsblogs/staticView/error_timeout.jsp");
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
		//一定要记得清空，否则当用户登出后，由于user和roles会保存之前的引用而导致用户还能正常的进行某些操作。
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
			}else{
				clear();
			}
		}else{
			clear();
		}
	}
	
	
	private void clear(){
		isTimeout=false;
		user=null;
		roles=null;
	}
	
	
}


