package com.zs.controller.rest;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.registry.infomodel.User;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.zs.controller.rest.BaseRestController.Code;
import com.zs.entity.Permission;
import com.zs.entity.Users;
import com.zs.entity.other.Result;
import com.zs.service.PerSer;
import com.zs.service.RoleSer;
import com.zs.service.UserSer;
import com.zs.tools.CrawlerNo1;
import com.zs.tools.HttpClientReq;
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
	
	@RequestMapping(value="/apitest",method=RequestMethod.POST)
	public Result<String> doTest(String url,String method,String data,String token){
		System.out.println(data);
		try {
			Map map=null;
			if (data!=null) {
				map=new Gson().fromJson(data, Map.class);
			}
			if (url!=null && method!=null) {
				String result="";
				switch (method) {
				case "GET":
					result=HttpClientReq.httpGet(url, null, map);
					break;
				case "POST":
					result=HttpClientReq.httpPost(url, null, map);
					break;
				case "PUT":
					result=HttpClientReq.httpPut(url, null, map);
					break;
				case "DELETE":
					result=HttpClientReq.httpDelete(url, null, map);
					break;
				default:
					break;
				}
				return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, result);
			}else{
				return new Result<String>(BaseRestController.ERROR, Code.ERROR, "url和method为必须参数，不能为空");
			}
		} catch (Exception e) {
			e.printStackTrace();
			mail.addMail(new MailModel(Trans.strToHtml(e), MailManager.TITLE));
			return new Result<String>(BaseRestController.ERROR, Code.ERROR, Trans.strToHtml(e));
		}
	}
}
