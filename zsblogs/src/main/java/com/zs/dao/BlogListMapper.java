package com.zs.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.BlogList;
import com.zs.entity.other.EasyUIAccept;

public interface BlogListMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(BlogList record);

    int insertSelective(BlogList record);

    BlogList selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(BlogList record);

    int updateByPrimaryKey(BlogList record);
    
    List<BlogList> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
    
    
    List<BlogList> queryAll(@Param("uid") Integer uid);
}