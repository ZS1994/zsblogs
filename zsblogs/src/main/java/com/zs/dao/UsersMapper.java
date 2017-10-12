package com.zs.dao;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.Users;

public interface UsersMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Users record);

    int insertSelective(Users record);

    Users selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Users record);

    int updateByPrimaryKey(Users record);
    
    Users selectByNumAndPass(@Param("num")String usernum,@Param("pass")String userpass);
    Users selectByNum(@Param("num")String usernum);
    
    
}