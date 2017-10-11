package com.zs.dao;

import com.zs.entity.VersionInfo;
import java.math.BigDecimal;

public interface VersionInfoMapper {
    int deleteByPrimaryKey(BigDecimal id);

    int insert(VersionInfo record);

    int insertSelective(VersionInfo record);

    VersionInfo selectByPrimaryKey(BigDecimal id);

    int updateByPrimaryKeySelective(VersionInfo record);

    int updateByPrimaryKey(VersionInfo record);
}