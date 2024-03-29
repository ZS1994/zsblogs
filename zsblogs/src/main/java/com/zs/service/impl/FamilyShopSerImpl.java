package com.zs.service.impl;

import com.zs.dao.BillMapper;
import com.zs.dao.CreditMapper;
import com.zs.dao.GoodsMapper;
import com.zs.dao.StockMapper;
import com.zs.dao.TransactionDetailMapper;
import com.zs.dao.TransactionMapper;
import com.zs.entity.Bill;
import com.zs.entity.Credit;
import com.zs.entity.EntityUtils;
import com.zs.entity.Goods;
import com.zs.entity.Stock;
import com.zs.entity.Transaction;
import com.zs.entity.TransactionDetail;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.service.FamilyShopSer;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

/**
 * 我好好想了一下，觉得还是非空判断交由被调用方，也就是底层来保证才是最好的，这样上层就可以考虑的更少一点，而底层是有很大复用属性的
 * 所以，这样才更加科学合理
 * 2020-3-2
 * @author 张顺
 */
@Service("familyShopSerImpl")
public class FamilyShopSerImpl implements FamilyShopSer{

	@Resource
	private GoodsMapper goodsMapper;
	@Resource
	private BillMapper billMapper;
	@Resource
	private CreditMapper creditMapper;
	@Resource
	private StockMapper stockMapper;
	@Resource
	private TransactionMapper transactionMapper;
	@Resource
	private TransactionDetailMapper transactionDetailMapper;
	
	
	//---------------------------货品相关---------------------------------------
	@Override
	public EasyUIPage queryFenyeGoods(EasyUIAccept accept) {
		if (accept!=null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list = goodsMapper.queryFenye(accept);
			int rows = goodsMapper.getCount(accept);
			return new EasyUIPage(rows, list);
		}
		return null;
	}
	
	@Override
	public Goods getGoods(Integer gId) {
		if (gId == null) {
			return null;
		}
		return goodsMapper.selectByPrimaryKey(gId);
	}
	@Override
	public int addGoods(Goods goods) {
		//非空判断
		if (goods == null) {
			return EntityUtils.CODE_NULL_OBJECT;
		}
		//这里一定要放过库存数量，因为新增加的，库存数量一定要是0，而不是null
		goods.setQuantity(0.0);
		//合法性校验
		int val = goods.validity();
		if (val != 1) {
			return val;
		}
		return goodsMapper.insertSelective(goods);
	}
	@Override
	public int updateGoods(Goods goods) {
		//非空判断
		if (goods == null) {
			return EntityUtils.CODE_NULL_OBJECT;
		}
		if (goods.getId() == null ) {
			return EntityUtils.CODE_NULL_ID;
		}
		return goodsMapper.updateByPrimaryKeySelective(goods);
	}
	@Override
	public int deleteGoods(Integer gId) {
		if (gId == null) {
			return EntityUtils.CODE_NULL_ID;
		}
		//先判断是否有它的库存单，如果有的话，则不允许删除，返回-1
		EasyUIAccept accept = new EasyUIAccept();
		accept.setStart(0);
		accept.setRows(1);
		accept.setInt1(gId);
		List<Stock> list = stockMapper.queryFenye(accept);
		//如果不等于0，那么说明有库存单,则不允许删除
		if (list.size() != 0) {
			return -2;
		}
		//如果都通过了，那么就可以删除了
		return goodsMapper.deleteByPrimaryKey(gId);
	}
	
