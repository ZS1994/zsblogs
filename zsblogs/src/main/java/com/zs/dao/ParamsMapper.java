package com.zs.dao;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.Params;

public interface ParamsMapper {
    int insert(Params record);

    int insertSelective(Params record);
    
    Params selectByPk(@Param("pId")String pId, @Param("group")String group);
    
    int updateByPk(Params record);
    
    int deleteByPk(@Param("pId")String pId, @Param("group")String group);
    
}