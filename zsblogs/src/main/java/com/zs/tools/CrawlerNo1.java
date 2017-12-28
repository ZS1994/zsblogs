package com.zs.tools;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import com.google.gson.Gson;
import com.zs.entity.Blog;
import com.zs.entity.BlogList;
import com.zs.entity.other.CrawlerData1;
import com.zs.service.BlogListSer;
import com.zs.service.BlogSer;

/**
 * 2017-11-12
 * @author 张顺
 * 爬虫的第一次尝试，爬虫机器人1号
 */
public class CrawlerNo1 implements Runnable{

	private BlogSer blogSer;
	private BlogListSer blogListSer;
	private static CrawlerNo1 no1=new CrawlerNo1();
	
	private List<CrawlerData1> list=new ArrayList<>();
	
	private boolean isBegin=false;//是否开始
	private Gson gson=new Gson();
	private Logger log=Logger.getLogger(getClass());
	
	
	private CrawlerNo1() {
		super();
	}


	/**
	 * 初始化并返回机器人
	 * @param blogSer
	 * @return
	 */
	public static CrawlerNo1 init(BlogSer blogSer,BlogListSer blogListSer) {
		no1.blogSer = blogSer;
		no1.blogListSer = blogListSer;
		return no1;
	}
	
	/**
	 * 返回机器人
	 * @param blogSer
	 * @return
	 */
	public static CrawlerNo1 getInstance() {
		return no1;
	}
	
	@Deprecated
	public CrawlerNo1 addUrl(String url){
//		urls.add(url);
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
	
	public CrawlerNo1 beginWorkThread(){
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
					getAllUrlAndList();
//					System.out.println("list的大小是："+list.size());
//					log.info("list的大小是："+list.size());
					for (int i = list.size()-1; i >= 0; i--) {
						Blog blog=null;
						Elements content=null;
						Elements title=null;
						String summary=null;
						Elements imgs=null;
						try {
							String url=list.get(i).getUrl();
							url=url.replaceAll(" ", "%20");
							String root=url.split("//")[0]+"//"+url.split("//")[1].split("/")[0];
							String str=HttpClientReq.httpGet(url, null,null);
							Document doc=Jsoup.parse(str);
							Elements summaryE=doc.select("meta[name=description]");
							summary=summaryE.size()>0?summaryE.get(0).attr("content"):"[未获取到摘要]";
							title=doc.select(".article__title .title");
							content=doc.select(".article__content");
							imgs=content.select("img");
							for (Element img : imgs) {
								String src=img.attr("src");
								String fileName;
								if(src!=null){
									src=src.indexOf("/")==0?src:"/"+src;
									String ss[]=src.split("/");					
									fileName=ss[ss.length-1];
									String srctmp="";
									for (String s : ss) {
										s=URLEncoder.encode(s, "utf-8");
										srctmp=srctmp+s+"/";
									}
									srctmp=srctmp.equals("")?srctmp:srctmp.substring(0, srctmp.lastIndexOf("/"));
									String imgsrc=root+srctmp;
									String newImgPath=DownloadImg.download(imgsrc, fileName);
									img.attr("src", "/tomcat_imgs/"+newImgPath);
								}
							}
							blog=new Blog(title.html(), content.html(), summary, list.get(i).getUrlBlogList());
							blogSer.add(blog);
						} catch (Exception e) {
							e.printStackTrace();
							log.error("【错误参数详情】"+gson.toJson(blog));
							try {
								//如果出错，这里一般是那个编码问题，而字符过滤又挺耗时，所以仅在出错时使用尝试解决问题
								blog=new Blog(EmojiFilterUtils.filterEmoji(title.html()), EmojiFilterUtils.filterEmoji(content.html()), EmojiFilterUtils.filterEmoji(summary), list.get(i).getUrlBlogList());
								blogSer.add(blog);
							} catch (Exception e2) {
								e2.getMessage();
							}
						}finally {
							CrawlerData1 res=list.remove(i);
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
			Elements elements=doc.select("article");
			for (Element e : elements) {
				//得到目标url
				String url=urlroot+e.select("header").get(0).select("a").get(0).attr("href");
				//得到标题
				String title=e.select("header").get(0).select("a").get(0).html();
				//得到栏目名称
				Elements tags=e.select("footer").get(0).select("a");
				List<BlogList> blist=blogListSer.queryAll(6);
				List<Integer> urlbloglisttmp=new ArrayList<>();
				for (Element tag : tags) {
					String stmp=tag.attr("href");
					//博客栏目名称
					String stag=stmp.split("/")[stmp.split("/").length-1];
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
						String id=blogListSer.add(new BlogList(stag, new Date(), 1, 6));
						urlbloglisttmp.add(Integer.valueOf(id));
					}
				}
				//判断这个博客是否已经创建过？创建过就跳过，否则创建
				if(blogSer.queryByTitle(title).size()>0){
					continue;
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


	public BlogSer getBlogSer() {
		return blogSer;
	}


	public void setBlogSer(BlogSer blogSer) {
		this.blogSer = blogSer;
	}


	public boolean getIsBegin() {
		return isBegin;
	}


	public void setIsBegin(boolean isBegin) {
		this.isBegin = isBegin;
	}


	public BlogListSer getBlogListSer() {
		return blogListSer;
	}


	public void setBlogListSer(BlogListSer blogListSer) {
		this.blogListSer = blogListSer;
	}


	public List<CrawlerData1> getList() {
		return list;
	}


	public void setList(List<CrawlerData1> list) {
		this.list = list;
	}
	
	
	
	
	
}
