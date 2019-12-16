package com.zs.tools;
import java.util.ArrayList;
import java.util.List;
import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.zs.dao.PermissionMapper;
import com.zs.entity.FundInfo;
import com.zs.entity.Permission;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.service.FundInfoSer;
import com.zs.service.UserSer;

/**
 * 缓存表
 * 用于下拉框的填充，自动补全的输入框等等
 * 缓存的有以下表
 * 用户表
 * 系统参数表
 * 基金信息表
 * @author 张顺 2019-10-26
 */
@Component
public class CacheCharts implements Runnable{

	@Resource
	private UserSer userSer;
	@Resource
	private FundInfoSer fundInfoSer;
	@Resource
	private PermissionMapper permissionMapper;
	
	private Gson gson = new GsonBuilder()
	        .setDateFormat("yyyy-MM-dd HH:mm:ss")
	        .create();
	private Logger log=Logger.getLogger(getClass());
    
	private boolean isBegin = true;
	
	private static List<Object> users = new ArrayList<>();
	private static List<Object> fundInfos = new ArrayList<>();
	private static List<Permission> permissions = new ArrayList<>();
	private static String usersJson = "[]";
	private static String fundInfosJson = "[]";
	private static String permissionsJson = "[]";
	
	//张顺，2019-12-16，局部变量，内存优化
	EasyUIAccept eui;
	String result;
	
	
	@PostConstruct
	public void beginWorkThread(){
		Thread thread = Constans.getThread(this, "CacheCharts");
		if (!thread.isAlive()) {
			log.info("CacheCharts缓存表，线程已开启，等待刷新数据。");
			thread.start();
		}else {
			refresh();
		}
	}
	
	
	private void work(){
		while(true){
			try {
				if (isBegin) {
					refresh();
					Thread.sleep(1000*60*60*4);//每4小时重新爬取一次
				}
				Thread.sleep(1000*60);//每60s进行一次判断
			} catch (Exception e) {
				//出错了就休息2小时再尝试
				e.printStackTrace();
				try {
					Thread.sleep(1000*60*60*2);
				} catch (InterruptedException e1) {
					e1.printStackTrace();
				}
			}
		}
	}
	
	//刷新数据
	public String refresh(){
		result = "";
		eui = new EasyUIAccept();
		eui.setStart(0);
		eui.setRows(Constans.INFINITY);
		
		log.info("users数据开始刷新");
		result += "users数据开始刷新\n";
		users = userSer.queryFenye(eui).getRows();
		usersJson = gson.toJson(users, new TypeToken<List<Users>>(){}.getType());
		log.info("users数据刷新完成，共" + users.size() + "条");
		result += "users数据刷新完成，共" + users.size() + "条\n";
		
		log.info("fund_info数据开始刷新");
		result += "fund_info数据开始刷新\n";
		fundInfos = fundInfoSer.queryFenye(eui).getRows();
		fundInfosJson = gson.toJson(fundInfos, new TypeToken<List<FundInfo>>(){}.getType());;
		log.info("fund_info数据刷新完成，共" + fundInfos.size() + "条");
		result += "fund_info数据刷新完成，共" + fundInfos.size() + "条\n";
		
		log.info("permission数据开始刷新");
		result += "permission数据开始刷新\n";
		permissions = permissionMapper.queryFenye(eui);
		permissionsJson = gson.toJson(permissions, new TypeToken<List<Permission>>(){}.getType());;
		log.info("permission数据刷新完成，共" + permissions.size() + "条");
		result += "permission数据刷新完成，共" + permissions.size() + "条\n";
		return result;
	}
	
	
	
	/**
	 * 开始爬虫工作
	 * 每隔10秒钟检测一次是否继续工作
	 */
	@Override
	public void run() {
		work();
	}


	public boolean getIsBegin() {
		return isBegin;
	}

	public void setIsBegin(boolean isBegin) {
		this.isBegin = isBegin;
	}

	public static List<Object> getUsers() {
		return users;
	}
	
	public static List<Object> getFundInfos() {
		return fundInfos;
	}
	
	public static List<Permission> getPermissions() {
		return permissions;
	}
	
	
	public static String getUsersJson() {
		return usersJson;
	}
	
	public static String getFundInfosJson() {
		return fundInfosJson;
	}
	
	public static String getPermissionsJson() {
		return permissionsJson;
	}
}
