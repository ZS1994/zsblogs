package com.zs.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.BlogList;

	public interface BlogListSer extends BaseService<BlogList, Integer>{

	public List<BlogList> queryAll(Integer uid);
}
