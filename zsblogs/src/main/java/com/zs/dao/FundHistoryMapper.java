package com.zs.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.FundHistory;
import com.zs.entity.other.EasyUIAccept;

public interface FundHistoryMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(FundHistory record);

    int insertSelective(FundHistory record);

    FundHistory selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(FundHistory record);

    int updateByPrimaryKey(FundHistory record);
    
    
    List<FundHistory> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
    
    FundHistory selectByFiIdAndTime(@Param("fiId")String fiId,@Param("time")Date time);
    
}