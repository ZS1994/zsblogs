package com.zs.controller.rest;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.zs.controller.rest.BaseRestController.Code;
import com.zs.entity.LcToken;
import com.zs.entity.Users;
import com.zs.entity.other.Result;
import com.zs.service.LicenceSer;
import com.zs.service.UserSer;
import com.zs.tools.Trans;
import com.zs.tools.mail.MailManager;
import com.zs.tools.mail.MailModel;

@RestController
@RequestMapping("/api/login")
public class LoginConR{

	@Resource
	private LicenceSer licenceSer;
	@Resource
	private UserSer userSer;
	
	private MailManager mail=MailManager.getInstance();
	
	
	@RequestMapping(value="/token",method=RequestMethod.POST)
	public Result<String> getToken(Users user,HttpServletRequest req, HttpServletResponse resp){
		if (user!=null) {
			try {
				if(user.getUsernumber()!=null && user.getUserpassword()!=null){
					if (userSer.validateUserInfo(user.getUsernumber(), user.getUserpassword())) {
						LcToken lcToken=licenceSer.createToken(user);
						return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, lcToken.getToken());
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(MailManager.MAIL_ZS, MailManager.MAIL_HGH, Trans.strToHtml(e.getMessage()), MailManager.TITLE));
				return new Result<String>(BaseRestController.ERROR, Code.ERROR, e.getMessage());
			}
		}
		return new Result<String>(BaseRestController.ERROR, Code.ERROR, "用户信息不全");
	}
	
}
