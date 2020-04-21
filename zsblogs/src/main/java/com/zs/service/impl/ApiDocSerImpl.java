package com.zs.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.test.annotation.Rollback;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.zs.dao.ApiDocMapper;
import com.zs.dao.ApiDocParameterMapper;
import com.zs.dao.UsersMapper;
import com.zs.entity.ApiDoc;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.ApiDocSer;

@Service("apiDoc")
public class ApiDocSerImpl implements ApiDocSer{
	@Resource
	private UsersMapper usersMapper;
	@Resource
	private ApiDocMapper apiDocMapper;
	@Resource
	private ApiDocParameterMapper apiDocParameterMapper;
	
	
	@Override
	public EasyUIPage queryFenye(EasyUIAccept accept) {
		if (accept!=null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list=apiDocMapper.queryFenye(accept);
			int rows=apiDocMapper.getCount(accept);
			for (Object obj : list) {
				ApiDoc ad=(ApiDoc) obj;
				Users u=usersMapper.selectByPrimaryKey(ad.getuId());
				ad.setUser(u);
			}
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	@Override
	public String add(ApiDoc obj) {
		String res = String.valueOf(apiDocMapper.insertSelective(obj));
		//TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		int f = 1/0;
		obj.setName("测试");
		apiDocMapper.insertSelective(obj);
		
		return res;
	}

	@Override
	public String update(ApiDoc obj) {
		return String.valueOf(apiDocMapper.updateByPrimaryKeySelective(obj));
	}

	@Override
	public String delete(Integer id) {
		return String.valueOf(apiDocMapper.deleteByPrimaryKey(id));
	}

	@Override
	public ApiDoc get(Integer id) {
		ApiDoc a=apiDocMapper.selectByPrimaryKey(id);
		a.setParams(apiDocParameterMapper.selectByAdid(a.getId()));
		return a;
	}

}
