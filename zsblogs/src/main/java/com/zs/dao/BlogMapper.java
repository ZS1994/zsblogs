package com.zs.dao;

import com.zs.entity.Blog;
import com.zs.entity.other.EasyUIAccept;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BlogMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Blog record);

    int insertSelective(Blog record);

    Blog selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Blog record);

    int updateByPrimaryKeyWithBLOBs(Blog record);

    int updateByPrimaryKey(Blog record);

    /**
     * 分页查询博客
     * int1：是否隐藏
     * int2：查看某个用户的
     * int3：查看某个栏目的
     * str1：通过博客标题、栏目、摘要、作者名称模糊查询
     * str2：通过博客摘要模糊查询
     * date1：时间范围开始时间
     * date2：时间范围结束时间
     *
     * @param accept
     * @return
     */
    List<Blog> queryFenye(EasyUIAccept accept);

    int getCount(EasyUIAccept accept);

    List<Blog> queryByTitle(String title);

    /**
     * 未上传微信公众号的博客
     *
     * @return
     */
    Blog queryNoUploadWeBlog();

    /**
     * 查询博客年份TOP N
     *
     * @param top
     * @return
     */
    List<String> selectGroupByYear(@Param("top") int top);
}