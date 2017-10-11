package com.zs.dao;

import com.zs.entity.BlogComment;

public interface BlogCommentMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(BlogComment record);

    int insertSelective(BlogComment record);

    BlogComment selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(BlogComment record);

    int updateByPrimaryKey(BlogComment record);
}