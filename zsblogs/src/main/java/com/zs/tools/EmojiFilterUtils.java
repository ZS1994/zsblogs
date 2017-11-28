package com.zs.tools;

import org.apache.commons.lang3.StringUtils; 

/**
 * 2017-11-28
 * 今天偶然遇到一个错误，提示有特殊字符无法存储数据库，经查找，发现mysql的utf-8不支持3个字节以上的字符，且提供了两种方法：<br>
 * 1、改数据裤编码格式为utf8mb4,但要改的东西很多，且尝试没有成功，故放弃<br>
 * 2、过滤这些不支持的字符<br>
 * 其实这些是无复制的，正则表达式我自己都不会用，而且我也不知道哪些字符不支持
 * @author 张顺
 *
 */
public class EmojiFilterUtils {
	/** 
     * 将emoji表情替换成* 
     *  
     * @param source 
     * @return 过滤后的字符串 
     */  
    public static String filterEmoji(String source) {  
        if(StringUtils.isNotBlank(source)){  
            return source.replaceAll("[\\ud800\\udc00-\\udbff\\udfff\\ud800-\\udfff]", "*");  
        }else{  
            return source;  
        }  
    }  
    public static void main(String[] arg ){  
        try{  
            String text = "This is a smiley \uD83C\uDFA6 face\uD860\uDD5D \uD860\uDE07 \uD860\uDEE2 \uD863\uDCCA \uD863\uDCCD \uD863\uDCD2 \uD867\uDD98 ";  
            System.out.println(text);  
            System.out.println(text.length());  
            System.out.println(text.replaceAll("[\\ud83c\\udc00-\\ud83c\\udfff]|[\\ud83d\\udc00-\\ud83d\\udfff]|[\\u2600-\\u27ff]", "*"));  
            System.out.println(filterEmoji(text));  
        }catch (Exception ex){  
            ex.printStackTrace();  
        }  
    }  
}
