package com.zs.tools;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;

public class Trans {
	
	static Logger log = Logger.getLogger(Trans.class);

	public static Date TransToDate(String str){
		if(str!=null && !str.trim().equals("")){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd");
			try {
				Date date = sdf.parse(str);
				return date;
			} catch (ParseException e) {
				try {
					Date date = sdf2.parse(str);
					return date;
				} catch (Exception e2) {
					e.printStackTrace();
					log.error("字符串转Date类型失败，错误字符转为："+str);
					return null;
				}
			}
		}else{
			return null;
		}
	}
	
	public static Date TransToDate(String str,String df){
		if(str!=null && !str.trim().equals("") && df!=null && !df.trim().equals("")){
			SimpleDateFormat sdf = new SimpleDateFormat(df);
			try {
				Date date = sdf.parse(str);
				return date;
			} catch (ParseException e) {
				e.printStackTrace();
				log.error("字符串转Date类型失败，错误字符转为："+str);
				return null;
			}
		}else{
			return null;
		}
	}
	
	public static Integer TransToInteger(String str){
		Integer i=null;
		if(str!=null && !str.trim().equals("")){
			try {
				i=Integer.valueOf(str);
				return i;
			} catch (Exception e) {
				log.error("字符串转Integer类型失败，错误字符转为："+str);
				return i;
			}
		}
		return i;
	}
	public static String TransToString(Date date){
		String str=null;
		if(date!=null){
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
			try {
				str=sdf.format(date);
				return str;
			} catch (Exception e) {
				log.error("Date转String类型失败，错误为："+date);
				return str;
			}
		}
		return str;
	}
	
	public static Double toDouble(String str) {
		Double d=null;
		if (str!=null && !str.trim().equals("")) {
			try {
				d=Double.valueOf(str);
			} catch (Exception e) {
				log.error("String转Double类型失败，错误为："+str);
			}
		}
		return d;
	}
	public static String toString(Double d) {
		String str=null;
		if (d!=null) {
			try {
				str=String.valueOf(d);
			} catch (Exception e) {
				log.error("Double转String类型失败，错误为："+d);
			}
		}
		return str;
	}
	
	public static Timestamp toTimestamp(String str){
		if(str!=null && !str.trim().equals("")){
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			try {
				Date date = sdf.parse(str);
				return new Timestamp(date.getTime());
			} catch (ParseException e) {
				SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
				try {
					Date date1 = sdf1.parse(str);
					return new Timestamp(date1.getTime());
				} catch (ParseException e1) {
					e1.printStackTrace();
					log.error("字符串转Timestamp类型失败，错误字符转为："+str);
					return null;
				}
			}
		}else{
			return null;
		}
	}
	
	public static String TimestampTransToString(Date time){
		String str=null;
		if(time!=null){
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
			try {
				str=sdf.format(time);
				return str;
			} catch (Exception e) {
				log.error("Date转String类型失败，错误为："+time);
				return str;
			}
		}
		return str;
	}
	
	public static BigDecimal toBigDecimal(String str){
		if (str!=null && !str.trim().equals("")) {
			str=str.replace("," , "");
			return new BigDecimal(str);
		}
		return null;
	}
	
	public static BigDecimal toBigDecimal0(String str){
		if (str!=null && !str.trim().equals("")) {
			str=str.replace("," , "");
			return new BigDecimal(str);
		}
		return new BigDecimal(0);
	}
	
	public static String tostring(String str){
		if(str!=null){
			str=str.trim();
			str=str.replace(",", "");
		}
		return str;
	}
	
	/**
	 * 年月日时分秒毫秒转为年月日
	 */
	public static Date timeToDate(Date date){
		if (date!=null) {
			Calendar calendar=Calendar.getInstance();
			calendar.setTime(date);
			calendar.set(Calendar.HOUR_OF_DAY, 0);
			calendar.set(Calendar.MINUTE, 0);
			calendar.set(Calendar.SECOND, 0);
			calendar.set(Calendar.MILLISECOND, 0);
			return calendar.getTime();
		}
		return null;
	}
	
	public static String handleCtmBarCode(String barcodes){
		if (barcodes==null) {
			return null;
		}
		String ss[]=barcodes.split(",");
		String re="";
		for (int i = 0; i < ss.length; i++) {
			re=re+"'"+ss[i]+"',";
		}
		return re.substring(0, re.lastIndexOf(","));
	}
	
	public static BigDecimal TimeForBig(Timestamp ts){
		long bg =(ts.getHours()*60*60+ts.getMinutes()*60+ts.getSeconds());
		return new BigDecimal(bg);
	}
	
	public static Integer toStringBig(BigDecimal b){
		if(b!=null){
			Integer in =Integer.parseInt(b.toString());
			return in;
		}else{
			return 0;
		}
		
	}
	
	public static String BigDecimalForHours(BigDecimal b){
		if(b!=null){
			Integer it = Integer.parseInt(b.toString());
			Integer h =it/3600;
			Integer m =(it%3600)/60;
			Integer s =(it%3600)%60;
			String mm = "";
			String ss = "";
			if(m<10){
				mm="0"+m;
			}else{
				mm=""+m;
			}
			if(s<10){
				ss="0"+s;
			}else{
				ss=""+s;
			}
			return h + ":" +mm+":"+ss;
		}else{
			return 0+":00"+":00";
		}
	}
	
	public static String intForHours(int it){
		if(it!=0){
			Integer h =it/3600;
			Integer m =(it%3600)/60;
			Integer s =(it%3600)%60;
			String mm = "";
			String ss = "";
			if(m<10){
				mm="0"+m;
			}else{
				mm=""+m;
			}
			if(s<10){
				ss="0"+s;
			}else{
				ss=""+s;
			}
			return h + ":" +mm+":"+ss;
		}else{
			return 0+":00"+":00";
		}
	}
	public static String strToHtml(String str){
		return "<pre>"+str+"</pre>";
	}
}
