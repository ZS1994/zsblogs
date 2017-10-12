package com.zs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.zs.dao.BlogCommentMapper;
import com.zs.entity.BlogComment;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.BlogCommentSer;

@Service("blogComment")
public class BlogCommentSerImpl implements BlogCommentSer{

	@Resource
	private BlogCommentMapper blogCommentMapper;
	
	public EasyUIPage queryFenye(EasyUIAccept accept) {
		if (accept!=null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list=blogCommentMapper.queryFenye(accept);
			int rows=blogCommentMapper.getCount(accept);
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	public String add(BlogComment obj) {
		return String.valueOf(blogCommentMapper.insertSelective(obj));
	}

	public String update(BlogComment obj) {
		return String.valueOf(blogCommentMapper.updateByPrimaryKeySelective(obj));
	}

	public String delete(Integer id) {
		return String.valueOf(blogCommentMapper.deleteByPrimaryKey(id));
	}

	public BlogComment get(Integer id) {
		return blogCommentMapper.selectByPrimaryKey(id);
	}

}
