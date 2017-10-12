package com.zs.service;

import java.util.List;

import com.zs.entity.Permission;
import com.zs.entity.Role;

public interface RoleSer extends BaseService<Role, Integer>{

	public List<Permission> getMenus(String token);
	
	public boolean isPerInRoles(Permission per,List<Role> roles);
	
	public List<Role> getRolesFromRids(String rids);
	
}
