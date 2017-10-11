package com.zs.service.impl;

import java.util.Calendar;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.zs.dao.LcStackMapper;
import com.zs.dao.LcTokenMapper;
import com.zs.dao.UsersMapper;
import com.zs.entity.LcToken;
import com.zs.entity.Users;
import com.zs.service.LicenceSer;
import com.zs.tools.NameOfDate;

@Service("LicenceSer")
public class LicenceSerImpl implements LicenceSer{

	@Resource
	private LcStackMapper lcStackMapper;
	@Resource
	private LcTokenMapper lcTokenMapper;
	@Resource
	private UsersMapper usersMapper;
	
	
	public LcToken geLcToken(String token) {
		return lcTokenMapper.selectByPrimaryKey(token);
	}


	public LcToken createToken(Users user) {
		user=usersMapper.selectByNumAndPass(user.getUsernumber(),user.getUserpassword());
		Calendar calendar=Calendar.getInstance();
		calendar.add(Calendar.DAY_OF_MONTH, 1);
		lcTokenMapper.deleteByUid(user.getId());
		LcToken lcToken=new LcToken(NameOfDate.getNum(), user.getId(), calendar.getTime());
		lcTokenMapper.insertSelective(lcToken);
		return lcToken;
	}


	public String updateToken(LcToken lcToken) {
		lcTokenMapper.updateByPrimaryKeySelective(lcToken);
		return null;
	}
	
}
