package com.zs.service.impl;


import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.zs.dao.RoleMapper;
import com.zs.dao.UsersMapper;
import com.zs.dao.UsersRelaMapper;
import com.zs.entity.Role;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.RoleSer;
import com.zs.service.UserSer;

@Service("userSer")
public class UserSerImpl implements UserSer{
	@Resource
	private UsersMapper usersMapper;
	@Resource
	private RoleMapper roleMapper;
	@Resource
	private UsersRelaMapper usersRelaMapper;
	@Resource
	private RoleSer roleSer;
	
	
	private Logger log=Logger.getLogger(getClass());
	
	public EasyUIPage queryFenye(EasyUIAccept accept) {
		if (accept!=null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list=usersMapper.queryFenye(accept);
			int rows=usersMapper.getCount(accept);
			for (Object obj : list) {
				Users u=(Users) obj;
				List<Role> rs=roleMapper.selectByIds(u.getRids());
				String str="";
				for (Role r : rs) {
					str=str+r.getName()+",";
				}
				str=!str.equals("")?str.substring(0, str.lastIndexOf(",")):"(角色名字无法获取)";
				u.setRoleNames(str);
			}
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	public String add(Users obj) {
		return String.valueOf(usersMapper.insertSelective(obj));
	}

	public String update(Users obj) {
		return String.valueOf(usersMapper.updateByPrimaryKeySelective(obj));
	}

	public String delete(Integer id) {
		return String.valueOf(usersMapper.deleteByPrimaryKey(id));
	}

	public Users get(Integer id) {
		Users user=usersMapper.selectByPrimaryKey(id);
		//组装角色名字
		if (user != null && user.getRids() != null){
			List<Role> roles=roleSer.getRolesFromRids(user.getRids());
			String str = "";
			for (Role r : roles) {
				str = str+r.getName() + ",";
			}
			str = str.substring(0, str.lastIndexOf(","));
			user.setRoleNames(str);
		}
		return user;
	}

	public boolean validateUserInfo(String usernumber, String userpassword) {
		log.warn(usernumber+"  "+userpassword);
		Users user=usersMapper.selectByNumAndPass(usernumber, userpassword);
		if (user==null) {
			return false;
		}else{
			return true;
		}
	}

	public String validateUserInfo2(String usernumber, String userpassword) {
		Users user=usersMapper.selectByNum(usernumber);
		if(user==null){
			return "该用户不存在";
		}else{
			if(user.getUserpass().equals(userpassword)){
				return "[success]";
			}else{
				return "密码错误";
			}
		}
	}

	@Override
	public Users getByNum(String num) {
		Users user = usersMapper.selectByNum(num);
		//组装角色名字
		if(user.getRoles() != null){
			String str = "";
			for (Role r : user.getRoles()) {
				str = str+r.getName() + ",";
			}
			str = str.substring(0, str.lastIndexOf(","));
			user.setRoleNames(str);
		}
		return user;
	}

}
