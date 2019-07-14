package com.zs.tools;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Component;

import com.alibaba.fastjson.JSONObject;
import com.google.gson.Gson;
import com.zs.dao.FundHistoryMapper;
import com.zs.dao.FundInfoMapper;
import com.zs.dao.TimelineMapper;
import com.zs.entity.FundHistory;
import com.zs.entity.FundInfo;
import com.zs.entity.Timeline;
import com.zs.entity.other.EasyUIAccept;

/**
 * 2017-11-12
 * @author 张顺
 * 爬虫机器人2号，基金净值更新
 */
@Component
public class CrawlerNo2 implements Runnable{

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
	public CrawlerNo2 begin(){
		isBegin=true;
		return this;
	}
	
	/**
	 * 结束
	 * @return
	 */
	public CrawlerNo2 finish(){
		isBegin=false;
		return this;
	}
	
	@PostConstruct
	public void beginWorkThread(){
		Thread thread=new Thread(this);
		if (!thread.isAlive()) {
			thread.start();
		}
	}
	
	private void work() {
		while(true){
			try {
				if (isBegin) {
					try {
						//张顺，2019-7-14，1，设置一些配置参数，这个网址内容已经改了，它不能一次查出所有，所以只能根据分页循环取值
						int pageRows=20;//张顺，2019-7-14，每页多少数据量
						//张顺，2019-7-14，-1
						EasyUIAccept accept=new EasyUIAccept();
						accept.setStart(0);
						accept.setRows(999999);
						List<FundInfo> fis=fundInfoMapper.queryFenye(accept);
						for (FundInfo fi : fis) {
							//找到该基金的当日净值
							String url="http://fund.eastmoney.com/f10/F10DataApi.aspx?type=lsjz&code="+fi.getId()+"&page=1&per="+pageRows+"&sdate=&edate=";
							String str=HttpClientReq.httpGet(url, null,null);
							str=str.replaceFirst("var apidata=", "");
							str=str.substring(0, str.length()-1);
							JSONObject jsonObject=JSONObject.parseObject(str);
							int pageSize=jsonObject.getIntValue("pages");
							//张顺，2019-7-14，2，因为不能一次取值，所以必须循环遍历所有页面
							if (pageSize>1) {
								for (int pageNo = 1; pageNo <= pageSize; pageNo++) {
									//不想浪费资源，这里判断一下如果连续累计找到10个已存在的(返回的是false)，那么久不往下找了，认为下面都是已存在的，即以前已经获取过了
									if (loopSave(pageNo, pageRows, fi.getId())==false) {
										break;
									};
								}
							}
							//张顺，2019-7-14，-2
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
					Thread.sleep(1000*60*60*2);//每2小时重新爬取一次
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
	
	/**
	 * 张顺，2019-7-14
	 * 因为不能一次取值，所以必须循环遍历所有页面，专门写这个方法方便调用
	 * @throws Exception 
	 */
	@SuppressWarnings("unused")
	private boolean loopSave(int pageNo,int pageRows,String code) throws Exception{
		//已存在的记录数，超过10次就不找了，返回false
		int exits=0;
		//找到该基金的当日净值
		String url="http://fund.eastmoney.com/f10/F10DataApi.aspx?type=lsjz&code="+code+"&page="+pageNo+"&per="+pageRows+"&sdate=&edate=";
		String str=HttpClientReq.httpGet(url, null,null);
		str=str.replaceFirst("var apidata=", "");
		str=str.substring(0, str.length()-1);
		JSONObject jsonObject=JSONObject.parseObject(str);
		Document doc=Jsoup.parse(jsonObject.get("content").toString());
		
		for (int i = 0; i < pageRows; i++) {
			//已存在的记录数，超过10次就不找了，返回false
			if (exits>=10) {
				return false;
			}
			Elements summaryE=doc.select("tr:eq("+i+") td:eq(1)");
			Elements summaryD=doc.select("tr:eq("+i+") td:eq(0)");
			Elements summaryR=doc.select("tr:eq("+i+") td:eq(3)");
			
			Double nv=summaryE.html().trim().equals("")?0.00:Double.valueOf(summaryE.html());
			Date d=summaryD.html().trim().equals("")?sdf.parse("2018-1-2"):sdf.parse(summaryD.html());
			Double rate=summaryR.html().trim().equals("")?0.00:Double.valueOf(summaryR.html().replaceAll("%", ""));
			
			//尝试插入
			FundHistory history=new FundHistory().setFiId(code).setNetvalue(nv).setTime(d).setRate(rate);
			try {
				fundHistoryMapper.insert(history);
				Timeline tl=new Timeline();
				tl.setCreateTime(new Date());
				tl.setuId(97);//目前就我，后面给它建个账号
				tl.setpId(79);//操作：基金历史单条添加
				tl.setInfo(gson.toJson(history));
				timelineMapper.insert(tl);
			} catch (Exception e) {
				exits++;//已存在了，累加
				log.info("【不必关注】张顺，2019-7-14，（这个代表插入失败，因为基金历史表设置了为唯一索引fi_id_2，目的是防止重复插入。）"+e.getMessage());
			}
		}
		return true;
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
