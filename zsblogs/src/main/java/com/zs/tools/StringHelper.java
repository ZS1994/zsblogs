package com.zs.tools;

import com.google.gson.Gson;

/**
 * 关于字符串的一些处理方法
 * 1、通配符匹配
 * @author 张顺
 * 2017年10月17日14:23:55
 */
public class StringHelper {

	private static Gson gson=new Gson();
	
	/**
	* 找出含？的字符串
	* @return
	*/
	public static int checkSubPattern(String src,int begin,String pat){
		boolean isFound=true;
		if(src.length()-begin < pat.length()){return -1;}
		for(int i=begin;i<src.length()-pat.length()+1;i++){
			for(int j=0;j<pat.length();j++){
				if(pat.charAt(j)!='?' && src.charAt(i+j)!=pat.charAt(j)){
					isFound =false;
					break;
				}
				isFound = true;
			}
			if(isFound){return i;}
		}
		return -1;
	}


	/**
	 * 带*的通配符匹配
	 * @param src
	 * @param pat
	 * @return
	 */
	public static boolean checkStar(String src,String pat){
		String[] sub_p = pat.split("\\*");
		int begin =0;
		for(int i=0;i< sub_p.length;i++){
			begin = checkSubPattern(src,begin,sub_p[i]);
			if(begin==-1){return false;}
			if(i==0 && pat.charAt(0)!='*' && begin!=0){return false;}
			if((i==sub_p.length-1) && pat.charAt(pat.length()-1)!='*' && begin!=(src.length()-sub_p[i].length())){
				return false;
			}
		}
		//当*在末尾的时候，在匹配时必须排除"/"
		if(pat.charAt(pat.length()-1)=='*'){
			String patmowei=sub_p[sub_p.length-1];
			String srcs[]=src.split(patmowei);
			String srcmowei=srcs.length>0?srcs[srcs.length-1]:null;
			if(srcmowei==null){
				return false;
			}else{
				if(srcmowei.indexOf("/")!=-1){
					return false;
				}
			}
		}
		return true;
	}	
	
	public static void main(String[] args) {
		System.out.println(StringHelper.checkStar("asdad11sda23232aaa", "asdad*sda*aaa"));
		System.out.println(StringHelper.checkStar("asdad11sda23232aaa", "asdad11sda23232aaa"));
		System.out.println(StringHelper.checkStar("asdad11sda23232aaa", "asda22d11sda23232aaa"));
		System.out.println(StringHelper.checkStar("/zsblogs/menu/blogList/blog/5", "/zsblogs/menu/blogList/blog/*"));
		System.out.println(StringHelper.checkStar("/zsblogs/menu/blogList/blog/edit/1", "/zsblogs/menu/blogList/blog/*"));
	}
}
