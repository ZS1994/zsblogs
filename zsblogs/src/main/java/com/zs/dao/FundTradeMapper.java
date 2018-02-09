package com.zs.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.junit.runners.Parameterized.Parameters;

import com.zs.entity.FundHistory;
import com.zs.entity.FundInfo;
import com.zs.entity.FundTrade;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.TimeValueBean;

public interface FundTradeMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(FundTrade record);

    int insertSelective(FundTrade record);

    FundTrade selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(FundTrade record);

    int updateByPrimaryKey(FundTrade record);
    
    List<FundTrade> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
    
    List<TimeValueBean> obtainHistory(@Param("begin")Date begin,@Param("end")Date end,@Param("fiId")String fiId);
    
    List<TimeValueBean> obtainTrade(@Param("begin")Date begin,@Param("end")Date end,
    		@Param("fiId")String fiId,@Param("uid")Integer uid);
    
    
}