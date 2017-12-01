package com.zs.dao;

import com.zs.entity.ApiDocParameter;

public interface ApiDocParameterMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(ApiDocParameter record);

    int insertSelective(ApiDocParameter record);

    ApiDocParameter selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(ApiDocParameter record);

    int updateByPrimaryKey(ApiDocParameter record);
}