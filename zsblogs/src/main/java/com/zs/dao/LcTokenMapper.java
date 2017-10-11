package com.zs.dao;

import java.math.BigDecimal;

import com.zs.entity.LcToken;

public interface LcTokenMapper {
    int deleteByPrimaryKey(String token);

    int insert(LcToken record);

    int insertSelective(LcToken record);

    LcToken selectByPrimaryKey(String token);

    int updateByPrimaryKeySelective(LcToken record);

    int updateByPrimaryKey(LcToken record);
	int deleteByUid(BigDecimal uid);
}