package com.zs.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.zs.dao.UsersMapper;
import com.zs.service.TestSer;

@Service("testSer")
public class TestSerImpl implements TestSer{

	@Resource
	private UsersMapper usersMapper;
	
	@Override
	public String transactionTest() {
		
		System.out.print("【我执行了】");
		
		return null;
	}

}
