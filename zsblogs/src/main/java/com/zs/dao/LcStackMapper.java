package com.zs.dao;

import com.zs.entity.LcStack;

public interface LcStackMapper {
    int deleteByPrimaryKey(String key);

    int insert(LcStack record);

    int insertSelective(LcStack record);

    LcStack selectByPrimaryKey(String key);

    int updateByPrimaryKeySelective(LcStack record);

    int updateByPrimaryKeyWithBLOBs(LcStack record);
}