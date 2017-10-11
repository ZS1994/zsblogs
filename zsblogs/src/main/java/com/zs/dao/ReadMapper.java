package com.zs.dao;

import com.zs.entity.Read;

public interface ReadMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Read record);

    int insertSelective(Read record);

    Read selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Read record);

    int updateByPrimaryKey(Read record);
}