package com.zs.dao;

import com.zs.entity.Menu;
import com.zs.entity.Permission;

import java.math.BigDecimal;
import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface MenuMapper {
    int deleteByPrimaryKey(BigDecimal id);

    int insert(Menu record);

    int insertSelective(Menu record);

    Menu selectByPrimaryKey(BigDecimal id);

    int updateByPrimaryKeySelective(Menu record);

    int updateByPrimaryKey(Menu record);
    

    List<Menu> selectByPers(@Param("pers")String pers);
}