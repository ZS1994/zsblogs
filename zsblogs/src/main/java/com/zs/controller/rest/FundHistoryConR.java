package com.zs.controller.rest;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.zs.entity.FundHistory;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.entity.other.Result;
import com.zs.service.FundHistroySer;
import com.zs.tools.ColumnName;
import com.zs.tools.Trans;
import com.zs.tools.mail.MailManager;
import com.zs.tools.mail.MailModel;

@RestController
@RequestMapping("/api/fundHistory")
public class FundHistoryConR extends BaseRestController<FundHistory, Integer>{

	@Resource
	private FundHistroySer fundHistroySer;
	
	@RequestMapping(value="/list",method=RequestMethod.GET)
	@Override
	public EasyUIPage doQuery(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp) {
		if (accept!=null) {
			try {
				accept.setSort(ColumnName.transToUnderline(accept.getSort()));
				return fundHistroySer.queryFenye(accept);
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
	public Result<FundHistory> doGet(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<FundHistory>(SUCCESS, Code.SUCCESS, fundHistroySer.get(id));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return new Result<FundHistory>(ERROR, Code.ERROR, null,Trans.strToHtml(e,req));
			}
		}
		return new Result<FundHistory>(ERROR, Code.ERROR, null,"接口传入参数为空");
	}
	@RequestMapping(value="",method=RequestMethod.POST)
	@Override
	public Result<String> doAdd(FundHistory obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj!=null){
			try {
				return new Result<String>(SUCCESS, Code.SUCCESS, fundHistroySer.add(obj));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return new Result<String>(ERROR, Code.ERROR, null,Trans.strToHtml(e,req));
			}
		}
		return new Result<String>(ERROR, Code.ERROR, null,"接口传入参数为空");
	}
	@RequestMapping(value="",method=RequestMethod.PUT)
	@Override
	public Result<String> doUpdate(FundHistory obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj!=null && obj.getId()!=null){
			try {
				return new Result<String>(SUCCESS, Code.SUCCESS, fundHistroySer.update(obj));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return new Result<String>(ERROR, Code.ERROR, null,Trans.strToHtml(e,req));
			}
		}
		return new Result<String>(ERROR, Code.ERROR, null,"接口传入参数为空");
	}
	@RequestMapping(value="/one",method=RequestMethod.DELETE)
	@Override
	public Result<String> doDeleteFalse(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<String>(SUCCESS, Code.SUCCESS, fundHistroySer.delete(id));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return new Result<String>(ERROR, Code.ERROR, null,Trans.strToHtml(e,req));
			}
		}
		return new Result<String>(ERROR, Code.ERROR, null,"接口传入参数为空");
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
