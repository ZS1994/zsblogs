package com.zs.service.impl;

import java.util.Calendar;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.zs.dao.TokenMapper;
import com.zs.dao.UsersMapper;
import com.zs.entity.Token;
import com.zs.entity.Users;
import com.zs.service.LicenceSer;
import com.zs.tools.NameOfDate;

@Service("licenceSer")
public class LicenceSerImpl implements LicenceSer{

	@Resource
	private TokenMapper lcTokenMapper;
	@Resource
	private UsersMapper usersMapper;
	
	
	public Token geLcToken(String token) {
		return lcTokenMapper.selectByPrimaryKey(token);
	}


	public Token createToken(Users user) {
		user=usersMapper.selectByNumAndPass(user.getUsernum(),user.getUserpass());
		Calendar calendar=Calendar.getInstance();
		calendar.add(Calendar.DAY_OF_MONTH, 1);
		lcTokenMapper.deleteByUid(user.getId());
		Token lcToken=new Token(NameOfDate.getNum(), user.getId(), calendar.getTime());
		lcTokenMapper.insertSelective(lcToken);
		return lcToken;
	}


	public String updateToken(Token lcToken) {
		lcTokenMapper.updateByPrimaryKeySelective(lcToken);
		return null;
	}


	public Users getUserFromToken(String token) {
		if(token!=null){
			Token lcToken=lcTokenMapper.selectByPrimaryKey(token);
			if(lcToken!=null && lcToken.getuId()!=null){
				Users user=usersMapper.selectByPrimaryKey(lcToken.getuId());
				return user;
			}
		}
		return null;
	}
	
}
