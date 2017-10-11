package com.zs.tools;

import java.util.Calendar;
import java.util.Date;

import org.junit.Test;

import com.zs.entity.other.MyDate;

/**
 * 一些与日期时间有关的工具
 * @author 张顺
 *2017-5-27
 */
public class DateTimeHelper {

	
	//得到今天最开始的时间
	public static MyDate getBeginOfNow() {
		Calendar calendar=Calendar.getInstance();
		calendar.set(Calendar.HOUR_OF_DAY, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MILLISECOND, 0);
		return new MyDate(calendar.getTime());
	}
	
	//得到今天最后的时间
	public static MyDate getEndOfNow() {
		Calendar calendar=Calendar.getInstance();
		calendar.set(Calendar.HOUR_OF_DAY, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MILLISECOND, 0);
		calendar.add(Calendar.DAY_OF_MONTH, 1);
		calendar.add(Calendar.MILLISECOND, -1);
		return new MyDate(calendar.getTime());
	}
	
	//得到昨天8点的时间
	public static MyDate getBeginOfOld() {
		Calendar calendar=Calendar.getInstance();
		Date date = new Date();
		calendar.set(date.getYear()+1900,date.getMonth(),date.getDate()-1,8,0,0);
		return new MyDate(calendar.getTime());
	}
	
	//得到今天最7.59的时间
	public static MyDate getEndOfOld() {
		Calendar calendar=Calendar.getInstance();
		Date date = new Date();
		calendar.set(date.getYear()+1900,date.getMonth(),date.getDate(),7,59,59);
		return new MyDate(calendar.getTime());
	}
	
	
	/**
	 * @author John丶辉
	 * 得到传入时间的当天的23.59.59
	 * @param date
	 * @return
	 */
	public static Date getenddate(Date date){
		Calendar calendar=Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.DAY_OF_MONTH, 1);
		calendar.add(Calendar.MILLISECOND, -1);
		return calendar.getTime();
	}
	
	/**
	 * @author John丶辉
	 * 得到传入时间的当天的0.0.0
	 * @param date
	 * @return
	 */
	public static MyDate getstartdate(Date date){
		Calendar calendar=Calendar.getInstance();
		calendar.setTime(date);
		calendar.set(Calendar.HOUR_OF_DAY, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MILLISECOND, 0);
		calendar.add(Calendar.MILLISECOND, 0);
		return new MyDate(calendar.getTime());
	}
	
	/**
	 * @author John丶辉
	 * 得到传入时间的第二天的7.59
	 * @param date
	 * @return
	 */
	public static Date getenddate8(Date date){
		Calendar calendar=Calendar.getInstance();
		calendar.set(date.getYear()+1900,date.getMonth(),date.getDate()+1,7,59,59);
		calendar.set(Calendar.MILLISECOND ,0);
		return calendar.getTime();
	}
	
	/**
	 * @author John丶辉
	 * 得到传入时间的当天的8点
	 * @param date
	 * @return
	 */
	public static Date getstartdate8(Date date){
		Calendar calendar=Calendar.getInstance();
		calendar.set(date.getYear()+1900,date.getMonth(),date.getDate(),8,0,0);
		calendar.set(Calendar.MILLISECOND ,0);
		return calendar.getTime();
	}
	
	/**
	 * @author John丶辉
	 * 得到传入时间的当天的7.59
	 * @param date
	 * @return
	 */
	public static Date getendnewdate8(Date date){
		Calendar calendar=Calendar.getInstance();
		calendar.set(date.getYear()+1900,date.getMonth(),date.getDate(),7,59,59);
		calendar.set(Calendar.MILLISECOND ,0);
		return calendar.getTime();
	}
	
	/**
	 * @author John丶辉
	 * 得到传入时间的昨天的8点
	 * @param date
	 * @return
	 */
	public static Date getstartolddate8(Date date){
		Calendar calendar=Calendar.getInstance();
		calendar.set(date.getYear()+1900,date.getMonth(),date.getDate()-1,8,0,0);
		calendar.set(Calendar.MILLISECOND ,0);
		return calendar.getTime();
	}
	
	
	public static MyDate getolddate(){
		Calendar calendar=Calendar.getInstance();
		Date date = new Date();
		calendar.set(date.getYear()+1900,date.getMonth(),date.getDate()-1,0,0,0);
		return new MyDate(calendar.getTime());
	}
	
	public static int getyear(){
		return new Date().getYear()+1900;
	}
	
	public static int getmonth(){
		return new Date().getMonth()+1;
	}
	
	public static Date getmonthStart(int year,int month){
		Calendar calendar=Calendar.getInstance();
		calendar.set(year,month-1,1,0,0,0);
		calendar.set(Calendar.MILLISECOND ,0);
		return calendar.getTime();
	}
	
	public static Date getmonthEnd(int year,int month){
		Calendar calendar=Calendar.getInstance();
		calendar.set(Calendar.YEAR, year);
		calendar.set(Calendar.MONTH, month);
		calendar.set(Calendar.DAY_OF_MONTH, 1);
		calendar.set(Calendar.HOUR_OF_DAY, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MILLISECOND, 0);
		calendar.add(Calendar.MILLISECOND, 0);
		return calendar.getTime();
	}
	
	@Test
	public void test(){
		int i = 1;
		System.out.println();
	}
}
