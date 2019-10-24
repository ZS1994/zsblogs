package com.zs.test;


import javax.annotation.Resource;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.zs.dao.BlogMapper;
import com.zs.dao.TokenMapper;
import com.zs.dao.UsersMapper;
import com.zs.entity.Users;
import com.zs.service.BlogSer;
import com.zs.tools.StopWatchUtil;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:spring-mybatis.xml"})
public class Test{

	@Resource
	private UsersMapper userMapper;
	@Resource
	private TokenMapper tokenMapper;
	@Resource
	private BlogMapper blogMapper;
	
	
	
	public void test(){
		Users user=userMapper.selectByNum("yd7111");
		System.out.println(user.getName());
		
		int size=blogMapper.queryByTitle("美团点评智能支付核心交易系统的可用性实践 - 美团技术团队").size();
		System.out.println(size);
	}
	
}
