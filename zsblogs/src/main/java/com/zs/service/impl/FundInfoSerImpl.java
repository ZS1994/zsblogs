package com.zs.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.zs.dao.FundInfoMapper;
import com.zs.entity.FundInfo;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.FundInfoSer;

@Service("fundInfoSer")
public class FundInfoSerImpl implements FundInfoSer{

	@Resource
	private FundInfoMapper fundInfoMapper;
	
	
	@Override
	public EasyUIPage queryFenye(EasyUIAccept accept) {
		if (accept!=null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list=fundInfoMapper.queryFenye(accept);
			int rows=fundInfoMapper.getCount(accept);
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	@Override
	public String add(FundInfo obj) {
		return String.valueOf(fundInfoMapper.insertSelective(obj));
	}

	@Override
	public String update(FundInfo obj) {
		return String.valueOf(fundInfoMapper.updateByPrimaryKeySelective(obj));
	}

	@Override
	public String delete(String id) {
		return String.valueOf(fundInfoMapper.deleteByPrimaryKey(id));
	}

	@Override
	public FundInfo get(String id) {
		FundInfo a=fundInfoMapper.selectByPrimaryKey(id);
		return a;
	}
	
	
	
}
