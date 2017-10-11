package com.zs.dao;

import com.zs.entity.Timeline;

public interface TimelineMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Timeline record);

    int insertSelective(Timeline record);

    Timeline selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Timeline record);

    int updateByPrimaryKeyWithBLOBs(Timeline record);

    int updateByPrimaryKey(Timeline record);
}