package com.zs.service;

import com.zs.entity.BlogList;

import java.util.List;

public interface BlogListSer extends BaseService<BlogList, Integer> {

    public List<BlogList> queryAll(Integer uid);
}
