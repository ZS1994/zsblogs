package com.zs.controller.rest;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import com.zs.controller.rest.BaseRestController.Code;
import com.zs.entity.other.Result;
import com.zs.tools.CrawlerNo1;
import com.zs.tools.CrawlerNo2;
import com.zs.tools.CrawlerNo3;
import com.zs.tools.Trans;
import com.zs.tools.mail.MailManager;
import com.zs.tools.mail.MailModel;

@RestController
@RequestMapping("/api/crawler")
public class CrawlerConR {

	private MailManager mail=MailManager.getInstance();
	@Resource
	private CrawlerNo1 crawlerNo1;
	@Resource
	private CrawlerNo2 crawlerNo2;
	@Resource
	private CrawlerNo3 crawlerNo3;

	/**
	 * 开启或关闭某个爬虫
	 * @param isBegin 是否开启
	 * @param no 爬虫编号
	 * @param req
	 * @param resp
	 * @return
	 */
	@RequestMapping(value="/control",method=RequestMethod.GET)
	public Result<String> crawlerControl(Boolean isBegin,String no,HttpServletRequest req, HttpServletResponse resp){
		/*if (isBegin!=null && !Trans.StrEmpty(no)) {
			try {
				switch (no) {
				case "1":
					if(isBegin){
						crawlerNo1.begin();
					}else {
						crawlerNo1.finish();
					}
					break;
				case "2":
					if(isBegin){
						crawlerNo2.begin();
					}else {
						crawlerNo2.finish();
					}
					break;
				case "3":
					if(isBegin){
						crawlerNo3.begin();
					}else {
						crawlerNo3.finish();
					}
					break;
				default:
					break;
				}
				return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, "爬虫机器人"+no+"号已"+(isBegin?"开启":"关闭"));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return new Result<String>(BaseRestController.ERROR, Code.ERROR, null);
			}
		}*/
		return new Result<String>(BaseRestController.ERROR, Code.ERROR, null);
	}
	
	@RequestMapping(value="/addurl",method=RequestMethod.POST)
	public Result<String> addUrl(String url,HttpServletRequest req, HttpServletResponse resp){
		/*if (url!=null) {
			try {
				crawlerNo1.addUrl(url);
				return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, "爬虫机器人1号已添加"+url+"到爬取列表");
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return new Result<String>(BaseRestController.ERROR, Code.ERROR, Trans.strToHtml(e,req));
			}
		}*/
		return new Result<String>(BaseRestController.ERROR, Code.ERROR, null);
	}
	/*
	@RequestMapping(value="/info/1",method=RequestMethod.GET)
	public Result<CrawlerNo1> info1(HttpServletRequest req, HttpServletResponse resp){
		try {
			return new Result<CrawlerNo1>(BaseRestController.SUCCESS, Code.SUCCESS, crawlerNo1);
		} catch (Exception e) {
			e.printStackTrace();
			mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			return new Result<CrawlerNo1>(BaseRestController.ERROR, Code.ERROR, null);
		}
	}
	
	@RequestMapping(value="/info/2",method=RequestMethod.GET)
	public Result<CrawlerNo2> info2(HttpServletRequest req, HttpServletResponse resp){
		try {
			return new Result<CrawlerNo2>(BaseRestController.SUCCESS, Code.SUCCESS, crawlerNo2);
		} catch (Exception e) {
			e.printStackTrace();
			mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			return new Result<CrawlerNo2>(BaseRestController.ERROR, Code.ERROR, null);
		}
	}
	
	@RequestMapping(value="/info/3",method=RequestMethod.GET)
	public Result<CrawlerNo3> info3(HttpServletRequest req, HttpServletResponse resp){
		try {
			return new Result<CrawlerNo3>(BaseRestController.SUCCESS, Code.SUCCESS, crawlerNo3);
		} catch (Exception e) {
			e.printStackTrace();
			mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			return new Result<CrawlerNo3>(BaseRestController.ERROR, Code.ERROR, null);
		}
	}*/
}
