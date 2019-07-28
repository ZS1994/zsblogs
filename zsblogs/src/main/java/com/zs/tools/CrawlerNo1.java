package com.zs.tools;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.faces.validator.RegexValidator;
import javax.mail.Flags.Flag;

import org.apache.log4j.Logger;
import org.bouncycastle.crypto.engines.TnepresEngine;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.stereotype.Component;

import com.google.gson.Gson;
import com.zs.dao.BlogMapper;
import com.zs.dao.TimelineMapper;
import com.zs.entity.Blog;
import com.zs.entity.BlogList;
import com.zs.entity.Timeline;
import com.zs.entity.other.CrawlerData1;
import com.zs.service.BlogListSer;
import com.zs.service.BlogSer;

/**
 * 2017-11-12
 * @author 张顺
 * 爬虫的第一次尝试，爬虫机器人1号
 */
@Component
public class CrawlerNo1 implements Runnable{

	@Resource
	private BlogSer blogSer;
	@Resource
	private BlogMapper blogMapper;
	@Resource
	private BlogListSer blogListSer;
	@Resource
	private DownloadImg downloadImg;
	@Resource
	private TimelineMapper timelineMapper;
	
	private List<CrawlerData1> list=new ArrayList<>();
	
	private boolean isBegin=false;//是否开始
	private Gson gson=new Gson();
	private Logger log=Logger.getLogger(getClass());
	// 正则表达式规则
    private Pattern pattern = Pattern.compile("^/?http");
    
	
	
	public DownloadImg getDownloadImg() {
		return downloadImg;
	}
	public void setDownloadImg(DownloadImg downloadImg) {
		this.downloadImg = downloadImg;
	}
	public BlogSer getBlogSer() {
		return blogSer;
	}
	public void setBlogSer(BlogSer blogSer) {
		this.blogSer = blogSer;
	}
	public BlogListSer getBlogListSer() {
		return blogListSer;
	}
	public void setBlogListSer(BlogListSer blogListSer) {
		this.blogListSer = blogListSer;
	}
	
	
	
	
	@Deprecated
	public CrawlerNo1 addUrl(String url){
		return this;
	}

	/**
	 * 开始
	 * @return
	 */
	public CrawlerNo1 begin(){
		isBegin=true;
		return this;
	}
	
	/**
	 * 结束
	 * @return
	 */
	public CrawlerNo1 finish(){
		isBegin=false;
		return this;
	}
	
