package com.zs.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zs.entity.ApiDoc;
import com.zs.entity.ApiDocParameter;
import com.zs.entity.other.EasyUIAccept;

public interface ApiDocParameterMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(ApiDocParameter record);

    int insertSelective(ApiDocParameter record);

    ApiDocParameter selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(ApiDocParameter record);

    int updateByPrimaryKey(ApiDocParameter record);
    
    List<ApiDocParameter> selectByAdid(@Param("adId") Integer adId);
    
    List<ApiDocParameter> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
}