	//----------------交易单相关-----------------------------------
	@Override
	public EasyUIPage queryFenyeTra(EasyUIAccept accept) {
		if (accept != null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list = transactionMapper.queryFenye(accept);
			int rows = transactionMapper.getCount(accept);
			//填充详情信息
			Double creditMoney = 0.0;//剩余赊账金额
			for(int i = 0; i < list.size(); i++){
				List<TransactionDetail> traDet = transactionDetailMapper.queryAllDetByTra(((Transaction)list.get(i)).getId());
				((Transaction)list.get(i)).setTraDets(traDet);
			}
			return new EasyUIPage(rows, list);
		}
		return null;
	}
	@Override
	public Transaction getTra(Integer traId) {
		if (traId == null) {
			return null;
		}
		//先查交易单的信息
		Transaction tra = transactionMapper.selectByPrimaryKey(traId);
		//然后绑定交易单的明细信息
		List<TransactionDetail> traDets = transactionDetailMapper.queryAllDetByTra(traId);
		tra.setTraDets(traDets);
		return tra;
	}
	@Override
	public int addTra(Transaction transaction)throws Exception {
		//合法性校验
		if (transaction == null) {
			return EntityUtils.CODE_NULL_OBJECT;
		}
		//基础信息填充
		transaction.setTime(new Date());
		
		int val = transaction.validity();
		if (val != 1) {
			return val;
		}
		//需要对商品明细中的数量进行处理
		for (int i = 0; i < transaction.getTraDets().size(); i++) {
			transaction.getTraDets().get(i).setQuantity(transaction.getTraDets().get(i).getPurchaseQuantity());
		}
		
		//先添加交易单
		int res = transactionMapper.insertSelective(transaction);
		//再添加交易单明细
        for (int i = 0; i < transaction.getTraDets().size(); i++) {
			TransactionDetail traDet = transaction.getTraDets().get(i);
			//这里只判断gid，因为其他信息都是通过gid去填充上去的
			if (traDet.getgId() == null) {
				return EntityUtils.CODE_NULL_ID;
			}
			Goods goods = goodsMapper.selectByPrimaryKey(traDet.getgId());
			if (goods == null) {
				return EntityUtils.CODE_NULL_OBJECT;
			}
			//然后填充所有的其他信息
			traDet.setImg(goods.getImg());
			traDet.setName(goods.getName());
			traDet.setOtherInfo(goods.getOtherInfo());
			traDet.setQuantityUnit(goods.getQuantityUnit());
			traDet.setTraId(transaction.getId());
			transactionDetailMapper.insertSelective(traDet);

            //更新货品的库存数量
            Double sum = goods.getQuantity() - traDet.getPurchaseQuantity();
            //数字不能为负
            if(sum < 0.0){
                throw new RuntimeException("购买货品数量超过该货品库存");
            }
            goods.setQuantity(sum);
            goodsMapper.updateByPrimaryKeySelective(goods);

            //生成出库单
            Stock stock = new Stock();
            stock.setgId(goods.getId());
            stock.setQuantity(traDet.getPurchaseQuantity());
            stock.setState("出库");
            stock.setTime(new Date());
            stock.setPurchasePrice(goods.getPurchasePrice());
            stock.setTraId(traDet.getTraId());
            stock.setPeople(transaction.getCustomer());
            stockMapper.insertSelective(stock);
		}
		//生成账单
		Bill bill = new Bill();
		bill.setTime(new Date());
		bill.setPeople(transaction.getCustomer());
		//计算总金额
		Double sumMoney = 0.0;
		for (TransactionDetail teaDet:transaction.getTraDets()) {
			sumMoney += teaDet.getPurchaseQuantity() * teaDet.getUnitPrice();
		}
		if ("full payment".equals(transaction.getState())) {//全款付清
			bill.setMoney(sumMoney);
			bill.setType("交易");
		}else if("credit ".equals(transaction.getState())){//赊账
			bill.setMoney(0.0);
			bill.setType("交易");
		}
		bill.setRelId(transaction.getId());
		billMapper.insertSelective(bill);

		return res;
	}

    /**
     * 还款功能
     * @param transaction
     * @return
     */
	@Override
	public int updateTra(Transaction transaction) {
		//合法性校验
		if (transaction == null) {
			return EntityUtils.CODE_NULL_OBJECT;
		}
		if (transaction.getId() == null) {
			return EntityUtils.CODE_NULL_ID;
		}
		//先更新交易单
		int res = transactionMapper.updateByPrimaryKeySelective(transaction);
		//生成还款的账单
        Bill bill = new Bill();
        bill.setTime(new Date());
        bill.setPeople(transaction.getCustomer());
        bill.setMoney(transaction.getNewPayMoney());
        bill.setType("还款");
        bill.setRelId(transaction.getId());
        billMapper.insertSelective(bill);
		return res;
	}

    @Override
    public int deleteTea(Integer traId) {
	    if (traId == null){
	        return 0;
        }
        int result = 0;
        //归还库存数量
        List<TransactionDetail> dets = transactionDetailMapper.queryAllDetByTra(traId);
        for (TransactionDetail det:dets) {
            Goods good = goodsMapper.selectByPrimaryKey(det.getgId());
            good.setQuantity(good.getQuantity() + det.getQuantity());
            goodsMapper.updateByPrimaryKeySelective(good);
        }
        //删除关联的库存单
        result += stockMapper.deleteByTraId(traId);
        //删关联的账单
        result += billMapper.deleteByTraId(traId);
        //删关联的交易单明细
        result += transactionDetailMapper.deleteByTra(traId);
        //删交易单
        result += transactionMapper.deleteByPrimaryKey(traId);

        return result;
    }

