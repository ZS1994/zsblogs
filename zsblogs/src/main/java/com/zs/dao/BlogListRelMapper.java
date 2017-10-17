package com.zs.dao;

import com.zs.entity.BlogListRel;

public interface BlogListRelMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(BlogListRel record);

    int insertSelective(BlogListRel record);

    BlogListRel selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(BlogListRel record);

    int updateByPrimaryKey(BlogListRel record);
}