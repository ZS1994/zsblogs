package com.zs.service.impl;


import java.util.List;
import javax.annotation.Resource;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import com.zs.dao.UsersRelaMapper;
import com.zs.entity.Users;
import com.zs.entity.UsersRela;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.UsersRelaSer;

@Service("UsersRelaSer")
public class UsersRelaSerImpl implements UsersRelaSer{
	@Resource
	private UsersRelaMapper usersRelaMapper;
	
	
	private Logger log=Logger.getLogger(getClass());
	
	public EasyUIPage queryFenye(EasyUIAccept accept) {
		if (accept!=null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list=usersRelaMapper.queryFenye(accept);
			int rows=usersRelaMapper.getCount(accept);
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	@Override
	public String add(UsersRela obj) {
		int i = usersRelaMapper.insertSelective(obj);
		return i==1?"添加成功":"添加失败";
	}

	@Override
	public String update(UsersRela obj) {
		return String.valueOf(usersRelaMapper.updateByPrimaryKeySelective(obj));
	}

	@Override
	public String delete(Integer id) {
		return String.valueOf(usersRelaMapper.deleteByPrimaryKey(id));
	}

	@Override
	public UsersRela get(Integer id) {
		return usersRelaMapper.selectByPrimaryKey(id);
	}

}
