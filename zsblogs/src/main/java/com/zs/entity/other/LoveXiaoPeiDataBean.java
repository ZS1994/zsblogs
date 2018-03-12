package com.zs.entity.other;

import java.util.HashMap;

import com.zs.tools.NameOfDate;

/*
 * 张顺，2018-3-10
 * 这将是一个图的结构
 * 其基本结构为我问小佩答，然后会有多个答案，每个答案又会有不同的分支，分支也有可能会回到某个父节点上
 * 
 */
public class LoveXiaoPeiDataBean {

	private String id;//作为唯一标示
	private String author;//作者，谁说的话，当作者是小佩的时候xpAnswer无效；当作者是我的时候，xpAnswer有效
	private String message;//问话内容
	private ListPlus child;//子项
	private HashMap<String, String> otherInfo;//其他信息，备用
	private int delay=3000;//延时多少秒，默认给一点延迟
	
	
	public int getDelay() {
		return delay;
	}
	public LoveXiaoPeiDataBean setDelay(int delay) {
		this.delay = delay;
		return this;
	}
	public HashMap<String, String> getOtherInfo() {
		return otherInfo;
	}
	public LoveXiaoPeiDataBean setOtherInfo(HashMap<String, String> otherInfo) {
		this.otherInfo = otherInfo;
		return this;
	}
	public String getAuthor() {
		return author;
	}
	public LoveXiaoPeiDataBean setAuthor(String author) {
		this.author = author;
		return this;
	}
	public String getMessage() {
		return message;
	}
	public LoveXiaoPeiDataBean setMessage(String message) {
		this.message = message;
		return this;
	}
	public ListPlus getChild() {
		return child;
	}
	public LoveXiaoPeiDataBean setChild(ListPlus child) {
		this.child = child;
		return this;
	}
	public String getId() {
		return id;
	}
	public LoveXiaoPeiDataBean setId(String id) {
		this.id = id;
		return this;
	}
	
	
	public LoveXiaoPeiDataBean(String author, String message) {
		super();
		this.author = author;
		this.message = message;
		this.id=NameOfDate.getNum();
	}
	
	
	public LoveXiaoPeiDataBean(String author, String message, ListPlus child) {
		super();
		this.author = author;
		this.message = message;
		this.child = child;
		this.id=NameOfDate.getNum();
	}
	
	
	public LoveXiaoPeiDataBean(String author, String message, int delay, ListPlus child) {
		super();
		this.author = author;
		this.message = message;
		this.child = child;
		this.delay = delay;
		this.id=NameOfDate.getNum();
	}
	public LoveXiaoPeiDataBean() {
		super();
		this.id=NameOfDate.getNum();
	}
	
	
	public LoveXiaoPeiDataBean selectById(String id){
		String idtmp=getId();
		if (idtmp.equals(id)) {
			return this;
		}else{
			if (getChild()!=null) {
				for (LoveXiaoPeiDataBean bean : getChild()) {
					return bean.selectById(id);
				}
			}
		}
		return null;
	}
	
	public LoveXiaoPeiDataBean toSendBean(){
		LoveXiaoPeiDataBean tmp=new LoveXiaoPeiDataBean().setAuthor(getAuthor()).setId(getId()).setMessage(getMessage());
		return tmp;
	}
}
