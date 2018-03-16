package com.zs.controller.rest;

import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.zs.entity.Role;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.entity.other.Result;
import com.zs.service.RoleSer;
import com.zs.tools.ColumnName;
import com.zs.tools.Trans;
import com.zs.tools.mail.MailManager;
import com.zs.tools.mail.MailModel;

@RestController
@RequestMapping("/api/role")
public class RoleConR extends BaseRestController<Role, Integer>{

	@Resource
	private RoleSer roleSer;
	
	@RequestMapping(value="/list",method=RequestMethod.GET)
	@Override
	public EasyUIPage doQuery(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp) {
		if (accept!=null) {
			try {
				accept.setSort(ColumnName.transToUnderline(accept.getSort()));
				return roleSer.queryFenye(accept);
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return null;
			}
		}
		return null;
	}

	@RequestMapping(value="/all",method=RequestMethod.GET)
	public Result<List<Role>> getAllRole(HttpServletRequest req, HttpServletResponse resp){
		try {
			return new Result<List<Role>>(SUCCESS, Code.SUCCESS, roleSer.getAllRole());
		} catch (Exception e) {
			e.printStackTrace();
			mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
		}
		return new Result<List<Role>>(ERROR, Code.ERROR, null);
	}
	
	@RequestMapping(value="/one",method=RequestMethod.GET)
	@Override
	public Result<Role> doGet(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<Role>(SUCCESS, Code.SUCCESS, roleSer.get(id));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<Role>(ERROR, Code.ERROR, null);
	}
	
	@RequestMapping(value="",method=RequestMethod.POST)
	@Override
	public Result<String> doAdd(Role obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj!=null){
			try {
				return new Result<String>(SUCCESS, Code.SUCCESS, roleSer.add(obj));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<String>(ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="",method=RequestMethod.PUT)
	@Override
	public Result<String> doUpdate(Role obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj!=null && obj.getId()!=null){
			try {
				return new Result<String>(SUCCESS, Code.SUCCESS, roleSer.update(obj));
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
				if(id!=3){//这里保护id为3的角色，普通用户，因为这个角色是注册时的默认角色，不能被删，删了可能会导致程序不正常
					return new Result<String>(SUCCESS, Code.SUCCESS, roleSer.delete(id));
				}else{
					return new Result<String>(ERROR, Code.ERROR, "你还真试了！这个角色不能被删的，因为它是注册的默认角色，如果被删可能会导致程序异常。");
				}
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
