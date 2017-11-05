package com.zs.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.BlogList;
import com.zs.entity.Role;
import com.zs.entity.other.EasyUIAccept;

public interface RoleMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Role record);

    int insertSelective(Role record);

    Role selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Role record);

    int updateByPrimaryKey(Role record);
    
    List<Role> selectByIds(@Param("rids")String rids);
    
    List<Role> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
    
    List<Role> selectAll();
    
}