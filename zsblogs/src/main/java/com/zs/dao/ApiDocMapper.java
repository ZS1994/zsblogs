package com.zs.dao;

import java.util.List;
import com.zs.entity.ApiDoc;
import com.zs.entity.other.EasyUIAccept;

public interface ApiDocMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(ApiDoc record);

    int insertSelective(ApiDoc record);

    ApiDoc selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(ApiDoc record);

    int updateByPrimaryKey(ApiDoc record);
    
    List<ApiDoc> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
}