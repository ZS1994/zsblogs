package com.zs.controller.rest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import com.zs.controller.rest.BaseRestController.Code;
import com.zs.entity.other.Result;
import com.zs.tools.CrawlerNo1;
import com.zs.tools.Trans;
import com.zs.tools.mail.MailManager;
import com.zs.tools.mail.MailModel;

@RestController
@RequestMapping("/api/crawler")
public class CrawlerConR {

	private MailManager mail=MailManager.getInstance();
	
	
	@RequestMapping(value="/control",method=RequestMethod.GET)
	public Result<String> crawlerControl(Boolean isBegin,HttpServletRequest req, HttpServletResponse resp){
		if (isBegin!=null) {
			try {
				CrawlerNo1 no1=CrawlerNo1.getInstance();
				if(isBegin){
					no1.begin();
					return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, "爬虫机器人1号已开启");
				}else {
					no1.finish();
					return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, "爬虫机器人1号已关闭");
				}
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e), MailManager.TITLE));
				return new Result<String>(BaseRestController.ERROR, Code.ERROR, null);
			}
		}
		return new Result<String>(BaseRestController.ERROR, Code.ERROR, null);
	}
	
	@RequestMapping(value="/addurl",method=RequestMethod.POST)
	public Result<String> addUrl(String url,HttpServletRequest req, HttpServletResponse resp){
		if (url!=null) {
			try {
				CrawlerNo1 no1=CrawlerNo1.getInstance();
				no1.addUrl(url);
				return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, "爬虫机器人1号已添加"+url+"到爬取列表");
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e), MailManager.TITLE));
				return new Result<String>(BaseRestController.ERROR, Code.ERROR, Trans.strToHtml(e));
			}
		}
		return new Result<String>(BaseRestController.ERROR, Code.ERROR, null);
	}
	
	@RequestMapping(value="/info",method=RequestMethod.GET)
	public Result<CrawlerNo1> info(HttpServletRequest req, HttpServletResponse resp){
		try {
			CrawlerNo1 no1=CrawlerNo1.getInstance();
			return new Result<CrawlerNo1>(BaseRestController.SUCCESS, Code.SUCCESS, no1);
		} catch (Exception e) {
			e.printStackTrace();
			mail.addMail(new MailModel(Trans.strToHtml(e), MailManager.TITLE));
			return new Result<CrawlerNo1>(BaseRestController.ERROR, Code.ERROR, null);
		}
	}
	
}
