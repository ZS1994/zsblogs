package com.zs.service.impl;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.annotation.Resource;
import javax.xml.registry.infomodel.User;

import org.springframework.stereotype.Service;

import com.google.gson.Gson;
import com.zs.dao.FundHistoryMapper;
import com.zs.dao.FundInfoMapper;
import com.zs.dao.FundTradeMapper;
import com.zs.dao.UsersMapper;
import com.zs.entity.FundHistory;
import com.zs.entity.FundInfo;
import com.zs.entity.FundTrade;
import com.zs.entity.Users;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.entity.other.FundProfit;
import com.zs.entity.other.TimeValueBean;
import com.zs.service.FundTradeSer;

@Service("fundTradeSer")
public class FundTradeSerImpl implements FundTradeSer{

	@Resource
	private FundTradeMapper fundTradeMapper;
	@Resource
	private FundHistoryMapper fundHistoryMapper;
	@Resource
	private FundInfoMapper fundInfoMapper;
	@Resource
	private UsersMapper usersMapper;
	private Gson gson=new Gson();
	
	
	@Override
	public EasyUIPage queryFenye(EasyUIAccept accept) {
		if (accept!=null) {
			Integer page=accept.getPage();
			Integer size=accept.getRows();
			if (page!=null && size!=null) {
				accept.setStart((page-1)*size);
				accept.setEnd(page*size);
			}
			List list=fundTradeMapper.queryFenye(accept);
			int rows=fundTradeMapper.getCount(accept);
			for (Object obj : list) {
				FundTrade ft=(FundTrade) obj;
				ft.setU(usersMapper.selectByPrimaryKey(ft.getuId()));
				ft.setFi(fundInfoMapper.selectByPrimaryKey(ft.getFiId()));
			}
			return new EasyUIPage(rows, list);
		}
		return null;
	}

	@Override
	public String add(FundTrade obj) {
		//找到这一天的净值
		FundHistory fh=fundHistoryMapper.selectByFiIdAndTime(obj.getFiId(), obj.getCreateTime());
		//找到手续费
		FundInfo fi=fundInfoMapper.selectByPrimaryKey(obj.getFiId());
		if (fh!=null) {
			Double number=obj.getBuyMoney()*(1-fi.getBuyRate())/fh.getNetvalue();
			obj.setBuyNumber(number);
			return String.valueOf(fundTradeMapper.insertSelective(obj));
		}else{
			return "当日没有净值，无法交易";
		}
	}

	@Override
	public String update(FundTrade obj) {
		//找到这一天的净值
		FundHistory fh=fundHistoryMapper.selectByFiIdAndTime(obj.getFiId(), obj.getCreateTime());
		//找到手续费
		FundInfo fi=fundInfoMapper.selectByPrimaryKey(obj.getFiId());
		if (fh!=null) {
			Double number=obj.getBuyMoney()*(1-fi.getBuyRate())/fh.getNetvalue();
			obj.setBuyNumber(number);
			return String.valueOf(fundTradeMapper.updateByPrimaryKeySelective(obj));
		}else{
			return "当日没有净值，无法交易";
		}
	}

	@Override
	public String delete(Integer id) {
		return String.valueOf(fundTradeMapper.deleteByPrimaryKey(id));
	}

	@Override
	public FundTrade get(Integer id) {
		FundTrade a=fundTradeMapper.selectByPrimaryKey(id);
		a.setU(usersMapper.selectByPrimaryKey(a.getuId()));
		a.setFi(fundInfoMapper.selectByPrimaryKey(a.getFiId()));
		return a;
	}

	/**
	 * 张顺，2018-2-9
	 * 关键在于利润率的计算，如何计算呢？现实生活中是这样的：
	 * (总份额*当前的净值-投资总金额)/投资总金额
	 * 
	 * 净值涨幅如何计算的呢？
	 * (今天净值-昨天净值)/昨天净值
	 * 
	 * 收益同比如何金酸呢？
	 * (今天收益率-昨天收益率)/昨天收益率
	 */
	@Override
	public FundProfit obtainProfit(Integer uid, String fiId, Date begin, Date end) {
		FundProfit profit=new FundProfit();
		
		Users u=usersMapper.selectByPrimaryKey(uid);
		FundInfo fi=fundInfoMapper.selectByPrimaryKey(fiId);
		
		List<TimeValueBean> tv1=fundTradeMapper.obtainHistory(begin, end, fiId);
		
		List<TimeValueBean> tv2=fundTradeMapper.obtainTrade(begin, end, fiId, uid);
		
		List<String> tts=new ArrayList<>();
		List<Double> list1=new ArrayList<>();
		List<Double> list2=new ArrayList<>();
		list1.add(0.0);
		list2.add(0.0);
		
		tts.add(tv1.get(0).getTime());
		//这个是求净值涨幅的，dou1是净值
		for (int i = 1; i < tv1.size(); i++) {
			Double last=tv1.get(i-1).getDou1();
			Double now=tv1.get(i).getDou1();
			Double rate=new BigDecimal(last).compareTo(new BigDecimal(0))!=0?new BigDecimal(now-last).divide(new BigDecimal(last), 4,BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal(100)).doubleValue():0.0;
			list1.add(rate);
			tts.add(tv1.get(i).getTime());
		}
		
		//这个是求利润率的,dou1是金额，dou2是份额，str1是类型
		Double jine=tv2.get(0).getDou1();
		Double fene=tv2.get(0).getDou2();
		for (int i = 1; i < tv2.size(); i++) {
			TimeValueBean lt=tv2.get(i-1);
			TimeValueBean nt=tv2.get(i);
			jine=jine+nt.getDou1();
			fene=fene+nt.getDou2();
			
			//当前的净值
			Double jingzhi=tv1.get(i).getDou1();
			
			Double rate=new BigDecimal(jine).compareTo(new BigDecimal(0))!=0?new BigDecimal(fene*jingzhi-jine).divide(new BigDecimal(jine),4, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal(100)).doubleValue():0.0;
			list2.add(rate);
		}
		
		//交易标记计算
		EasyUIAccept accept=new EasyUIAccept();
		accept.setStart(0);
		accept.setRows(999999);
		accept.setStr1(fiId);
		accept.setInt1(uid);
		List<FundTrade> fts=fundTradeMapper.queryFenye(accept);
		List<TimeValueBean> list3=new ArrayList<>();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		for (FundTrade ft : fts) {
			String time=sdf.format(ft.getCreateTime());
			TimeValueBean tvtmp=new TimeValueBean();
			tvtmp.setTime(sdf.format(ft.getCreateTime()));
			tvtmp.setStr1(ft.getType()+ft.getBuyMoney()+"元，"+new BigDecimal(ft.getBuyNumber()).setScale(2, BigDecimal.ROUND_HALF_UP).toString()+"份");
			for (int i = 0; i < tts.size(); i++) {
				String t=tts.get(i);
				if (t.equals(time)) {
					tvtmp.setDou1(list2.get(i));
				}
			}
			list3.add(tvtmp);
		}
		
		profit.setFundName(fi.getName()+"("+fi.getId()+")");
		profit.setxTime(tts);
		profit.setyRate1(list1);
		profit.setyRate2(list2);
		profit.setMarks(list3);
		
		return profit;
	}

}
