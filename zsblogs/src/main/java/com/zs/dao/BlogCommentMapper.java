package com.zs.dao;

import java.util.List;

import com.zs.entity.BlogComment;
import com.zs.entity.BlogList;
import com.zs.entity.other.EasyUIAccept;

public interface BlogCommentMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(BlogComment record);

    int insertSelective(BlogComment record);

    BlogComment selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(BlogComment record);

    int updateByPrimaryKey(BlogComment record);
    
    List<BlogComment> queryFenye(EasyUIAccept accept);
    int getCount(EasyUIAccept accept);
    
    int deleteByBid(Integer bid);
}