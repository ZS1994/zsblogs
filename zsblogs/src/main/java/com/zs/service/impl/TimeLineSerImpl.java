package com.zs.service.impl;

import java.math.BigDecimal;

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
		// TODO Auto-generated method stub
		return null;
	}

	public String add(Timeline obj) {
		return timelineMapper.insertSelective(obj)+"";
	}

	public String update(Timeline obj) {
		// TODO Auto-generated method stub
		return null;
	}

	public String delete(BigDecimal id) {
		// TODO Auto-generated method stub
		return null;
	}

	public Timeline get(BigDecimal id) {
		// TODO Auto-generated method stub
		return null;
	}

}
