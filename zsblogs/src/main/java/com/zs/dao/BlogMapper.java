package com.zs.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.Blog;
import com.zs.entity.BlogList;
import com.zs.entity.other.EasyUIAccept;

public interface BlogMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Blog record);

    int insertSelective(Blog record);

    Blog selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Blog record);

    int updateByPrimaryKeyWithBLOBs(Blog record);

    int updateByPrimaryKey(Blog record);
    
    List<Blog> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
    
    List<Blog> queryByTitle(String title);
    
}