    //--------------------------账单相关------------------------------------------------
	@Override
	public EasyUIPage queryFenyeBill(EasyUIAccept accept) {
		if (accept != null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list = billMapper.queryFenye(accept);
			int rows = billMapper.getCount(accept);
			return new EasyUIPage(rows, list);
		}
		return null;
	}
	@Override
	public Bill getBill(Integer bId) {
		if (bId == null) {
			return null;
		}
		Bill bill = billMapper.selectByPrimaryKey(bId);
		//根据类型来获取不同的详情
		switch (bill.getType()) {
		case Bill.TYPE_JIAOYI:
			Transaction tra = getTra(bill.getRelId());
			bill.setTra(tra);
			break;
		case Bill.TYPE_HUANZHANG:
			Credit credit = creditMapper.selectByPrimaryKey(bill.getRelId());
			bill.setCredit(credit);
			break;
		case Bill.TYPE_RUKU:
			Stock stock = stockMapper.selectByPrimaryKey(bill.getRelId());
			bill.setStock(stock);
			break;
		default:
			break;
		}
		return bill;
	}
	
	//----------------------赊账相关-------------------------
	@Override
	public EasyUIPage queryFenyeCredit(EasyUIAccept accept) {
		if (accept != null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list = creditMapper.queryFenye(accept);
			int rows = creditMapper.getCount(accept);
			return new EasyUIPage(rows, list);
		}
		return null;
	}
	@Override
	public Credit getCredit(Integer cId) {
		if (cId == null) {
			return null;
		}
		Credit credit = creditMapper.selectByPrimaryKey(cId);
		//得到相关联的交易单的信息
		Transaction tra = getTra(credit.getTraId());
		credit.setTra(tra);
		return credit;
	}
	@Override
	public int updateCredit(Credit credit) {
		if (credit == null) {
			return EntityUtils.CODE_NULL_OBJECT;
		}
		//这里先得到一下以前的赊账单，目的是为了计算还款金额
		Credit creditTmp = creditMapper.selectByPrimaryKey(credit.getId());
		int res = creditMapper.updateByPrimaryKeySelective(credit);
		//新增赊账的账单
		Bill bill = new Bill();
		bill.setTime(new Date());
		bill.setPeople(credit.getCustomer());
		bill.setMoney(creditTmp.getMoney() - credit.getMoney());
		bill.setType(Bill.TYPE_HUANZHANG);
		bill.setRelId(credit.getId());
		billMapper.insertSelective(bill);
		return res;
	}
	
	//----------------------库存单相关------------------------------------------
	@Override
	public EasyUIPage queryFenyeStock(EasyUIAccept accept) {
		if (accept != null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list = stockMapper.queryFenye(accept);
			int rows = stockMapper.getCount(accept);
			//将货品信息绑定上去
			for (int i = 0; i < list.size(); i++) {
				Stock st = (Stock) list.get(i);
				Goods goods = getGoods(st.getgId());
				st.setGoods(goods);
			}
			return new EasyUIPage(rows, list);
		}
		return null;
	}
	@Override
	public int addStock(Stock stock) {
		//合法性判断
		if (stock == null) {
			return EntityUtils.CODE_NULL_OBJECT;
		}
		int val = stock.validity();
		if (val != 1) {
			return val;
		}
		//初始值填充
		stock.setTime(new Date());
		Goods good = goodsMapper.selectByPrimaryKey(stock.getgId());
		if (good == null){
			return EntityUtils.CODE_NULL_OBJECT;
		}
		stock.setPurchasePrice(good.getPurchasePrice());

		int res = stockMapper.insertSelective(stock);
		//如果是入库，那么还要生成账单，然后再更新库存数量
		switch (stock.getState()) {
		case Stock.STATE_RUKU:
			Bill bill = new Bill();
			bill.setTime(new Date());
			bill.setPeople(stock.getPeople());
			bill.setMoney(stock.getPurchasePrice() * stock.getQuantity());
			bill.setType(Bill.TYPE_RUKU);
			bill.setRelId(stock.getId());
			billMapper.insertSelective(bill);
			//更新库存
			Goods goods = goodsMapper.selectByPrimaryKey(stock.getgId());
			goods.setQuantity(goods.getQuantity() + stock.getQuantity());
			goodsMapper.updateByPrimaryKeySelective(goods);
			break;
		//如果是出库，那么只需要更新库存就行
		case Stock.STATE_CHUKU:
			//更新库存
			Goods goods2 = goodsMapper.selectByPrimaryKey(stock.getgId());
			goods2.setQuantity(goods2.getQuantity() - stock.getQuantity());
			goodsMapper.updateByPrimaryKeySelective(goods2);
			break;
		default:
			break;
		}
		return res;
	}
	
	
	

}
