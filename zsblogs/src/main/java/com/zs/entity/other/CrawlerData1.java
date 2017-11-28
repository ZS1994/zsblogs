package com.zs.entity.other;

public class CrawlerData1 {

	private String url;
	private String urlBlogList;
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getUrlBlogList() {
		return urlBlogList;
	}
	public void setUrlBlogList(String urlBlogList) {
		this.urlBlogList = urlBlogList;
	}
	public CrawlerData1() {
		super();
	}
	public CrawlerData1(String url, String urlBlogList) {
		super();
		this.url = url;
		this.urlBlogList = urlBlogList;
	}
	
}
