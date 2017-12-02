package com.zs.controller;

import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.zs.entity.Role;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.tools.Constans;

@Controller
@RequestMapping("/menu")
public class IndexCon{
	
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
}
