package com.zs.service;

import java.math.BigDecimal;
import java.util.List;

import com.zs.entity.Menu;
import com.zs.entity.Role;

public interface RoleSer extends BaseService<Role, BigDecimal>{

	public List<Menu> getMenus(BigDecimal rId);
	
}
