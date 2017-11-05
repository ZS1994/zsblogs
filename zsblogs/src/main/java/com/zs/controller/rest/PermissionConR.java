package com.zs.controller.rest;

import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.zs.entity.Permission;
import com.zs.entity.Role;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.entity.other.Result;
import com.zs.service.PerSer;
import com.zs.service.RoleSer;
import com.zs.tools.ColumnName;
import com.zs.tools.Trans;
import com.zs.tools.mail.MailManager;
import com.zs.tools.mail.MailModel;

@RestController
@RequestMapping("/api/permission")
public class PermissionConR extends BaseRestController<Permission, Integer>{

	@Resource
	private PerSer perSer;
	
	@RequestMapping(value="/list",method=RequestMethod.GET)
	@Override
	public EasyUIPage doQuery(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp) {
		if (accept!=null) {
			try {
				accept.setSort(ColumnName.transToUnderline(accept.getSort()));
				return perSer.queryFenye(accept);
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e), MailManager.TITLE));
				return null;
			}
		}
		return null;
	}

	@RequestMapping(value="/all",method=RequestMethod.GET)
	public Result<List<Permission>> getAllRole(){
		try {
			return new Result<List<Permission>>(SUCCESS, Code.SUCCESS, perSer.getAllPermission());
		} catch (Exception e) {
			e.printStackTrace();
			mail.addMail(new MailModel(Trans.strToHtml(e), MailManager.TITLE));
		}
		return new Result<List<Permission>>(ERROR, Code.ERROR, null);
	}
	
	@RequestMapping(value="/one",method=RequestMethod.GET)
	@Override
	public Result<Permission> doGet(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<Permission>(SUCCESS, Code.SUCCESS, perSer.get(id));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e), MailManager.TITLE));
			}
		}
		return new Result<Permission>(ERROR, Code.ERROR, null);
	}
	
	@RequestMapping(value="",method=RequestMethod.POST)
	@Override
	public Result<String> doAdd(Permission obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj!=null){
			try {
				return new Result<String>(SUCCESS, Code.SUCCESS, perSer.add(obj));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e), MailManager.TITLE));
			}
		}
		return new Result<String>(ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="",method=RequestMethod.PUT)
	@Override
	public Result<String> doUpdate(Permission obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj!=null && obj.getId()!=null){
			try {
				return new Result<String>(SUCCESS, Code.SUCCESS, perSer.update(obj));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e), MailManager.TITLE));
			}
		}
		return new Result<String>(ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="/one",method=RequestMethod.DELETE)
	@Override
	public Result<String> doDeleteFalse(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<String>(SUCCESS, Code.SUCCESS, perSer.delete(id));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e), MailManager.TITLE));
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
