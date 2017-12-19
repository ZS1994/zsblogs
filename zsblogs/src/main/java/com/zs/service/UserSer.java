package com.zs.service;

import com.zs.entity.Users;

public interface UserSer extends BaseService<Users, Integer>{

	public boolean validateUserInfo(String usernumber,String userpassword);
	
	public String validateUserInfo2(String usernumber,String userpassword);
	
	
	public Users getByNum(String num);
}
