package com.zs.service.impl;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;
import com.zs.dao.BlogCommentMapper;
import com.zs.dao.BlogListMapper;
import com.zs.dao.BlogListRelMapper;
import com.zs.dao.BlogMapper;
import com.zs.dao.ReadMapper;
import com.zs.dao.UsersMapper;
import com.zs.entity.Blog;
import com.zs.entity.BlogList;
import com.zs.entity.BlogListRel;
import com.zs.entity.Read;
import com.zs.entity.Users;
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
	@Resource
	private ReadMapper readMapper;
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
			List list=blogMapper.queryFenye(accept);
			int rows=blogMapper.getCount(accept);
			
			for (Object obj : list) {
				//获取所属栏目
				Blog b=(Blog)obj;
				b.setUser(getAutorOfBlog(b.getId()));
				b.setBlogListNames(getBlogListNamesOfBlog(b.getId())[0]);
				//获取阅读次数
				EasyUIAccept accept2=new EasyUIAccept();
				accept2.setInt1(b.getId());
				b.setReadCount(readMapper.getCount(accept2));
			}
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
		String blIds[]=gson.fromJson(obj.getBlIds(), String[].class);
		blogListRelMapper.deleteByBlidOrBid(null, obj.getId());
		for (String s : blIds) {
			blogListRelMapper.insertSelective(new BlogListRel(Integer.valueOf(s), obj.getId()));
		}
		return String.valueOf(blogMapper.updateByPrimaryKeySelective(obj));
	}

	public String delete(Integer id) {
		//删阅读信息
		int i1=readMapper.deleteByBid(id);
		//删评论信息
		int i2=blogCommentMapper.deleteByBid(id);
		//删除博客和博客栏目关系
		int i3=blogListRelMapper.deleteByBlidOrBid(null, id);
		//删除博客
		int i4=blogMapper.deleteByPrimaryKey(id);
		return "删除了["+i1+"]条阅读信息、["+i2+"]条评论信息、["+i3+"]条博客和博客栏目关系、["+i4+"]条博客。";
	}

	public Blog get(Integer id) {
		Blog b=blogMapper.selectByPrimaryKey(id);
		b.setUser(getAutorOfBlog(b.getId()));
		b.setBlIds(getBlogListNamesOfBlog(b.getId())[1]);
		//获取阅读次数
		EasyUIAccept accept2=new EasyUIAccept();
		accept2.setInt1(b.getId());
		b.setReadCount(readMapper.getCount(accept2));
		return b;
	}

	/**
	 * 通过博客id获取作者信息
	 */
	public Users getAutorOfBlog(Integer bid) {
		if(bid!=null){
			List<BlogListRel> rels=blogListRelMapper.selectByBlidOrBid(null, bid);
			BlogListRel brel=rels.size()>0?rels.get(0):null;
			if(brel!=null){
				BlogList bl=blogListMapper.selectByPrimaryKey(brel.getBlId());
				if(bl!=null){
					Users user=usersMapper.selectByPrimaryKey(bl.getuId());
					return user;
				}
			}
		}
		return null;
	}

	public String[] getBlogListNamesOfBlog(Integer bid) {
		String ss[]=new String[2];
		if(bid!=null){
			List<BlogListRel> rels=blogListRelMapper.selectByBlidOrBid(null, bid);
			String blNames="";
			String blIds="";
			for (BlogListRel rel : rels) {
				BlogList bl=blogListMapper.selectByPrimaryKey(rel.getBlId());
				blNames=blNames+bl.getName()+",";
				blIds=blIds+bl.getId()+",";
			}
			blNames=blNames.lastIndexOf(",")>0?blNames.substring(0, blNames.lastIndexOf(",")):blNames;
			blIds=blIds.lastIndexOf(",")>0?blIds.substring(0, blIds.lastIndexOf(",")):blIds;
			ss[0]=blNames;
			ss[1]=blIds;;
			return ss;
		}
		return ss;
	}

	public String read(Integer uid, Integer bid) {
		return String.valueOf(readMapper.insertSelective(new Read(uid, bid)));
	}

	@Override
	public List<Blog> queryByTitle(String title) {
		return blogMapper.queryByTitle(title);
	}

	
}
