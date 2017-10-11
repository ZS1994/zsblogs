package com.zs.service;

import com.zs.entity.LcToken;
import com.zs.entity.Users;

public interface LicenceSer {

	public LcToken geLcToken(String token);
	
	public LcToken createToken(Users user);
	
	public String updateToken(LcToken lcToken);
}
