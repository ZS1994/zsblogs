package com.zs.tools;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
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
public class CrawlerNo2{

	@Resource
	private FundInfoMapper fundInfoMapper;
	@Resource
	private FundHistoryMapper fundHistoryMapper;
	@Resource
	private TimelineMapper timelineMapper;
	
	private Gson gson=new Gson();
	private Logger log=Logger.getLogger(getClass());
	private SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	
	//张顺，2019-12-16，局部变量优化内存
	//张顺，2019-7-14，1，设置一些配置参数，这个网址内容已经改了，它不能一次查出所有，所以只能根据分页循环取值
	int pageRows = 20;//张顺，2019-7-14，每页多少数据量
	//张顺，2019-7-14，-1
	EasyUIAccept accept;
	List<FundInfo> fis;
	String url;
	String str;
	JSONObject jsonObject;
	int pageSize;
	int exits;
	Document doc;
	Elements summaryE;
	Elements summaryD;
	Elements summaryR;
	Double nv;
	Date d;
	Double rate;
	FundHistory history;
	Timeline tl;
	
	
	public void work() {
		accept = new EasyUIAccept();
		accept.setStart(0);
		accept.setRows(Constans.INFINITY);
		fis = fundInfoMapper.queryFenye(accept);
		for (FundInfo fi : fis) {
			log.info("【基金编号】"+fi.getId());
			//找到该基金的当日净值
			//modify begin 1 张顺 2019年8月24日 <不要当获取出错时导致整个后续的都不走了>
			url = "http://fund.eastmoney.com/f10/F10DataApi.aspx?type=lsjz&code="+fi.getId()+"&page=1&per="+pageRows+"&sdate=&edate=";;
			str = "";
			try {
				str = HttpClientReq.httpGet(url, null,null);
			} catch (Exception e) {
				//跳过改基金，继续走下一个基金
				continue;
			}
			//modify end -1 张顺 2019年8月24日 <描述>
			str = str.replaceFirst("var apidata=", "");
			str = str.substring(0, str.length()-1);
			jsonObject = JSONObject.parseObject(str);
			pageSize = jsonObject.getIntValue("pages");
			//张顺，2019-7-14，2，因为不能一次取值，所以必须循环遍历所有页面
			if (pageSize > 1) {
				for (int pageNo = 1; pageNo <= pageSize; pageNo++) {
					try {
						//不想浪费资源，这里判断一下如果连续累计找到5个已存在的(返回的是false)，那么久不往下找了，认为下面都是已存在的，即以前已经获取过了
						if (loopSave(pageNo, pageRows, fi.getId())==false) {
							log.info("【不往下找基金历史了】"+fi.getName()+"("+fi.getId()+")");
							break;
						}
					} catch (Exception e) {
						//log.error(e.toString());
					}
				}
			}
			//张顺，2019-7-14，-2
		}
	}
	
	/**
	 * 张顺，2019-7-14
	 * 因为不能一次取值，所以必须循环遍历所有页面，专门写这个方法方便调用
	 * @throws Exception 
	 */
	private boolean loopSave(int pageNo,int pageRows,String code){
		//已存在的记录数，超过10次就不找了，返回false
		exits = 0;
		//找到该基金的当日净值
		url = "http://fund.eastmoney.com/f10/F10DataApi.aspx?type=lsjz&code="+code+"&page="+pageNo+"&per="+pageRows+"&sdate=&edate=";
		str = null;
		try {
			str = HttpClientReq.httpGet(url, null,null);
		} catch (Exception e1) {
			e1.printStackTrace();
			log.error("【网络错误：无法获取访问基金历史网站】"+e1.toString());
			return false;
		}
		str = str.replaceFirst("var apidata=", "");
		str = str.substring(0, str.length()-1);
		jsonObject = JSONObject.parseObject(str);
		doc = Jsoup.parse(jsonObject.get("content").toString());
		
		for (int i = 0; i < pageRows; i++) {
			//已存在的记录数，超过5次就不找了，返回false
			if (exits >= 5) {
				return false;
			}
			summaryE = doc.select("tr:eq("+i+") td:eq(1)");
			summaryD = doc.select("tr:eq("+i+") td:eq(0)");
			summaryR = doc.select("tr:eq("+i+") td:eq(3)");
			
			nv = summaryE.html().trim().equals("")?0.00:Double.valueOf(summaryE.html());
			d = null;
			try {
				d = summaryD.html().trim().equals("")?sdf.parse("2018-1-2"):sdf.parse(summaryD.html());
			} catch (ParseException e1) {
				//e1.printStackTrace();
				//log.error("【日期错误："+summaryD.html()+"】");
				//无需记录，属于日期格式转换错误，因为有可能是“暂无数据”
			}
			rate = summaryR.html().trim().equals("")?0.00:Double.valueOf(summaryR.html().replaceAll("%", ""));
			
			//尝试插入
			history = new FundHistory().setFiId(code).setNetvalue(nv).setTime(d).setRate(rate);
			try {
				fundHistoryMapper.insert(history);
				tl = new Timeline();
				tl.setCreateTime(new Date());
				tl.setuId(97);//目前就我，后面给它建个账号
				tl.setpId(79);//操作：基金历史单条添加
				tl.setInfo(gson.toJson(history));
				timelineMapper.insert(tl);
			} catch (Exception e) {
				exits++;//已存在了，累加
				//log.info("【不必关注】张顺，基金编号："+history.getFiId()+"（这个代表插入失败，因为基金历史表设置了为唯一索引fi_id_2，目的是防止重复插入。）"+e.getMessage());
			}
		}
		return true;
	}

	public static void main(String[] args) {
		/*while(true){
			try {
				if (true) {
					try {
						//张顺，2019-7-14，1，设置一些配置参数，这个网址内容已经改了，它不能一次查出所有，所以只能根据分页循环取值
						int pageRows=20;//张顺，2019-7-14，每页多少数据量
						//张顺，2019-7-14，-1
						EasyUIAccept accept=new EasyUIAccept();
						accept.setStart(0);
						accept.setRows(Constans.INFINITY);
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
									//不想浪费资源，这里判断一下如果连续累计找到5个已存在的(返回的是false)，那么久不往下找了，认为下面都是已存在的，即以前已经获取过了
									if (loopSave(pageNo, pageRows, fi.getId())==false) {
										log.info("【不往下找基金历史了了】"+fi.getName()+"("+fi.getId()+")");
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
		}*/
		
		
	}
	
	
	
}
