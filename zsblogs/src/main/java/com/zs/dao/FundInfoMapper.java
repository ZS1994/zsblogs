package com.zs.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.FundInfo;
import com.zs.entity.other.EasyUIAccept;

public interface FundInfoMapper {
    int deleteByPrimaryKey(String id);

    int insert(FundInfo record);

    int insertSelective(FundInfo record);

    FundInfo selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(FundInfo record);

    int updateByPrimaryKey(FundInfo record);
    
    List<FundInfo> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
    
    List<FundInfo> selectAllFundByUser(@Param("uid")Integer uid);
    
}