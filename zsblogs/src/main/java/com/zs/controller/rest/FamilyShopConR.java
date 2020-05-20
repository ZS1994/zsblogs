package com.zs.controller.rest;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import com.zs.controller.rest.BaseRestController.Code;
import com.zs.entity.Bill;
import com.zs.entity.Credit;
import com.zs.entity.Goods;
import com.zs.entity.Stock;
import com.zs.entity.Transaction;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.entity.other.Result;
import com.zs.service.FamilyShopSer;
import com.zs.tools.ColumnName;
import com.zs.tools.Trans;
import com.zs.tools.mail.MailManager;
import com.zs.tools.mail.MailModel;

@RestController
@RequestMapping("/api/familyshop")
public class FamilyShopConR{
	
	@Resource
	private FamilyShopSer familyShopSer;
	private MailManager mail = MailManager.getInstance();
	
	
	//-----------------------货品相关----------------------------------------------------------
	
	@RequestMapping(value="/goods/list",method=RequestMethod.GET)
	public EasyUIPage doQueryGoods(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp) {
		if (accept!=null) {
			try {
				accept.setSort(ColumnName.transToUnderline(accept.getSort()));
				return familyShopSer.queryFenyeGoods(accept);
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return null;
			}
		}
		return null;
	}

	@RequestMapping(value="/goods/one",method=RequestMethod.GET)
	public Result<Goods> doGetGoods(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<Goods>(BaseRestController.SUCCESS, Code.SUCCESS, familyShopSer.getGoods(id));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<Goods>(BaseRestController.ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="/goods",method=RequestMethod.POST)
	public Result<String> doAddGoods(Goods obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj != null){
			try {
				return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, familyShopSer.addGoods(obj) + "");
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<String>(BaseRestController.ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="/goods",method=RequestMethod.PUT)
	public Result<String> doUpdateGoods(Goods obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj != null && obj.getId() != null){
			try {
				return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, familyShopSer.updateGoods(obj) + "");
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<String>(BaseRestController.ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="/goods/one",method=RequestMethod.DELETE)
	public Result<String> doDeleteGoods(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id != null){
			try {
				return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, familyShopSer.deleteGoods(id) + "");
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<String>(BaseRestController.ERROR, Code.ERROR, null);
	}

	//---------------------交易单相关---------------------------------------------
	@RequestMapping(value="/transaction/list",method=RequestMethod.GET)
	public EasyUIPage doQueryTra(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp) {
		if (accept!=null) {
			try {
				accept.setSort(ColumnName.transToUnderline(accept.getSort()));
				return familyShopSer.queryFenyeTra(accept);
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return null;
			}
		}
		return null;
	}

	@RequestMapping(value="/transaction/one",method=RequestMethod.GET)
	public Result<Transaction> doGetTra(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<Transaction>(BaseRestController.SUCCESS, Code.SUCCESS, familyShopSer.getTra(id));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<Transaction>(BaseRestController.ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="/transaction",method=RequestMethod.POST)
	public Result<String> doAddTra(@RequestBody Transaction obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj != null){
			try {
				return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, familyShopSer.addTra(obj) + "");
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<String>(BaseRestController.ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="/transaction",method=RequestMethod.PUT)
	public Result<String> doUpdateTra(@RequestBody Transaction obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj != null && obj.getId() != null){
			try {
				return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, familyShopSer.updateTra(obj) + "");
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<String>(BaseRestController.ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="/transaction/one",method=RequestMethod.DELETE)
	public Result<Integer> doDeleteTra(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<Integer>(BaseRestController.SUCCESS, Code.SUCCESS, familyShopSer.deleteTea(id));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<Integer>(BaseRestController.ERROR, Code.ERROR, null);
	}

	//---------------------账单相关---------------------------------------------
	@RequestMapping(value="/bill/list",method=RequestMethod.GET)
	public EasyUIPage doQueryBill(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp) {
		if (accept!=null) {
			try {
				accept.setSort(ColumnName.transToUnderline(accept.getSort()));
				return familyShopSer.queryFenyeBill(accept);
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return null;
			}
		}
		return null;
	}

	@RequestMapping(value="/bill/one",method=RequestMethod.GET)
	public Result<Bill> doGetBill(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<Bill>(BaseRestController.SUCCESS, Code.SUCCESS, familyShopSer.getBill(id));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<Bill>(BaseRestController.ERROR, Code.ERROR, null);
	}

	//----------------------赊账相关-------------------------
	@RequestMapping(value="/credit/list",method=RequestMethod.GET)
	public EasyUIPage doQueryCredit(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp) {
		if (accept!=null) {
			try {
				accept.setSort(ColumnName.transToUnderline(accept.getSort()));
				return familyShopSer.queryFenyeCredit(accept);
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return null;
			}
		}
		return null;
	}

	@RequestMapping(value="/credit/one",method=RequestMethod.GET)
	public Result<Credit> doGetCredit(Integer id, HttpServletRequest req, HttpServletResponse resp) {
		if(id!=null){
			try {
				return new Result<Credit>(BaseRestController.SUCCESS, Code.SUCCESS, familyShopSer.getCredit(id));
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<Credit>(BaseRestController.ERROR, Code.ERROR, null);
	}

	@RequestMapping(value="/credit",method=RequestMethod.PUT)
	public Result<String> doUpdateCredit(Credit obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj != null && obj.getId() != null){
			try {
				return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, familyShopSer.updateCredit(obj) + "");
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<String>(BaseRestController.ERROR, Code.ERROR, null);
	}

	//----------------------库存单相关------------------------------------------
	@RequestMapping(value="/stock/list",method=RequestMethod.GET)
	public EasyUIPage doQueryStock(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp) {
		if (accept != null) {
			try {
				accept.setSort(ColumnName.transToUnderline(accept.getSort()));
				return familyShopSer.queryFenyeStock(accept);
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
				return null;
			}
		}
		return null;
	}

	@RequestMapping(value="/stock",method=RequestMethod.POST)
	public Result<String> doAddStock(Stock obj, HttpServletRequest req, HttpServletResponse resp) {
		if(obj != null){
			try {
				int result = familyShopSer.addStock(obj);
				if (result == 1){
					return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS,  result+ "");
				}else{
					return new Result<String>(BaseRestController.ERROR, Code.ERROR,  result+"");
				}
			} catch (Exception e) {
				e.printStackTrace();
				mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
			}
		}
		return new Result<String>(BaseRestController.ERROR, Code.ERROR, null);
	}

}