	@PostConstruct
	public void beginWorkThread(){
		Thread thread=new Thread(this);
		if (!thread.isAlive()) {
			log.info("crawlerNo1爬虫一号初始化完成，线程已开启，等待爬取美团技术团队网。");
			thread.start();
		}
	}
	
	
	private void work() {
		while(true){
			try {
				if (isBegin) {
					getAllUrlAndList();
//					log.info("list的大小是："+list.size());
					for (int i = list.size()-1; i >= 0; i--) {
						Blog blog=null;
						Elements content=null;
						String title="";
						String summary=null;
						Elements imgs=null;
						try {
							String url=list.get(i).getUrl();
							url=url.replaceAll(" ", "%20");
							String root=url.split("//")[0]+"//"+url.split("//")[1].split("/")[0];
							String str=HttpClientReq.httpGet(url, null,null);
							Document doc=Jsoup.parse(str);
							//摘要
							Elements summaryE=doc.select("meta[property=og:description]");
							summary=summaryE.size()>0?summaryE.get(0).attr("content"):"[未获取到摘要]";
							title=doc.select("meta[property=og:title]").attr("content");
							title=title.equals("")?"[未获取到标题]":title;
							content=doc.select("div .content");
							//图片
							imgs=content.select("img");
							for (Element img : imgs) {
								String src=img.attr("src");
								String fileName="";
								String srctmp="";
								if(src!=null){
									src=src.indexOf("/")==0?src:"/"+src;
									String ss[]=src.split("/");					
									fileName=ss[ss.length-1];
									//张顺，2019-6-17，因网站改为地址为外部地址，故不可直接拼接，而是应该先判断是否站内
									if (pattern.matcher(src).find()) {
										//判断第一个字符是否是/，如果是则去掉
										src=src.substring(0, 1).equals("/")?src.substring(1, src.length()):src;
//										System.out.println(src);
										srctmp=src;
									}else{
										for (String s : ss) {
											s=URLEncoder.encode(s, "utf-8");
											srctmp=srctmp+s+"/";
										}
										srctmp=srctmp.equals("")?srctmp:srctmp.substring(0, srctmp.lastIndexOf("/"));
										srctmp=root+srctmp;
									}
									String newImgPath=downloadImg.download(srctmp, fileName);
									img.attr("src", Constans.PATH_TOMCAT_IMGS+newImgPath);
								}
							}
							blog=new Blog(title, content.html(), summary, list.get(i).getUrlBlogList());
							blogSer.add(blog);
						} catch (Exception e) {
							e.printStackTrace();
							log.error("【错误参数详情】"+gson.toJson(blog));
							try {
								//如果出错，这里一般是那个编码问题，而字符过滤又挺耗时，所以仅在出错时使用尝试解决问题
								blog=new Blog(EmojiFilterUtils.filterEmoji(title), EmojiFilterUtils.filterEmoji(content.html()), EmojiFilterUtils.filterEmoji(summary), list.get(i).getUrlBlogList());
								blogSer.add(blog);
							} catch (Exception e2) {
								e2.getMessage();
							}
						}finally {
							list.remove(i);
							//2019-6-19，张顺，保存日志
							Timeline tl=new Timeline();
							tl.setCreateTime(new Date());
							tl.setuId(Constans.CRAWLERNO1);
							tl.setpId(13);//操作：博客单条添加
							Blog blog2=new Blog(EmojiFilterUtils.filterEmoji(title), null, EmojiFilterUtils.filterEmoji(summary), null);
							tl.setInfo(gson.toJson(blog2));
							timelineMapper.insert(tl);
						}
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
	
	/**自动获取美团点评网的博客，规则如下：
	 * 1、如果没有这个博客栏目，则先创建再爬取
	 * 2、如果已经有了这篇博客（标题一样、所属栏目一样），则跳过*/
	private void getAllUrlAndList(){
		try {
			String urlroot="https://tech.meituan.com";
			
			String str=HttpClientReq.httpGet("https://tech.meituan.com/archives", null,null);
			Document doc=Jsoup.parse(str);
			Elements elements=doc.select(".post-title");
			//2019-6-13，张顺，由于点评网结构变化，所以相应修改
			Elements tagAll=doc.select(".tag-links");
			
			for (int i=0;i<elements.size();i++) {
				Element e=elements.get(i);
				//得到目标url
				String url=urlroot+e.select("a").get(0).attr("href");
				//得到标题
				String title=e.select("a").get(0).html();
//				log.error(i+"         "+elements.size()+"     "+title+"    "+list.size());
				//得到栏目名称
				Elements tags=tagAll.get(i).select("a");
				List<BlogList> blist=blogListSer.queryAll(Constans.CRAWLERNO1);
				List<Integer> urlbloglisttmp=new ArrayList<>();
				for (Element tag : tags) {
//					String stmp=tag.attr("href");
					String stmp=tag.html();
					//博客栏目名称
//					String stag=stmp.split("/")[stmp.split("/").length-1];
					String stag=stmp;
					//2019-6-13，现已不用，他的tag结构已经变化了
					boolean isHas=false;
					for (BlogList bl : blist) {
						if (stag.equals(bl.getName())) {
							urlbloglisttmp.add(bl.getId());
							isHas=true;
							break;
						}
					}
					//如果发现新栏目则创建博客栏目
					if (isHas==false) {
						String id=blogListSer.add(new BlogList(stag, new Date(), 1, Constans.CRAWLERNO1));
						urlbloglisttmp.add(Integer.valueOf(id));
						//2019-6-19，张顺，保存日志
						Timeline tl=new Timeline();
						tl.setCreateTime(new Date());
						tl.setuId(Constans.CRAWLERNO1);
						tl.setpId(7);//操作：博客栏目单条添加
						BlogList blogList=new BlogList(stag, new Date(), 1, Constans.CRAWLERNO1);
						blogList.setId(Trans.TransToInteger(id));
						tl.setInfo(gson.toJson(blogList));
						timelineMapper.insert(tl);
					}
				}
				
				if (title.equals("美团外卖客户端高可用建设体系 - 美团技术团队")) {
					log.error(blogMapper.queryByTitle(title).size());
					log.error(blogSer.queryByTitle(title).size());
				}
				
				//判断这个博客是否已经创建过？创建过就跳过，否则创建
				if(blogMapper.queryByTitle(title).size()>0){
					log.info("【判断这个博客是否已经创建过？创建过就跳过，否则创建】"+title+"("+url+")"+"  【list大小】"+list.size());
				}else{
					//保存这个博客的栏目id序列到list中
					CrawlerData1 ctmp=new CrawlerData1(url, gson.toJson(urlbloglisttmp));
					list.add(ctmp);
				}
			}
		} catch (Exception e) {
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

	public List<CrawlerData1> getList() {
		return list;
	}

	public void setList(List<CrawlerData1> list) {
		this.list = list;
	}
	
	
	public static void main(String[] args) {
		// 要验证的字符串
	    String str = "/https://baike.xsoftlab.net";
	    // 正则表达式规则
	    String regEx = "^/?http";
	    // 编译正则表达式
	    Pattern p = Pattern.compile(regEx);
	    // 忽略大小写的写法
	    // Pattern pat = Pattern.compile(regEx, Pattern.CASE_INSENSITIVE);
	    Matcher matcher = p.matcher(str);
	    // 查找字符串中是否有匹配正则表达式的字符/字符串
	    boolean rs = matcher.find();
	    System.out.println(rs);
	    System.out.println(Pattern.matches("^http", "https://baike.xsoftlab.net"));
	}
	
}
