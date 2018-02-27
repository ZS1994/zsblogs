package com.zs.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.zs.dao.FundHistoryMapper;
import com.zs.dao.FundInfoMapper;
import com.zs.entity.FundInfo;
import com.zs.entity.Role;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.tools.Constans;

@Controller
@RequestMapping("/menu")
public class IndexCon{
	
	@Resource
	private FundInfoMapper fundInfoMapper;
	@Resource
	private FundHistoryMapper fundHistoryMapper;
	
	
	@RequestMapping("/index")
	public String gotoIndex(){
		return "/index";
	}
	
	//----测试、构建项目初期使用----------
	@RequestMapping("/part")
	public String gotoPart(){
		return "/part/left_center";
	}
	
	
	//----博客类-------
	@RequestMapping("/user/blogList")
	public String gotoUserBlogList(){
		return "/blog/blogList";
	}
	//我的博客
	@RequestMapping("/user/blog")
	public String gotoUserBlog(HttpServletRequest req,EasyUIAccept accept){
		req.setAttribute("acc", accept);
		if(accept!=null && accept.getInt2()==null){
			try {
				Users u=Constans.getUserFromReq(req);
				if(u!=null) accept.setInt2(u.getId());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return "/blog/blogOfUser";
	}
	//最新博客，所有博客
	@RequestMapping("/blogList/blog")
	public String gotoBlog(HttpServletRequest req,EasyUIAccept accept){
		req.setAttribute("acc", accept);
		return "/blog/blog";
	}
	//写博客
	@RequestMapping("/blogList/blog/user/edit")
	public String gotoBlogEdit(HttpServletRequest req,String id){
		req.setAttribute("id", id);
		return "/blog/blogEdit";
	}
	
	@RequestMapping("/blogList/blog/one")
	public String gotoBlogMain(String id,HttpServletRequest req){
		req.setAttribute("id", id);
		return "/blog/blogMainInfo";
	}
	
	
	@RequestMapping("/blogList/blog/blogComment")
	public String gotoBlogComment(){
		return "/blog/blogComment";
	}
	
	@RequestMapping("/blogList/blog/read")
	public String gotoRead(String bId,HttpServletRequest req){
		req.setAttribute("bId", bId);
		return "/blog/blogRead";
	}
	
	//----系统功能类-------------
	@RequestMapping("/system/login")
	public String gotoLogin(){
		return "/system/login";
	}
	
	@RequestMapping("/system/permission")
	public String gotoPermission(){
		return "/system/permission";
	}
	
	@RequestMapping("/system/role")
	public String gotoRole(){
		return "/system/role";
	}
	
	@RequestMapping("/system/users")
	public String gotoUsers(){
		return "/system/users";
	}
	
	@RequestMapping("/system/timeline")
	public String gotoTimeLine(){
		return "/system/timeline";
	}
	
	//我的信息
	@RequestMapping("/system/users/own")
	public String gotOwnInfo(HttpServletRequest req,Users user){
		try {
			user=Constans.getUserFromReq(req);
			if(user!=null){
				SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				if(user.getCreateTime()!=null){
					String date=sdf.format(user.getCreateTime());
					req.setAttribute("createTime", date);
				}
				if(user.getRoles()!=null){
					String str="";
					for (Role r : user.getRoles()) {
						str=str+r.getName()+",";
					}
					str=str.substring(0, str.lastIndexOf(","));
					user.setRoleNames(str);
				}
			}
			req.setAttribute("user", user);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "/system/own";
	}
	
	
	//注册一个
	@RequestMapping("/system/users/logup")
	public String gotoLogup(){
		return "/system/logup";
	}
	
	//---爬虫---------------
	@RequestMapping("/crawler/manager")
	public String gotoCrawlerManager(){
		return "/crawler/crawlerManager";
	}
	
	//---api接口文档管理----------------------
	@RequestMapping("/system/apidoc")
	public String gotoApiDocList(){
		return "/system/apiDocList";
	}
	//接口详情
	@RequestMapping("/system/apidoc/info")
	public String gotoApiDocInfo(String id,HttpServletRequest req){
		req.setAttribute("id", id);
		return "/system/apiDocInfo";
	}
	//接口参数
	@RequestMapping("/system/apidoc/param")
	public String gotoApiDocParam(String adId,HttpServletRequest req){
		req.setAttribute("adId", adId);
		return "/system/apiDocParam";
	}
	
	//-----基金管理----------------------------------------
	@RequestMapping("/fund/fundHistory")
	public String gotoFundHistory(){
		return "/fund/fundHistory";
	}
	@RequestMapping("/fund/fundInfo")
	public String gotoFundInfo(){
		return "/fund/fundInfo";
	}
	@RequestMapping("/fund/fundTrade")
	public String gotoFundTrade(String username,HttpServletRequest req){
		Users u=(Users) req.getAttribute(Constans.USER);
		req.setAttribute("username", u.getName());
		return "/fund/fundTrade";
	}
	//图表分析
	@RequestMapping("/fund/fundCharts")
	public String gotoFundCharts(HttpServletRequest req){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
		EasyUIAccept accept=new EasyUIAccept();
		Users u=(Users) req.getAttribute(Constans.USER);
		List<FundInfo> fis=fundInfoMapper.selectAllFundByUser(u.getId());
		String fiId=fis.size()>0?fis.get(0).getId():"110022";//这里传一个基金编号，本想是传该用户持有之一，但是没办法，暂时就传一个固定的
		Date edate=fundHistoryMapper.getEndDate(fiId);
		//这里默认显示最近一个月的数据
		accept.setStr2(sdf.format(edate));
		Calendar calendar=Calendar.getInstance();
		calendar.setTime(edate);
		calendar.add(Calendar.MONTH, -1);
		Date bdate=calendar.getTime();
		accept.setStr1(sdf.format(bdate));
		accept.setInt1(u.getId());
		accept.setStr3(fiId);
		req.setAttribute("accept", accept);
		return "/fund/fundCharts";
	}
	
}


