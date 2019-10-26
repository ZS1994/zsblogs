package com.zs.tools;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Component;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.zs.dao.FundHistoryMapper;
import com.zs.dao.FundInfoMapper;
import com.zs.dao.TimelineMapper;
import com.zs.entity.FundHistory;
import com.zs.entity.FundInfo;
import com.zs.entity.Timeline;
import com.zs.entity.other.EasyUIAccept;

/**
 * 2019-7-20
 * @author 张顺
 * 爬虫机器人3号，基金信息自动爬取，这样就不用每次还要手动去添加基金信息了
 */
@Component
public class CrawlerNo3 implements Runnable{

	@Resource
	private FundInfoMapper fundInfoMapper;
	@Resource
	private FundHistoryMapper fundHistoryMapper;
	@Resource
	private TimelineMapper timelineMapper;
	
	
	private boolean isBegin=false;//是否开始,默认关闭
	private Gson gson=new Gson();
	private Logger log=Logger.getLogger(getClass());
	private SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	
	/**
	 * 开始
	 * @return
	 */
	public CrawlerNo3 begin(){
		isBegin=true;
		return this;
	}
	
	/**
	 * 结束
	 * @return
	 */
	public CrawlerNo3 finish(){
		isBegin=false;
		return this;
	}
	
	@PostConstruct
	public void beginWorkThread(){
		Thread thread = Constans.getThread(this, "CrawlerNo3");
		if (!thread.isAlive()) {
			log.info("crawlerNo3爬虫三号初始化完成，线程已开启，等待爬取基金列表信息。");
			thread.start();
		}
	}
	
	private void work() {
		while(true){
			try {
				if (isBegin) {
					try {
						loopSaveFundInfo();
					} catch (Exception e) {
						e.printStackTrace();
					}
					Thread.sleep(1000*60*60*4);//每4小时重新爬取一次
				}
				Thread.sleep(1000*3);//每3s进行一次判断
			} catch (Exception e) {
				//出错了就休息2小时再尝试
				e.printStackTrace();
				try {
					Thread.sleep(1000*60*60*2);
				} catch (InterruptedException e1) {
					e1.printStackTrace();
				}
			}
		}
	}
	
	public void loopSaveFundInfo() throws Exception{
		//找到该基金的当日净值
		String url="http://fund.eastmoney.com/js/fundcode_search.js";
		String str=HttpClientReq.httpGet(url, null,null);
		str=str.replaceFirst("var r = ", "");
		str=str.substring(0, str.length()-1);
		JSONArray jsonArr=JSONArray.parseArray(str);
		//先查下数据库基金数量，如果一致那么就认为没有变化
		int counts=fundInfoMapper.getCount(new EasyUIAccept());
		if (counts==jsonArr.size()) {//一样，认为没有变化
			return;
		}
		for (int i = 0; i < jsonArr.size(); i++) {
			String temp[]=new String[5];
			String ss[]=jsonArr.getJSONArray(i).toArray(temp);
			//这个ss的内部格式是这样的["000001","HXCZHH","华夏成长混合","混合型","HUAXIACHENGZHANGHUNHE"]
			//[编号，简写，名称，类型，不知道]
			FundInfo fundInfo=new FundInfo();
			fundInfo.setId(ss[0]);
			fundInfo.setName(ss[2]);
			fundInfo.setType(ss[3]);
			fundInfo.setBuyRate(0.0);
			fundInfo.setSelloutRateOne(0.0);
			fundInfo.setSelloutRateTwo(0.0);
			fundInfo.setSelloutRateThree(0.0);
			fundInfo.setManagerRate(0.0);
			try {
				fundInfoMapper.insertSelective(fundInfo);
				//存日志
				Timeline tl=new Timeline(Constans.CRAWLERNO3, 85, gson.toJson(fundInfo));
				timelineMapper.insert(tl);
			} catch (Exception e) {
				//log.info("【不必关注的错误，避免数据重复存储】"+e.toString());
			}
		}
	}

	public static void main(String[] args) {
		try {
			new CrawlerNo3().loopSaveFundInfo();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/**
	 * 开始爬虫工作
	 * 每隔10秒钟检测一次是否继续工作
	 */
	@Override
	public void run() {
		work();
	}


	public boolean getIsBegin() {
		return isBegin;
	}

	public void setIsBegin(boolean isBegin) {
		this.isBegin = isBegin;
	}
	
}
