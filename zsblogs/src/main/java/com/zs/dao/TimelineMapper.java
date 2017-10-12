package com.zs.dao;

import java.util.List;

import com.zs.entity.BlogList;
import com.zs.entity.Timeline;
import com.zs.entity.other.EasyUIAccept;

public interface TimelineMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Timeline record);

    int insertSelective(Timeline record);

    Timeline selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Timeline record);

    int updateByPrimaryKeyWithBLOBs(Timeline record);

    int updateByPrimaryKey(Timeline record);
    
    List<Timeline> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
}