package com.zs.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.BlogList;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;

public interface UsersMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Users record);

    int insertSelective(Users record);

    Users selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Users record);

    int updateByPrimaryKey(Users record);
    
    Users selectByNumAndPass(@Param("num")String usernum,@Param("pass")String userpass);
    Users selectByNum(@Param("num")String usernum);
    
    List<Users> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
    
}