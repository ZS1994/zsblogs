package com.zs.service;

import java.math.BigDecimal;
import com.zs.entity.Users;

public interface UserSer extends BaseService<Users, BigDecimal>{

	public boolean validateUserInfo(String usernumber,String userpassword);
	
}
