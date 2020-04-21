package com.zs.dao;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.zs.entity.TransactionDetail;

public interface TransactionDetailMapper {
    int insert(TransactionDetail record);

    int insertSelective(TransactionDetail record);
    
    List<TransactionDetail> queryAllDetByTra(@Param("traId")Integer traId);
    
    int deleteByTra(@Param("traId")Integer traId);
    
}