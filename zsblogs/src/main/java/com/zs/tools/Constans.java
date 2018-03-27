package com.zs.tools;

import javax.servlet.http.HttpServletRequest;

import com.zs.entity.Users;

/**
 * 张顺，2017-10-19
 * 存储一些公共变量
 * @author it023
 *
 */
public class Constans {

	public static final String USER="[user]";
	public static final String URL="[url]";
	public static final String METHOD="[method]";
	
	public static Users getUserFromReq(HttpServletRequest req){
		return (Users)req.getAttribute(USER);
	}
	public static String getUrlFromReq(HttpServletRequest req){
		return (String)req.getAttribute(URL);
	}
	public static String getMethodFromReq(HttpServletRequest req){
		return (String)req.getAttribute(METHOD);
	}
}
