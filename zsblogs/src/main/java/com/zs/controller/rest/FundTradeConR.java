package com.zs.controller.rest;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.zs.controller.rest.BaseRestController.Code;
import com.zs.entity.FundInfo;
import com.zs.entity.FundTrade;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.entity.other.FundProfit;
import com.zs.entity.other.Result;
import com.zs.service.FundTradeSer;
import com.zs.tools.ColumnName;
import com.zs.tools.Constans;
import com.zs.tools.Trans;
import com.zs.tools.mail.MailManager;
import com.zs.tools.mail.MailModel;

@RestController
@RequestMapping("/api/fundTrade")
public class FundTradeConR extends BaseRestController<FundTrade, Integer>{

	@Resource
	private FundTradeSer fundTradeSer;
	
	@RequestMapping(value="/list",method=RequestMethod.GET)
	@Override
	public EasyUIPage doQuery(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp) {
		if (accept!=null) {
			try {
				accept.setSort(ColumnName.transToUnderline(accept.getSort()));
				return fundTradeSer.queryFenye(accept);
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
	public Result<FundTrade> doGet(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<FundTrade>(SUCCESS, Code.SUCCESS, fundTradeSer.get(id));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return new Result<FundTrade>(ERROR, Code.ERROR, null,Trans.strToHtml(e,req));
			}
		}
		return new Result<FundTrade>(ERROR, Code.ERROR, null,"接口传入参数为空");
	}
	@RequestMapping(value="",method=RequestMethod.POST)
	@Override
	public Result<String> doAdd(FundTrade obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj!=null){
			try {
				Users u=(Users) req.getAttribute(Constans.USER);
				obj.setuId(u.getId());
				return new Result<String>(SUCCESS, Code.SUCCESS, fundTradeSer.add(obj));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return new Result<String>(ERROR, Code.ERROR, null,Trans.strToHtml(e,req));
			}
		}
		return new Result<String>(ERROR, Code.ERROR, "接口传入参数为空");
	}
	@RequestMapping(value="",method=RequestMethod.PUT)
	@Override
	public Result<String> doUpdate(FundTrade obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj!=null && obj.getId()!=null){
			try {
				return new Result<String>(SUCCESS, Code.SUCCESS, fundTradeSer.update(obj));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return new Result<String>(ERROR, Code.ERROR, null,Trans.strToHtml(e,req));
			}
		}
		return new Result<String>(ERROR, Code.ERROR, "接口传入参数为空");
	}
	@RequestMapping(value="/one",method=RequestMethod.DELETE)
	@Override
	public Result<String> doDeleteFalse(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<String>(SUCCESS, Code.SUCCESS, fundTradeSer.delete(id));
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

	@RequestMapping(value="/profit",method=RequestMethod.POST)
	public Result<FundProfit> obtainProfit(EasyUIAccept accept,HttpServletRequest req, HttpServletResponse resp) {
		if (accept!=null) {
			try {
				return new Result<FundProfit>(SUCCESS,Code.SUCCESS,fundTradeSer.obtainProfit(accept.getInt1(), accept.getStr1(), accept.getDate1(), accept.getDate2()));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return new Result<FundProfit>(ERROR, Code.ERROR, null,Trans.strToHtml(e,req));
			}
		}
		return new Result<FundProfit>(ERROR, Code.ERROR, null,"接口传入参数为空");
	}
	
}
