package com.zs.service;

import java.util.Date;

import com.zs.entity.FundTrade;
import com.zs.entity.other.FundProfit;

public interface FundTradeSer extends BaseService<FundTrade, Integer>{

	public FundProfit obtainProfit(Integer uid,String fiId,Date begin,Date end);
	
}
