package com.zs.service;

import com.zs.entity.Blog;
import com.zs.entity.Users;

public interface BlogSer extends BaseService<Blog, Integer>{

	//获取某一篇博客的作者信息
	public Users getAutorOfBlog(Integer bid);
	//获取某一篇博客的所属栏目(名字0,id1)
	public String[] getBlogListNamesOfBlog(Integer bid);
	//增加一次阅读次数
	public String read(Integer uid,Integer bid);
	
}
