package com.zs.tools;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.zs.entity.Users;

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
	/**
	 * 张顺，2018-3-16，该方法已废弃，以后将使用strToHtml(Exception e,HttpServletRequest req)方法
	 * @param e
	 * @return
	 */
	@Deprecated
	public static String strToHtml(Exception e){
		return strToHtml(e, null);
	}
	//张顺，以后使用这个函数，因为好多时候只知道异常，却不知道是谁导致了异常
	public static String strToHtml(Exception e,HttpServletRequest req){
		String u="（无法获取该用户信息）";
		if (req!=null) {
			Users user=(Users) req.getAttribute(Constans.USER);
			if (user!=null) {
				u=user.getName()+"（"+user.getId()+"）";
			}
		}
		String str="<pre>"+
				"【操作用户id】："+u+"\r\n"+
				"【异常产生时间】："+new Date().toLocaleString()+"\r\n"+
				"【异常详情】：\r\n"+
				getExceptionAllinformation(e)+"</pre>";
		return str;
	}
	
	public static String getExceptionAllinformation(Exception ex){
        String sOut = ex.getMessage()+"<br>";
        sOut=sOut+ex.getClass().getName()+"\r\n"; 
        StackTraceElement[] trace = ex.getStackTrace();
        for (StackTraceElement s : trace) {
            sOut += "\tat " + s + "\r\n";
        }
        return sOut;
    }
	
	public static boolean StrEmpty(String str) {
		return str==null || (str!=null && str.trim().equals(""));
	}
	
	//省略多少小数位
	public static Double omissionDecimal(Double d,int n){
		return new BigDecimal(d).setScale(n, BigDecimal.ROUND_HALF_UP).doubleValue();
	}
	
	
}
