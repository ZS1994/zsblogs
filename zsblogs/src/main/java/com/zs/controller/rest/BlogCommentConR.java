package com.zs.controller.rest;

import java.util.Date;
import java.util.HashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.Consts;
import org.apache.log4j.Logger;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.zs.entity.BlogComment;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.entity.other.Result;
import com.zs.service.BlogCommentSer;
import com.zs.tools.ColumnName;
import com.zs.tools.Constans;
import com.zs.tools.Trans;
import com.zs.tools.mail.MailManager;
import com.zs.tools.mail.MailModel;

@RestController
@RequestMapping("/api/blogComment")
public class BlogCommentConR extends BaseRestController<BlogComment, Integer>{

	private Logger log=Logger.getLogger(getClass());
	private MailManager mail=MailManager.getInstance();
	@Resource
	private BlogCommentSer blogCommentSer;
	
	
	@RequestMapping(value="/list",method=RequestMethod.GET)
	@Override
	public EasyUIPage doQuery(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp) {
		if (accept!=null) {
			try {
				Users user=Constans.getUserFromReq(req);
				accept.setSort(ColumnName.transToUnderline(accept.getSort()));
				return blogCommentSer.queryFenye(accept);
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e), MailManager.TITLE));
				return null;
			}
		}
		return null;
	}

	@RequestMapping(value="/one",method=RequestMethod.GET)
	@Override
	public Result<BlogComment> doGet(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<BlogComment>(SUCCESS, Code.SUCCESS, blogCommentSer.get(id));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e), MailManager.TITLE));
			}
		}
		return new Result<BlogComment>(ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="",method=RequestMethod.POST)
	@Override
	public Result<String> doAdd(BlogComment obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj!=null){
			try {
				Users user=Constans.getUserFromReq(req);
				obj.setCreateTime(new Date());
				obj.setuId(user!=null?user.getId():null);
				return new Result<String>(SUCCESS, Code.SUCCESS, blogCommentSer.add(obj));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e), MailManager.TITLE));
			}
		}
		return new Result<String>(ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="",method=RequestMethod.PUT)
	@Override
	public Result<String> doUpdate(BlogComment obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj!=null){
			try {
				return new Result<String>(SUCCESS, Code.SUCCESS, blogCommentSer.update(obj));
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
				return new Result<String>(SUCCESS, Code.SUCCESS, blogCommentSer.delete(id));
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
