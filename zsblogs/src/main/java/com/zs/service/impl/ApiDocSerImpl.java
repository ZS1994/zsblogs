package com.zs.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.zs.dao.ApiDocMapper;
import com.zs.entity.ApiDoc;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.ApiDocSer;

@Service("apiDoc")
public class ApiDocSerImpl implements ApiDocSer{

	@Resource
	private ApiDocMapper apiDocMapper;
	
	
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
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	@Override
	public String add(ApiDoc obj) {
		return String.valueOf(apiDocMapper.insertSelective(obj));
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
		return a;
	}

}
