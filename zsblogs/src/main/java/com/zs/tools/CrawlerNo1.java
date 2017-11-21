package com.zs.tools;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import com.zs.entity.Blog;
import com.zs.service.BlogSer;

/**
 * 2017-11-12
 * @author 张顺
 * 爬虫的第一次尝试，爬虫机器人1号
 */
public class CrawlerNo1 implements Runnable{

	private BlogSer blogSer;
	private static CrawlerNo1 no1=new CrawlerNo1();
	
	private List<String> urls=new ArrayList<>();//待爬取的url列表
	private boolean isBegin=false;//是否开始
	
	private CrawlerNo1() {
		super();
	}


	/**
	 * 初始化并返回机器人
	 * @param blogSer
	 * @return
	 */
	public static CrawlerNo1 init(BlogSer blogSer) {
		no1.blogSer = blogSer;
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
	
	public CrawlerNo1 addUrl(String url){
		urls.add(url);
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
		try {
			while(true){
				if (isBegin && urls.size()>0) {
					for (int i = urls.size()-1; i >= 0; i--) {
						String url=urls.get(i);
						String root=url.split("//")[0]+"//"+url.split("//")[1].split("/")[0];
						String str=HttpClientReq.httpGet(url, "", "");
						Document doc=Jsoup.parse(str);
						Elements summaryE=doc.select("meta[name=description]");
						String summary=summaryE.size()>0?summaryE.get(0).attr("content"):"[未获取到摘要]";
						Elements title=doc.select(".article__title .title");
						Elements content=doc.select(".article__content");
						Elements imgs=content.select("img");
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
						
						Blog blog=new Blog(title.html(), content.html(), summary, "[8]");
						blogSer.add(blog);
						
						String res=urls.remove(i);
						System.out.println(res);
					}
				}else{
					Thread.sleep(1000*1);//每1秒进行一次判断
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


	public List<String> getUrls() {
		return urls;
	}


	public void setUrls(List<String> urls) {
		this.urls = urls;
	}


	public boolean getIsBegin() {
		return isBegin;
	}


	public void setIsBegin(boolean isBegin) {
		this.isBegin = isBegin;
	}
	
	
	
}
