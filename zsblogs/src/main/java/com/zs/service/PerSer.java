package com.zs.service;


import com.zs.entity.Permission;

public interface PerSer extends BaseService<Permission, Integer>{

	public Permission get(String url,String method);
}
