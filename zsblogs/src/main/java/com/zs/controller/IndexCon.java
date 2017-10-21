package com.zs.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

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
	
	@RequestMapping("/blogList/blog")
	public String gotoBlog(HttpServletRequest req,String page,String rows){
		req.setAttribute("page", page);
		req.setAttribute("rows", rows);
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
	public String gotoRead(){
		return "/blog/read";
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
	public String gotoTimeline(){
		return "/system/timeline";
	}
}
