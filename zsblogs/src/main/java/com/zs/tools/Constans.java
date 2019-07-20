package com.zs.tools;

import javax.servlet.http.HttpServletRequest;

import com.zs.entity.Users;

/**
 * 张顺，2017-10-19
 * 存储一些公共变量
 * @author it023
 * 2019-6-13，张顺
 * 以后部署项目的话，需要在这个地方更改一些配置
 * 1、下载图片的文件保存路径
 * 2、tomcat配置的图片文件夹映射，请这样配：
 * <Context docBase="E:/tomcat_imgs/" path="/tomcat_imgs" reloadable="true"/>
 * 3、爬虫1号的id
 *
 */
public class Constans {

	public static final String USER="[user]";
	public static final String URL="[url]";
	public static final String METHOD="[method]";
	public static final Integer CRAWLERNO1=6;//爬虫1号
	public static final Integer CRAWLERNO2=97;//爬虫二号
	public static final Integer CRAWLERNO3=241;//爬虫三号
	public static final Integer INFINITY=99999;//无穷大，用作全部查询时使用
	
	@Deprecated
	public static final String PATH_ROOT="E:/tomcat_imgs/";//张顺，2019-6-17，已改为spring配置文件配置
	public static final String PATH_TOMCAT_IMGS="/tomcat_imgs/";
	
	
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
