package com.zs.dao;

import java.util.List;
import com.zs.entity.Bill;
import com.zs.entity.other.EasyUIAccept;

public interface BillMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Bill record);

    int insertSelective(Bill record);

    Bill selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Bill record);

    int updateByPrimaryKey(Bill record);
    
    List<Bill> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);

    //根据交易单删除账单
    int deleteByTraId(Integer traId);
}