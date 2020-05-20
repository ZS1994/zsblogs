package com.zs.service;

import java.util.List;

import com.zs.entity.Bill;
import com.zs.entity.Credit;
import com.zs.entity.Goods;
import com.zs.entity.Stock;
import com.zs.entity.Transaction;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;

public interface FamilyShopSer {

	//------------------货品相关--------------------------
	/**
	 * 查询所有货品信息
	 * @return
	 */
	public EasyUIPage queryFenyeGoods(EasyUIAccept accept);
	
	public Goods getGoods(Integer gId);
	
	public int addGoods(Goods goods);
	
	public int updateGoods(Goods goods);
	
	/**
	 * 删除的货品的前提是，该货品没有库存单记录
	 * @param goods
	 */
	public int deleteGoods(Integer gId);
	
	
	//------------交易单相关--------------------------------
	/**只查交易单的，交易单明细交由get方法去查找*/
	public EasyUIPage queryFenyeTra(EasyUIAccept accept);
	
	/**
	 * 得到一个交易单，还有它的明细信息
	 * @param traId
	 * @return
	 */
	public Transaction getTra(Integer traId);
	
	/**
	 * 添加要先添加交易单，然后再添加交易单明细，最后添加一个账单（即使0付款也要有账单）,并且是用事务控制好
	 * @param transaction
	 * @return
	 */
	public int addTra(Transaction transaction)throws Exception;
	
	/**
	 * 不仅更新交易单的信息，还要循环更新所有的明细信息
	 * @param transaction
	 */
	public int updateTra(Transaction transaction);

	/**
	 * 删除交易单
	 * @param traId
	 * @return
	 */
	public int deleteTea(Integer traId);

	//----------------账单相关-----账单只允许查询-----------------------
	public EasyUIPage queryFenyeBill(EasyUIAccept accept);
	
	/**
	 * 根据相应的类型，来获取相应的详情，有这些类型：交易、还账、入库
	 * @param bId
	 * @return
	 */
	public Bill getBill(Integer bId);
	
	
	//----------------赊账相关--赊账不能删除---------------------
	public EasyUIPage queryFenyeCredit(EasyUIAccept accept);
	
	/**
	 * 得到赊账单，并且也要得到关联的交易单的信息
	 * @param cId
	 * @return
	 */
	public Credit getCredit(Integer cId);
	
	/**
	 * 这里的更新赊账，还要自动新增赊账的账单
	 * @param credit
	 * @return
	 */
	public int updateCredit(Credit credit);
	
	
	//----------------库存相关--只能入库，出库是自动的---------------------
	public EasyUIPage queryFenyeStock(EasyUIAccept accept);
	/**
	 * 这里分为两种情况：
	 * 1，入库。先入库，然后生成账单，再更新货品库存
	 * 2，出库。先出库，然后再更新货品库存
	 * @param tock
	 * @return
	 */
	public int addStock(Stock tock);
}
