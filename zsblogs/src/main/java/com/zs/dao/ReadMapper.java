package com.zs.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.BlogList;
import com.zs.entity.Read;
import com.zs.entity.other.EasyUIAccept;

public interface ReadMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Read record);

    int insertSelective(Read record);

    Read selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Read record);

    int updateByPrimaryKey(Read record);
    
    List<Read> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
    
}