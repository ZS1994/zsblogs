package com.zs.dao;

import java.util.List;
import com.zs.entity.Credit;
import com.zs.entity.other.EasyUIAccept;

public interface CreditMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Credit record);

    int insertSelective(Credit record);

    Credit selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Credit record);

    int updateByPrimaryKey(Credit record);
    
    List<Credit> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
    
}