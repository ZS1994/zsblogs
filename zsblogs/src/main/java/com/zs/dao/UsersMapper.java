package com.zs.dao;

import com.zs.entity.Users;
import java.math.BigDecimal;

import org.apache.ibatis.annotations.Param;

public interface UsersMapper {
    int deleteByPrimaryKey(BigDecimal id);

    int insert(Users record);

    int insertSelective(Users record);

    Users selectByPrimaryKey(BigDecimal id);

    int updateByPrimaryKeySelective(Users record);

    int updateByPrimaryKey(Users record);
    Users selectByNumAndPass(@Param("num")String num,@Param("pass")String pass);
}