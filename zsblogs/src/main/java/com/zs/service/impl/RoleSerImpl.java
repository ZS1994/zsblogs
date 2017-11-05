package com.zs.service.impl;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;
import com.zs.controller.rest.BaseRestController;
import com.zs.controller.rest.BaseRestController.Code;
import com.zs.dao.PermissionMapper;
import com.zs.dao.RoleMapper;
import com.zs.entity.Permission;
import com.zs.entity.Role;
import com.zs.entity.Timeline;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.entity.other.Result;
import com.zs.interceptor.RoleInter;
import com.zs.service.LicenceSer;
import com.zs.service.PerSer;
import com.zs.service.RoleSer;
import com.zs.service.TimeLineSer;
import com.zs.service.UserSer;

@Service("roleSer")
public class RoleSerImpl implements RoleSer{
	@Resource
	private RoleMapper roleMapper;
	@Resource
	private PermissionMapper permissionMapper;
	
	@Resource
	private UserSer userSer;
	@Resource
	private PerSer perSer;
	@Resource
	private LicenceSer licenceSer;
	@Resource
	private TimeLineSer timeLineSer;
	private Gson gson=new Gson();
	private Logger log=Logger.getLogger(RoleInter.class);
	
	
	
	public EasyUIPage queryFenye(EasyUIAccept accept) {
		if (accept!=null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list=roleMapper.queryFenye(accept);
			int rows=roleMapper.getCount(accept);
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	public String add(Role obj) {
		return String.valueOf(roleMapper.insertSelective(obj));
	}

	public String update(Role obj) {
		return String.valueOf(roleMapper.updateByPrimaryKeySelective(obj));
	}

	public String delete(Integer id) {
		return String.valueOf(roleMapper.deleteByPrimaryKey(id));
	}

	public Role get(Integer id) {
		return roleMapper.selectByPrimaryKey(id);
	}

	public List<Permission> getMenus(String token) {
		Users u=licenceSer.getUserFromToken(token);
		if(u!=null && u.getRids()!=null){
			List<Role> roles=roleMapper.selectByIds(u.getRids());
			List<Permission> list=new ArrayList<Permission>();
			List<Permission> menus=new ArrayList<Permission>();
			if (roles!=null) {
				for(Role r:roles){
					if(r!=null && r.getPids()!=null){
						List<Permission> ltmp=permissionMapper.selectByPers(r.getPids());
						menus.removeAll(ltmp);
						menus.addAll(ltmp);
					}
				}
			}
			for (Permission menu : menus) {
				if (menu.getMenuParentId()==null) {
					list.add(initChildMenus(menu,menus));
				}
			}
			return list;
		}
		return null;
	}
	
	private Permission initChildMenus(Permission menu,List<Permission> list){
		List<Permission> li=new ArrayList<Permission>();
		for (Permission m : list) {
			if (m.getMenuParentId()!=null && m.getMenuParentId().equals(menu.getMenuParentId())) {
				li.add(initChildMenus(m,list));
			}
		}
		menu.setChildMenu(li);
		return menu;
	}

	public boolean isPerInRoles(Permission per,List<Role> roles){
		if(per!=null && roles!=null){
			for (Role role : roles) {
				if(role!=null && role.getPids()!=null){
					if((","+role.getPids()+",").contains(","+per.getId()+",")){
						return true;
					}
				}
			}
		}
		return false;
	}

	public List<Role> getRolesFromRids(String rids) {
		if(rids!=null){
			return roleMapper.selectByIds(rids);
		}
		return null;
	}

	@Override
	public List<Role> getAllRole() {
		return roleMapper.selectAll();
	}


}
