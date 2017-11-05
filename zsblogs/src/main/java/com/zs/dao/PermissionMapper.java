package com.zs.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.BlogList;
import com.zs.entity.Permission;
import com.zs.entity.other.EasyUIAccept;

public interface PermissionMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Permission record);

    int insertSelective(Permission record);

    Permission selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Permission record);

    int updateByPrimaryKey(Permission record);
    
    Permission selectByUrlAndMethodEqual(@Param("url")String url,@Param("method")String method);
    List<Permission> selectByPers(@Param("pers")String pers);
    
    List<Permission> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
    
    List<Permission> selectAllPermission();
}