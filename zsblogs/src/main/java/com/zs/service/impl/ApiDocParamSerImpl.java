package com.zs.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.zs.dao.ApiDocMapper;
import com.zs.dao.ApiDocParameterMapper;
import com.zs.entity.ApiDocParameter;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.ApiDocParamSer;

@Service("apiDocParamSer")
public class ApiDocParamSerImpl implements ApiDocParamSer{

	@Resource
	private ApiDocParameterMapper apiDocParameterMapper;
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
			List list=apiDocParameterMapper.queryFenye(accept);
			int rows=apiDocParameterMapper.getCount(accept);
			for (Object obj : list) {
				ApiDocParameter adp=(ApiDocParameter) obj;
				adp.setApiDoc(apiDocMapper.selectByPrimaryKey(adp.getAdId()));
			}
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	@Override
	public String add(ApiDocParameter obj) {
		return String.valueOf(apiDocParameterMapper.insertSelective(obj));
	}

	@Override
	public String update(ApiDocParameter obj) {
		return String.valueOf(apiDocParameterMapper.updateByPrimaryKeySelective(obj));
	}

	@Override
	public String delete(Integer id) {
		return String.valueOf(apiDocParameterMapper.deleteByPrimaryKey(id));
	}

	@Override
	public ApiDocParameter get(Integer id) {
		ApiDocParameter a=apiDocParameterMapper.selectByPrimaryKey(id);
		return a;
	}

}
