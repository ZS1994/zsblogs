package com.zs.controller.rest;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.registry.infomodel.User;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import com.zs.controller.rest.BaseRestController.Code;
import com.zs.entity.Permission;
import com.zs.entity.Users;
import com.zs.entity.other.Result;
import com.zs.service.PerSer;
import com.zs.service.RoleSer;
import com.zs.service.UserSer;
import com.zs.tools.Trans;
import com.zs.tools.mail.MailManager;
import com.zs.tools.mail.MailModel;

@RestController
@RequestMapping("/api/system")
public class SystemConR {
	private MailManager mail=MailManager.getInstance();
	@Resource
	private RoleSer roleSer;
	@Resource
	private PerSer perSer;
	@Resource
	private UserSer userSer;

	
	
	@RequestMapping(value="/user/menu",method=RequestMethod.GET)
	public Result<List<Permission>> getUserMenus(HttpServletRequest req, HttpServletResponse resp){
		Users user=(Users) req.getAttribute("[user]");
		if (user!=null) {
			try {
				if(user.getRids()!=null){
					return new Result<List<Permission>>(BaseRestController.SUCCESS, Code.SUCCESS, roleSer.getMenus(user.getRids()));
				}
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e), MailManager.TITLE));
				return new Result<List<Permission>>(BaseRestController.ERROR, Code.ERROR, null);
			}
		}
		return new Result<List<Permission>>(BaseRestController.ERROR, Code.ERROR, null);
	}
	
	
}
