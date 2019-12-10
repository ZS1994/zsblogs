package com.zs.dao;

import java.util.List;

import com.zs.entity.UsersRela;
import com.zs.entity.other.EasyUIAccept;

public interface UsersRelaMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(UsersRela record);

    int insertSelective(UsersRela record);

    UsersRela selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(UsersRela record);

    int updateByPrimaryKey(UsersRela record);
    
    
    List<UsersRela> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
}