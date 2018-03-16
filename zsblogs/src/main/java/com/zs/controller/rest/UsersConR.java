package com.zs.controller.rest;


import java.util.Date;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.zs.controller.rest.BaseRestController.Code;
import com.zs.entity.Blog;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.entity.other.Result;
import com.zs.service.UserSer;
import com.zs.tools.ColumnName;
import com.zs.tools.Constans;
import com.zs.tools.Trans;
import com.zs.tools.mail.MailManager;
import com.zs.tools.mail.MailModel;

@RestController
@RequestMapping("/api/users")
public class UsersConR extends BaseRestController<Users, Integer>{

	private Logger log=Logger.getLogger(getClass());
	private MailManager mail=MailManager.getInstance();
	@Resource
	private UserSer userSer;
	
	@RequestMapping(value="/list",method=RequestMethod.GET)
	@Override
	public EasyUIPage doQuery(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp) {
		if (accept!=null) {
			try {
				accept.setSort(ColumnName.transToUnderline(accept.getSort()));
				return userSer.queryFenye(accept);
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return null;
			}
		}
		return null;
	}

	@RequestMapping(value="/one",method=RequestMethod.GET)
	@Override
	public Result<Users> doGet(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<Users>(SUCCESS, Code.SUCCESS, userSer.get(id));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<Users>(ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="",method=RequestMethod.POST)
	@Override
	public Result<String> doAdd(Users obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj!=null){
			try {
				if (obj.getCreateTime()==null) {
					obj.setCreateTime(new Date());
				} 
				return new Result<String>(SUCCESS, Code.SUCCESS, userSer.add(obj));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<String>(ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="",method=RequestMethod.PUT)
	@Override
	public Result<String> doUpdate(Users obj, HttpServletRequest req, HttpServletResponse resp) {
//		System.out.println(gson.toJson(obj));
		if(obj!=null && obj.getId()!=null){
			try {
				return new Result<String>(SUCCESS, Code.SUCCESS, userSer.update(obj));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<String>(ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="/one",method=RequestMethod.DELETE)
	@Override
	public Result<String> doDeleteFalse(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<String>(SUCCESS, Code.SUCCESS, userSer.delete(id));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<String>(ERROR, Code.ERROR, null);
	}

	@Override
	public Result<String> doDeleteTrue(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Result<String> excelExport(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Result<String> excelImport(MultipartFile file, HttpServletRequest req, HttpServletResponse resp) {
		// TODO Auto-generated method stub
		return null;
	}

}
