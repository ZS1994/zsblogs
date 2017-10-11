package com.zs.dao;

import com.zs.entity.Timeline;
import java.math.BigDecimal;

public interface TimelineMapper {
    int deleteByPrimaryKey(BigDecimal id);

    int insert(Timeline record);

    int insertSelective(Timeline record);

    Timeline selectByPrimaryKey(BigDecimal id);

    int updateByPrimaryKeySelective(Timeline record);

    int updateByPrimaryKey(Timeline record);
}