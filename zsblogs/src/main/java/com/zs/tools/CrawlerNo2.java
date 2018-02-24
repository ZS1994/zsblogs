package com.zs.tools;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import org.apache.log4j.Logger;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
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
public class CrawlerNo2 implements Runnable{

	private FundInfoMapper fundInfoMapper;
	private FundHistoryMapper fundHistoryMapper;
	private TimelineMapper timelineMapper;
	
	private static CrawlerNo2 no2=new CrawlerNo2();
	
	private boolean isBegin=true;//是否开始,默认开启
	private Gson gson=new Gson();
	private Logger log=Logger.getLogger(getClass());
	
	
	private CrawlerNo2() {
		super();
	}


	/**
	 * 初始化并返回机器人
	 * @param blogSer
	 * @return
	 */
	public static CrawlerNo2 init(FundInfoMapper fundInfoMapper,FundHistoryMapper fundHistoryMapper,TimelineMapper timelineMapper) {
		no2.fundInfoMapper = fundInfoMapper;
		no2.fundHistoryMapper = fundHistoryMapper;
		no2.timelineMapper = timelineMapper;
		return no2;
	}
	
	/**
	 * 返回机器人
	 * @param blogSer
	 * @return
	 */
	public static CrawlerNo2 getInstance() {
		return no2;
	}
	
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
	
	public CrawlerNo2 beginWorkThread(){
		Thread thread=new Thread(this);
		if (!thread.isAlive()) {
			thread.start();
		}
		return this;
	}
	
	private void work() {
		while(true){
			try {
				if (isBegin) {
					try {
						EasyUIAccept accept=new EasyUIAccept();
						accept.setStart(0);
						accept.setRows(999999);
						List<FundInfo> fis=fundInfoMapper.queryFenye(accept);
						for (FundInfo fi : fis) {
							//找到该基金的当日净值
							String url="http://fund.eastmoney.com/f10/F10DataApi.aspx?type=lsjz&code="+fi.getId()+"&page=1&per=1&sdate=&edate=";
							String str=HttpClientReq.httpGet(url, null,null);
							str=str.replaceFirst("var apidata=", "");
							str=str.substring(0, str.length()-1);
							JSONObject jsonObject=JSONObject.parseObject(str);
							Document doc=Jsoup.parse(jsonObject.get("content").toString());
							Elements summaryE=doc.select("tr td:eq(1)");
							Elements summaryD=doc.select("tr td:eq(0)");
							
							Double nv=Double.valueOf(summaryE.html());
							Date d=new SimpleDateFormat("yyyy-MM-dd").parse(summaryD.html());
//							log.error(jsonObject.get("content"));
//							log.error(nv);
//							log.error(d.toLocaleString());
							//尝试插入
							FundHistory history=new FundHistory().setFiId(fi.getId()).setNetvalue(nv).setTime(d);
							try {
								fundHistoryMapper.insert(history);
								Timeline tl=new Timeline();
								tl.setCreateTime(new Date());
								tl.setuId(97);//目前就我，后面给它建个账号
								tl.setpId(79);//基金历史单条添加
								tl.setInfo(gson.toJson(history));
								timelineMapper.insert(tl);
							} catch (Exception e) {
							}
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
