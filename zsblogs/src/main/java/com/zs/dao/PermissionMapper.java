package com.zs.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.Permission;

public interface PermissionMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Permission record);

    int insertSelective(Permission record);

    Permission selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Permission record);

    int updateByPrimaryKey(Permission record);
    
    Permission selectByUrlAndMethod(@Param("url")String url,@Param("method")String method);
    List<Permission> selectByPers(@Param("pers")String pers);
}