package com.zs.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.zs.dao.MenuMapper;
import com.zs.dao.PermissionMapper;
import com.zs.dao.RoleMapper;
import com.zs.entity.Menu;
import com.zs.entity.Role;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.RoleSer;

@Service("roleSer")
public class RoleSerImpl implements RoleSer{
	@Resource
	private RoleMapper roleMapper;
	@Resource
	private PermissionMapper permissionMapper;
	@Resource
	private MenuMapper menuMapper;
	
	
	public EasyUIPage queryFenye(EasyUIAccept accept) {
		// TODO Auto-generated method stub
		return null;
	}

	public String add(Role obj) {
		// TODO Auto-generated method stub
		return null;
	}

	public String update(Role obj) {
		// TODO Auto-generated method stub
		return null;
	}

	public String delete(BigDecimal id) {
		// TODO Auto-generated method stub
		return null;
	}

	public Role get(BigDecimal id) {
		return roleMapper.selectByPrimaryKey(id);
	}

	public List<Menu> getMenus(BigDecimal rId) {
		Role role=roleMapper.selectByPrimaryKey(rId);
		List<Menu> menus=menuMapper.selectByPers(role.getPers());
		List<Menu> list=new ArrayList<Menu>();
		for (Menu menu : menus) {
			if (menu.getpId()==null) {
				list.add(initChildMenus(menu,menus));
			}
		}
		return list;
	}
	
	private Menu initChildMenus(Menu menu,List<Menu> list){
		List<Menu> li=new ArrayList<Menu>();
		for (Menu m : list) {
			if (m.getpId()!=null && m.getpId().doubleValue()==menu.getId().doubleValue()) {
				li.add(initChildMenus(m,list));
			}
		}
		menu.setChildMenu(li);
		return menu;
	}

}
