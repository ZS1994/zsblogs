package com.zs.service.impl;

import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.zs.dao.FundHistoryMapper;
import com.zs.dao.FundInfoMapper;
import com.zs.entity.FundHistory;
import com.zs.entity.FundInfo;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.FundHistroySer;

@Service("fundHistroySer")
public class FundHistorySerImpl implements FundHistroySer{

	@Resource
	private FundHistoryMapper fundHistoryMapper;
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
			List list=fundHistoryMapper.queryFenye(accept);
			int rows=fundHistoryMapper.getCount(accept);
			for (Object obj : list) {
				FundHistory fh=(FundHistory) obj;
				fh.setFi(fundInfoMapper.selectByPrimaryKey(fh.getFiId()));
			}
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	@Override
	public String add(FundHistory obj) {
		return String.valueOf(fundHistoryMapper.insertSelective(obj));
	}

	@Override
	public String update(FundHistory obj) {
		return String.valueOf(fundHistoryMapper.updateByPrimaryKeySelective(obj));
	}

	@Override
	public String delete(Integer id) {
		return String.valueOf(fundHistoryMapper.deleteByPrimaryKey(id));
	}

	@Override
	public FundHistory get(Integer id) {
		FundHistory fh=fundHistoryMapper.selectByPrimaryKey(id);
		fh.setFi(fundInfoMapper.selectByPrimaryKey(fh.getFiId()));
		return fh;
	}

}
