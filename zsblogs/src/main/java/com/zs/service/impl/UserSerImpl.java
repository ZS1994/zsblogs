package com.zs.service.impl;


import java.util.List;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import com.zs.dao.UsersMapper;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.UserSer;

@Service("userSer")
public class UserSerImpl implements UserSer{
	@Resource
	private UsersMapper usersMapper;
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
		return usersMapper.selectByPrimaryKey(id);
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

}
