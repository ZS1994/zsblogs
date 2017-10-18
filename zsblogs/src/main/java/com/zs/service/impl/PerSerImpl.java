package com.zs.service.impl;

import java.math.BigDecimal;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.zs.dao.PermissionMapper;
import com.zs.entity.Permission;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.PerSer;

@Service("perSer")
public class PerSerImpl implements PerSer{

	@Resource
	private PermissionMapper permissionMapper;
	
	public EasyUIPage queryFenye(EasyUIAccept accept) {
		if (accept!=null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list=permissionMapper.queryFenye(accept);
			int rows=permissionMapper.getCount(accept);
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	public String add(Permission obj) {
		return String.valueOf(permissionMapper.insertSelective(obj));
	}

	public String update(Permission obj) {
		return String.valueOf(permissionMapper.updateByPrimaryKeySelective(obj));
	}

	public String delete(Integer id) {
		return String.valueOf(permissionMapper.deleteByPrimaryKey(id));
	}

	public Permission get(Integer id) {
		return permissionMapper.selectByPrimaryKey(id);
	}

	public Permission get(String url, String method) {
		Permission permission=null;
		permission=permissionMapper.selectByUrlAndMethodEqual(url, method);
		return permission;
	}

}
