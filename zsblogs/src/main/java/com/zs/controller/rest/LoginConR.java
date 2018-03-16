package com.zs.controller.rest;

import java.util.Date;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import com.zs.controller.rest.BaseRestController.Code;
import com.zs.entity.Token;
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
				if(user.getUsernum()!=null && user.getUserpass()!=null){
					String str=userSer.validateUserInfo2(user.getUsernum(),user.getUserpass());
					if(str.equals("[success]")){
						Token lcToken=licenceSer.createToken(user);
						req.getSession().setAttribute("token", lcToken.getToken());
						return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, lcToken.getToken());
					}else{
						return new Result<String>(BaseRestController.ERROR, Code.ERROR, str);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(MailManager.MAIL_ZS, MailManager.MAIL_ZS, Trans.strToHtml(e.getMessage()), MailManager.TITLE));
				return new Result<String>(BaseRestController.ERROR, Code.ERROR, e.getMessage());
			}
		}
		return new Result<String>(BaseRestController.ERROR, Code.ERROR, "用户信息不全");
	}
	
	@RequestMapping(value="/token/clear",method=RequestMethod.DELETE)
	public Result<String> logout(HttpServletRequest req, HttpServletResponse resp){
		try {
			req.getSession().removeAttribute("token");
			return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, "登出成功");
		} catch (Exception e) {
			e.printStackTrace();
			mail.addMail(new MailModel(MailManager.MAIL_ZS, MailManager.MAIL_ZS, Trans.strToHtml(e,req), MailManager.TITLE));
			return new Result<String>(BaseRestController.ERROR, Code.ERROR, e.getMessage());
		}
	}
	
	@RequestMapping(value="/logup",method=RequestMethod.POST)
	public Result<String> logup(Users user,HttpServletRequest req, HttpServletResponse resp){
		if(user!=null){
			try {
				user.setCreateTime(new Date());
				user.setRids("3");//这里，切记，如果数据库中的普通用户改了，一定要记得这个也要跟着新的普通用户角色的id变
				return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, userSer.add(user));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(MailManager.MAIL_ZS, MailManager.MAIL_ZS, Trans.strToHtml(e,req), MailManager.TITLE));
				return new Result<String>(BaseRestController.ERROR, Code.ERROR, e.getMessage());
			}
		}
		return new Result<String>(BaseRestController.ERROR, Code.ERROR, "后台接收到的用户信息为空");
	}
}
