package com.zs.dao;

import com.zs.entity.BlogList;
import com.zs.entity.other.EasyUIAccept;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BlogListMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(BlogList record);

    int insertSelective(BlogList record);

    BlogList selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(BlogList record);

    int updateByPrimaryKey(BlogList record);

    /**
     * 分页查询博客栏目
     * int1:用户id
     * int2：博客id
     * str1：博客标题后模糊查询
     *
     * @param accept
     * @return
     */
    List<BlogList> queryFenye(EasyUIAccept accept);

    int getCount(EasyUIAccept accept);

    /**
     * 查询某个用户所有的博客栏目
     *
     * @param uid
     * @return
     */
    List<BlogList> queryAll(@Param("uid") Integer uid);

    int deleteBlogsOfDeleteBloglist(@Param("blId") Integer blId);
}