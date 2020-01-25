package com.zs.tools;
import java.text.SimpleDateFormat;
import javax.annotation.Resource;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import com.alibaba.fastjson.JSONArray;
import com.google.gson.Gson;
import com.zs.dao.FundHistoryMapper;
import com.zs.dao.FundInfoMapper;
import com.zs.dao.TimelineMapper;
import com.zs.entity.FundInfo;
import com.zs.entity.Timeline;
import com.zs.entity.other.EasyUIAccept;

/**
 * 2019-7-20
 * @author 张顺
 * 爬虫机器人3号，基金信息自动爬取，这样就不用每次还要手动去添加基金信息了
 */
@Component
public class CrawlerNo3{

	@Resource
	private FundInfoMapper fundInfoMapper;
	@Resource
	private FundHistoryMapper fundHistoryMapper;
	@Resource
	private TimelineMapper timelineMapper;
	
	
	private Gson gson=new Gson();
	private Logger log=Logger.getLogger(getClass());
	private SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	
	//张顺，2019-12-16，局部变量改造，内存优化
	String url="http://fund.eastmoney.com/js/fundcode_search.js";
	String str;
	JSONArray jsonArr;
	int counts;
	String temp[];
	String ss[];
	FundInfo fundInfo;
	Timeline tl;
	
	
	
	public void work() {
		try {
			loopSaveFundInfo();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void loopSaveFundInfo() throws Exception{
		//找到该基金的当日净值
		str = HttpClientReq.httpGet(url, null, null);
		str = str.replaceFirst("var r = ", "");
		str = str.substring(0, str.length()-1);
		jsonArr = JSONArray.parseArray(str);
		//先查下数据库基金数量，如果一致那么就认为没有变化
		counts = fundInfoMapper.getCount(new EasyUIAccept());
		if (counts == jsonArr.size()) {//一样，认为没有变化
			return;
		}
		for (int i = 0; i < jsonArr.size(); i++) {
			temp = new String[5];
			ss = jsonArr.getJSONArray(i).toArray(temp);
			//这个ss的内部格式是这样的["000001","HXCZHH","华夏成长混合","混合型","HUAXIACHENGZHANGHUNHE"]
			//[编号，简写，名称，类型，不知道]
			fundInfo = new FundInfo();
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
				tl = new Timeline(Constans.CRAWLERNO3, 85, gson.toJson(fundInfo));
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
	
}
