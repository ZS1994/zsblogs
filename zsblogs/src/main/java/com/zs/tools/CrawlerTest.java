package com.zs.tools;
import java.net.URLEncoder;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import com.zs.entity.Blog;
import com.zs.service.BlogSer;
import com.zs.service.impl.BlogSerImpl;

/**
 * 2017-11-12
 * @author 张顺
 * 爬虫的第一次尝试
 */
public class CrawlerTest {

	private BlogSer blogSer;
	
	
	public CrawlerTest(BlogSer blogSer) {
		super();
		this.blogSer = blogSer;
	}



	public void work() {
		try {
			String root="https://tech.meituan.com";
			String str=HttpClientReq.httpGet("https://tech.meituan.com/cache_about.html", "", "");
			Document doc=Jsoup.parse(str);
			Elements title=doc.select(".article__title .title");
			Elements content=doc.select(".article__content");
			Elements imgs=content.select("img");
			for (Element img : imgs) {
//				System.out.println(img.attr("src"));
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
//					System.out.println(imgsrc);
//					System.out.println(fileName);
					DownloadImg.download(imgsrc, fileName);
					img.attr("src", "/tomcat_imgs/"+fileName);
				}
			}
			System.out.println(content.html());
			
			Blog blog=new Blog(title.html(), content.html(), "爬虫机器人1号爬取", "[7]");
			blogSer.add(blog);
		} catch (Exception e) {
			e.printStackTrace();
		}
				
	}
	
	
}
