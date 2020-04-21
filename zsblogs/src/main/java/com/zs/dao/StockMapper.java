package com.zs.dao;

import java.util.List;

import com.zs.entity.Stock;
import com.zs.entity.other.EasyUIAccept;

public interface StockMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Stock record);

    int insertSelective(Stock record);

    Stock selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Stock record);

    int updateByPrimaryKey(Stock record);
    
    List<Stock> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
}