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
	
	public static Users getUserFromReq(HttpServletRequest req) throws Exception{
		return (Users)req.getAttribute(USER);
	}
	
	
}
