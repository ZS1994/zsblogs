package com.zs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.zs.dao.BlogMapper;
import com.zs.entity.Blog;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.BlogSer;

@Service("blogSer")
public class BlogSerImpl implements BlogSer{

	@Resource
	private BlogMapper blogMapper;
	
	public EasyUIPage queryFenye(EasyUIAccept accept) {
		if (accept!=null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list=blogMapper.queryFenye(accept);
			int rows=blogMapper.getCount(accept);
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	public String add(Blog obj) {
		return String.valueOf(blogMapper.insertSelective(obj));
	}

	public String update(Blog obj) {
		return String.valueOf(blogMapper.updateByPrimaryKeySelective(obj));
	}

	public String delete(Integer id) {
		return String.valueOf(blogMapper.deleteByPrimaryKey(id));
	}

	public Blog get(Integer id) {
		return blogMapper.selectByPrimaryKey(id);
	}

}
