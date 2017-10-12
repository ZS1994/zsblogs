package com.zs.service;

import com.zs.entity.Token;
import com.zs.entity.Users;

public interface LicenceSer {

	public Token geLcToken(String token);
	
	public Token createToken(Users user);
	
	public String updateToken(Token token);
	
	public Users getUserFromToken(String token);
	
}
