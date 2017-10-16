package com.zs.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

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
	@RequestMapping("/blogList")
	public String gotoBlogList(){
		return "/blog/blogList";
	}
	
	@RequestMapping("/blogList/blog")
	public String gotoBlog(){
		return "/blog/blog";
	}
	@RequestMapping("/blogList/blog/{id}")
	public String gotoBlogMain(@PathVariable String id){
		return "/blog/blogMainInfo";
	}
	@RequestMapping("/blogList/blog/edit")
	public String gotoBlogEdit(){
		return "/blog/blogEdit";
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
