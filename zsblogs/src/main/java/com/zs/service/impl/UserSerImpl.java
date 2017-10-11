package com.zs.service.impl;

import java.math.BigDecimal;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.zs.controller.rest.BaseRestController.Code;
import com.zs.dao.UsersMapper;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.UserSer;

@Service("userSer")
public class UserSerImpl implements UserSer{
	@Resource
	private UsersMapper usersMapper;
	
	public EasyUIPage queryFenye(EasyUIAccept accept) {
		// TODO Auto-generated method stub
		return null;
	}

	public String add(Users obj) {
		// TODO Auto-generated method stub
		return null;
	}

	public String update(Users obj) {
		// TODO Auto-generated method stub
		return null;
	}

	public String delete(BigDecimal id) {
		// TODO Auto-generated method stub
		return null;
	}

	public Users get(BigDecimal id) {
		return usersMapper.selectByPrimaryKey(id);
	}

	public boolean validateUserInfo(String usernumber, String userpassword) {
		System.out.println(usernumber+"  "+userpassword);
		Users user=usersMapper.selectByNumAndPass(usernumber, userpassword);
		if (user==null) {
			return false;
		}else{
			return true;
		}
	}

}
