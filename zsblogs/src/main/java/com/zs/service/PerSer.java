package com.zs.service;


import java.util.List;

import com.zs.entity.Permission;

public interface PerSer extends BaseService<Permission, Integer>{

	public Permission get(String url,String method);
	
	
	public List<Permission> getAllPermission();
}
