package com.zs.entity.other;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 高级date
 * 新增几个转String方法
 * @author 张顺
 * 2017-5-27
 */
public class MyDate extends Date{
	
	Date date;
	
	public MyDate(Date date){
		this.date=date;
	}
	
	public String toString1(){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return sdf.format(date);
	}
	
	public String toString2(){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		return sdf.format(date);
	}
	
	public String toString3(){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		return sdf.format(date);
	}
	
	public String toString4(){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
		return sdf.format(date);
	}
	
}