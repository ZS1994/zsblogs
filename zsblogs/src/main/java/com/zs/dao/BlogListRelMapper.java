package com.zs.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.BlogListRel;

public interface BlogListRelMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(BlogListRel record);

    int insertSelective(BlogListRel record);

    BlogListRel selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(BlogListRel record);

    int updateByPrimaryKey(BlogListRel record);
    
    int getCountFromBlid(@Param("blId") Integer blId);
    
    List<BlogListRel> selectByBlidOrBid(@Param("blId")Integer blId,@Param("bId")Integer bId);
}