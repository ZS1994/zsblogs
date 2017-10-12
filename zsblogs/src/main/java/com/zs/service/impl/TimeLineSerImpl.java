package com.zs.service.impl;


import java.util.List;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.zs.dao.TimelineMapper;
import com.zs.entity.Timeline;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.TimeLineSer;

@Service("TimeLineSer")
public class TimeLineSerImpl implements TimeLineSer{

	@Resource
	private TimelineMapper timelineMapper;
	
	public EasyUIPage queryFenye(EasyUIAccept accept) {
		if (accept!=null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list=timelineMapper.queryFenye(accept);
			int rows=timelineMapper.getCount(accept);
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	public String add(Timeline obj) {
		return String.valueOf(timelineMapper.insertSelective(obj));
	}

	public String update(Timeline obj) {
		return String.valueOf(timelineMapper.updateByPrimaryKeySelective(obj));
	}

	public String delete(Integer id) {
		return String.valueOf(timelineMapper.deleteByPrimaryKey(id));
	}

	public Timeline get(Integer id) {
		return timelineMapper.selectByPrimaryKey(id);
	}

}
