package com.zs.dao;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.Token;

public interface TokenMapper {
	int deleteByPrimaryKey(String token);

    int insert(Token record);

    int insertSelective(Token record);

    Token selectByPrimaryKey(String token);

    int updateByPrimaryKeySelective(Token record);

    int updateByPrimaryKey(Token record);
    
    int deleteByUid(@Param("uId")Integer uId);
}