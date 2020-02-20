package com.zs.quartz;

import java.util.ArrayList;
import java.util.List;
import org.apache.log4j.Logger;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.util.StringUtils;

import com.alibaba.fastjson.JSONObject;
import com.zs.entity.Blog;
import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.WeChatAddNews;
import com.zs.service.BlogSer;
import com.zs.tools.Constans;
import com.zs.tools.DownloadImg;
import com.zs.tools.SpringUtil;
import com.zs.tools.WeChatConstans;


/**
 * 2020-1-30
 * @author 张顺
 * 自动添加永久素材
 * 
 */
public class WeChatAddNewsJob implements Job{

	private WeChatConstans weChatConstans;
	private BlogSer blogSer;
	private DownloadImg downloadImg;
	private Logger log = Logger.getLogger(getClass());
	private final String UPLOAD_WE_SUCC = "UPLOAD_WE_SUCC";
	private final String UPLOAD_WE_FAIL = "UPLOAD_WE_FAIL";
	
	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		
		if (weChatConstans == null) {
			weChatConstans = (WeChatConstans) SpringUtil.getBean("weChatConstans");
		}
		if (blogSer == null) {
			blogSer = (BlogSer) SpringUtil.getBean("blogSer");
		}
		if (downloadImg == null) {
			downloadImg = (DownloadImg) SpringUtil.getBean("downloadImg");
		}
		Blog blog = null;
		try {
			/*
			//获取素材总数，然后从数据库取后一篇文章出来
			String stmp = weChatConstans.getMaterialcount();
			if (StringUtils.isEmpty(stmp)) {
				log.info("素材总数没有获取到，所以自动终止");
				return;
			}
			int newsCount = new JSONObject().parseObject(stmp).getIntValue("news_count");
			*/
			Blog blogTmp = blogSer.queryNoUploadWeBlog();
			if (blogTmp == null) {
				log.info("没有找到博客了，所以自动终止.");
				return;
			}
			//测试422
			blog = blogSer.get(blogTmp.getId());
			//blog = blogSer.get(422);
			
			//先上传图片，然后拿第一张素材的图片作为封面id
			String content = blog.getContent();//内容
			
			//得到所有的图片,将所有的图片路径全部转换为腾讯的路径，并且得到封面的id
			Document document = Jsoup.parse(content);
			Elements imgs = document.select("img");
			//如果这篇博客一个图片也没有，那么就使用一个固定的封面id,所以先给一个默认的值
			String thumbMediaId = "LbGr0lCOP0OTjYw03x-p68rS25Blqa3nWODA2af3oGg";
			for (int i = 0; i < imgs.size(); i++) {
				Element img = imgs.get(i);
				String src = img.attr("src");
				if (!StringUtils.isEmpty(src)){
					//转换为真实路径
					src = src.replace(Constans.PATH_TOMCAT_IMGS, downloadImg.getPathRoot());
					log.info("转换为的真实的图片的是："+src);
					//如果是第一张图就用图品素材，如果不是第一张图就用上传图片
					if (i == 0) {
						String res = weChatConstans.addMaterial("image", src);
						if (!StringUtils.isEmpty(res)) {
							JSONObject json = new JSONObject().parseObject(res);
							thumbMediaId = json.getString("media_id");
							//然后将url换成腾讯的url
							String url = json.getString("url");
							if (!StringUtils.isEmpty(url)) {
								img.attr("src", url);
								log.info(url);
							}
						}
					}else {
						String url = new JSONObject().parseObject(weChatConstans.uploadimg(src)).getString("url");
						if (!StringUtils.isEmpty(url)) {
							img.attr("src", url);	
							log.info(url);
						}
					}
				}
			}
			
			
			//然后添加图文素材
			WeChatAddNews news = new WeChatAddNews();
			
			//否	作者
			if (blog.getUser() != null ) {
				news.setAuthor(blog.getUser().getName());
			}
			//是	图文消息的具体内容，支持HTML标签，必须少于2万字符，小于1M，且此处会去除JS,涉及图片url必须来源 "上传图文消息内的图片获取URL"接口获取。外部图片url将被过滤。
			news.setContent(document.html());
			//是	图文消息的原文地址，即点击“阅读原文”后的URL
			news.setContent_source_url("http://47.103.105.215/zsblogs/menu/blogList/blog/one?id=" + blog.getId());
			//否	图文消息的摘要，仅有单图文消息才有摘要，多图文此处为空。如果本字段为没有填写，则默认抓取正文前64个字。
			news.setDigest(blog.getSummary());
			//否	Uint32 是否打开评论，0不打开，1打开
			news.setNeed_open_comment("0");
			//否	Uint32 是否粉丝才可评论，0所有人可评论，1粉丝才可评论
			news.setOnly_fans_can_comment("0");
			//是	是否显示封面，0为false，即不显示，1为true，即显示
			news.setShow_cover_pic("1");
			//是	图文消息的封面图片素材id（必须是永久mediaID）
			news.setThumb_media_id(thumbMediaId);
			//是 标题
			news.setTitle(blog.getTitle());
			log.info(new JSONObject().toJSON(news).toString());
			String newsres = weChatConstans.addNews(news);
			if (new JSONObject().parseObject(newsres).getString("errcode") != null) {
				//代表失败了
				blog.setState(UPLOAD_WE_FAIL);
			}else {
				//代表成功了
				blog.setState(UPLOAD_WE_SUCC);
			}
			blogSer.update(blog);
		} catch (Exception e) {
			log.error(e.toString());
			//如果失败了，那么就把这篇博客记为失败
			if (blog != null) {
				blog.setState(UPLOAD_WE_FAIL);
				blogSer.update(blog);
			}
		};
	}

	
	
	

}
