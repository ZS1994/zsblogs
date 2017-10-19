package com.zs.service;

import com.zs.entity.Blog;
import com.zs.entity.Users;

public interface BlogSer extends BaseService<Blog, Integer>{

	//获取某一篇博客的作者信息
	public Users getAutorOfBlog(Integer bid);
	
}
