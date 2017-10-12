package com.zs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.zs.dao.BlogListMapper;
import com.zs.entity.BlogList;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.BlogListSer;

@Service("blogListSer")
public class BlogListSerImpl implements BlogListSer{

	@Resource
	private BlogListMapper blogListMapper;
	
	public EasyUIPage queryFenye(EasyUIAccept accept) {
		if (accept!=null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list=blogListMapper.queryFenye(accept);
			int rows=blogListMapper.getCount(accept);
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	public String add(BlogList obj) {
		return String.valueOf(blogListMapper.insertSelective(obj));
	}

	public String update(BlogList obj) {
		return String.valueOf(blogListMapper.updateByPrimaryKeySelective(obj));
	}

	public String delete(Integer id) {
		return String.valueOf(blogListMapper.deleteByPrimaryKey(id));
	}

	public BlogList get(Integer id) {
		return blogListMapper.selectByPrimaryKey(id);
	}

}
