package com.zs.dao;

import com.zs.entity.BlogList;

public interface BlogListMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(BlogList record);

    int insertSelective(BlogList record);

    BlogList selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(BlogList record);

    int updateByPrimaryKey(BlogList record);
}