package com.zs.service.impl;

import java.math.BigDecimal;

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
		// TODO Auto-generated method stub
		return null;
	}

	public String add(Permission obj) {
		// TODO Auto-generated method stub
		return null;
	}

	public String update(Permission obj) {
		// TODO Auto-generated method stub
		return null;
	}

	public String delete(BigDecimal id) {
		// TODO Auto-generated method stub
		return null;
	}

	public Permission get(BigDecimal id) {
		// TODO Auto-generated method stub
		return null;
	}

	public Permission get(String url, String method) {
		return permissionMapper.selectByUrlAndMethod(url, method);
	}

}
