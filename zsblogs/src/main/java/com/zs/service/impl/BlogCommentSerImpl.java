package com.zs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.zs.dao.BlogCommentMapper;
import com.zs.dao.BlogMapper;
import com.zs.dao.UsersMapper;
import com.zs.entity.Blog;
import com.zs.entity.BlogComment;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.BlogCommentSer;
import com.zs.service.BlogSer;
import com.zs.tools.Constans;

@Service("blogComment")
public class BlogCommentSerImpl implements BlogCommentSer{

	@Resource
	private BlogCommentMapper blogCommentMapper;
	@Resource
	private UsersMapper usersMapper;
	@Resource
	private BlogMapper blogMapper;
	@Resource
	private BlogSer blogSer;
	
	
	
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
			Integer bid=accept.getInt1();
			if(bid!=null){
				Blog b=blogMapper.selectByPrimaryKey(bid);
				Users user=blogSer.getAutorOfBlog(b.getId());
				if(user!=null){
					for (Object obj : list) {
						BlogComment bc=(BlogComment)obj;
						if(bc.getuId()!=null && bc.getuId().equals(user.getId())){
							bc.setIsAutor(1);
						}else{
							bc.setIsAutor(0);
						}
						bc.setUser(usersMapper.selectByPrimaryKey(bc.getuId()));
					}
				}
			}
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
