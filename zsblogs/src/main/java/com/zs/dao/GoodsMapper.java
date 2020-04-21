package com.zs.dao;

import java.util.List;
import com.zs.entity.Goods;
import com.zs.entity.other.EasyUIAccept;

public interface GoodsMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Goods record);

    int insertSelective(Goods record);

    Goods selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Goods record);

    int updateByPrimaryKey(Goods record);
    
    List<Goods> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
}