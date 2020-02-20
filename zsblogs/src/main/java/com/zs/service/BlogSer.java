package com.zs.service;

import java.util.List;

import com.zs.entity.Blog;
import com.zs.entity.Users;

public interface BlogSer extends BaseService<Blog, Integer>{

	//获取某一篇博客的作者信息
	public Users getAutorOfBlog(Integer bid);
	//获取某一篇博客的所属栏目(名字0,id1)
	public String[] getBlogListNamesOfBlog(Integer bid);
	//增加一次阅读次数
	public String read(Integer uid,Integer bid);
	
	//通过标题查找博客
	public List<Blog> queryByTitle(String title);
		
	/**张顺，2020-2-19，查出所有未上传至微信公众号好的博客*/
	public Blog queryNoUploadWeBlog();
}
