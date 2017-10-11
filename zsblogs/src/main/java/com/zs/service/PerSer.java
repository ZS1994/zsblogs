package com.zs.service;

import java.math.BigDecimal;

import com.zs.entity.Permission;

public interface PerSer extends BaseService<Permission, BigDecimal>{

	public Permission get(String url,String method);
}
