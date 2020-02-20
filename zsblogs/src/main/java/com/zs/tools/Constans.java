package com.zs.tools;

import java.security.MessageDigest;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

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

	private static Logger log = Logger.getLogger(Constans.class);
	
	public static final String USER="[user]";
	//用于存session里面登录的用户
	public static final String USER_ME_ID = "userMeId";
	//用于存session里面登录的用户的token
	public static final String TOKEN = "token";
	
	
	public static final String URL="[url]";
	public static final String METHOD="[method]";
	
	public static final Integer CRAWLERNO1=6;//爬虫1号
	public static final Integer CRAWLERNO2=97;//爬虫二号
	public static final Integer CRAWLERNO3=241;//爬虫三号
	
	/**
	 * 小佩礼物的保存结果的权限id
	 */
	public static final Integer PER_ID_LOVEXIAOPEI_SAVE = 99;
	
	public static final Integer INFINITY=99999;//无穷大，用作全部查询时使用
	
	@Deprecated
	public static final String PATH_ROOT="E:/tomcat_imgs/";//张顺，2019-6-17，已改为spring配置文件配置
	public static final String PATH_TOMCAT_IMGS="/tomcat_imgs/";
	
	/**
	 * 从权限拦截器中尝试获取当前用户，一定会有一个用户，如果未登录那么取的就是一个游客用户
	 * @param req
	 * @return
	 */
	public static Users getUserFromReq(HttpServletRequest req){
		return (Users)req.getAttribute(USER);
	}
	public static String getUrlFromReq(HttpServletRequest req){
		return (String)req.getAttribute(URL);
	}
	public static String getMethodFromReq(HttpServletRequest req){
		return (String)req.getAttribute(METHOD);
	}
	
	
	/**
	 * 从已存在的线程中找一个线程，若没找到才会创建一个，确保进程中该线程只有一个
	 * @param target  一般为自己
	 * @param name  非空
	 * @return
	 */
	public static Thread getThread(Runnable target, String name) {
		if (name == null) {
			return null;
		}
		ThreadGroup group = Thread.currentThread().getThreadGroup();
        ThreadGroup topGroup = group;
        // 遍历线程组树，获取根线程组
        while (group != null) {
            topGroup = group;
            group = group.getParent();
        }
        // 激活的线程数再加一倍，防止枚举时有可能刚好有动态线程生成
        int slackSize = topGroup.activeCount() * 2;
        Thread[] slackThreads = new Thread[slackSize];
        // 获取根线程组下的所有线程，返回的actualSize便是最终的线程数
        int actualSize = topGroup.enumerate(slackThreads);
        Thread[] atualThreads = new Thread[actualSize];
        // 复制slackThreads中有效的值到atualThreads
        System.arraycopy(slackThreads, 0, atualThreads, 0, actualSize);
        log.info("线程数量是：" + atualThreads.length);
        for (Thread thread : atualThreads) {
        	if (thread.getName().equals(name)) {
	        	log.info("找到该线程，线程名称: " + thread.getName());
				return thread;
			}
        }
        return new Thread(target, name);
	}
	
	/**sha1加密*/
	public static String getSha1(String str) {
        char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
            'a', 'b', 'c', 'd', 'e', 'f' };
        try {
            MessageDigest mdTemp = MessageDigest.getInstance("SHA1");
            mdTemp.update(str.getBytes("UTF-8"));
            byte[] md = mdTemp.digest();
            int j = md.length;
            char buf[] = new char[j * 2];
            int k = 0;
            for (int i = 0; i < j; i++) {
                byte byte0 = md[i];
                buf[k++] = hexDigits[byte0 >>> 4 & 0xf];
                buf[k++] = hexDigits[byte0 & 0xf];
            }
            return new String(buf);
        } catch (Exception e) {
            return null;
        }
    }
}
