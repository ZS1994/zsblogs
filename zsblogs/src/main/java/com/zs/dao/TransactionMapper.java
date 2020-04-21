package com.zs.dao;

import java.util.List;
import com.zs.entity.Transaction;
import com.zs.entity.other.EasyUIAccept;

public interface TransactionMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Transaction record);

    int insertSelective(Transaction record);

    Transaction selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Transaction record);

    int updateByPrimaryKey(Transaction record);
    
    List<Transaction> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
}