package com.zs.service.impl;


import java.util.List;

import javax.annotation.Resource;
import javax.transaction.Transactional;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.zs.dao.PermissionMapper;
import com.zs.dao.TimelineMapper;
import com.zs.dao.UsersMapper;
import com.zs.entity.Permission;
import com.zs.entity.Timeline;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.TimeLineSer;
import com.zs.tools.StopWatchUtil;

@Service("TimeLineSer")
public class TimeLineSerImpl implements TimeLineSer{

	@Resource
	private TimelineMapper timelineMapper;
	@Resource
	private UsersMapper usersMapper;
	@Resource
	private PermissionMapper permissionMapper;
	
	private Logger log = Logger.getLogger(getClass());
	
	public EasyUIPage queryFenye(EasyUIAccept accept) {
		if (accept!=null) {
			StopWatchUtil sw = new StopWatchUtil();
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			sw.start("开始进行分页查询");
			List list=timelineMapper.queryFenye(accept);
			int rows=timelineMapper.getCount(accept);
			sw.stop();
			sw.start("开始进行填充用户名处理");
			for (Object obj : list) {
				Timeline tl=(Timeline) obj;
				tl=handleUsersAndPermission(tl);
			}
			sw.stop();
			log.debug(sw.prettyPrint());
			
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	private Timeline handleUsersAndPermission(Timeline tl){
		if (tl!=null) {
			Users u=usersMapper.selectByPrimaryKey(tl.getuId());
			tl.setUser(u);
			Permission p=permissionMapper.selectByPrimaryKey(tl.getpId());
			tl.setPer(p);
		}
		return tl;
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
