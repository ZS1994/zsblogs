package com.zs.service.impl;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;
import com.zs.dao.BlogListMapper;
import com.zs.dao.BlogListRelMapper;
import com.zs.dao.BlogMapper;
import com.zs.dao.UsersMapper;
import com.zs.entity.Blog;
import com.zs.entity.BlogListRel;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.BlogSer;

@Service("blogSer")
public class BlogSerImpl implements BlogSer{

	private Logger log=Logger.getLogger(getClass());
	private Gson gson=new Gson();
	
	@Resource
	private BlogListRelMapper blogListRelMapper;
	@Resource
	private BlogListMapper blogListMapper;
	@Resource
	private UsersMapper usersMapper;
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
			for (Object obj : list) {
				Blog b=(Blog)obj;
				List<BlogListRel> rels=blogListRelMapper.selectByBlidOrBid(null, b.getId());
				BlogListRel rel=rels.size()>0?rels.get(0):null;
				if(rel!=null){
					b.setUser(usersMapper.selectByPrimaryKey(blogListMapper.selectByPrimaryKey(rel.getBlId()).getuId()));
				}
			}
			int rows=blogMapper.getCount(accept);
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	public String add(Blog obj) {
		obj.setCreateTime(new Date());
		int rows=blogMapper.insertSelective(obj);
		String blIds[]=gson.fromJson(obj.getBlIds(), String[].class);
		for (String s : blIds) {
			blogListRelMapper.insertSelective(new BlogListRel(Integer.valueOf(s), obj.getId()));
		}
		return String.valueOf(obj.getId());
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
