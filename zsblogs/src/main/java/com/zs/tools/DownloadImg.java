package com.zs.tools;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
  
/** 
 * 2017-11-20
 * 下载图片 
 * @author 张顺
 * 
 */  
public class DownloadImg {  
  
	private static final String PATH_ROOT="E:/tomcat_imgs/";
	
	/** 
     * 测试 
     * @param args 
     */  
    public static String download(String url,String fileName) {  
        byte[] btImg = getImageFromNetByUrl(url);  
        if(null != btImg && btImg.length > 0){  
//            System.out.println("读取到：" + btImg.length + " 字节");  
            return writeImageToDisk(btImg, fileName);  
        }else{  
            System.out.println("没有从该连接获得内容");
            return null;
        }
    }
    /** 
     * 将图片写入到磁盘 
     * @param img 图片数据流 
     * @param fileName 文件保存时的名称 
     */  
    public static String writeImageToDisk(byte[] img, String fileName){  
        try {  
        	//先创建一个文件夹
        	String dirname=NameOfDate.getDir()+"/";
        	File dirFile=new File(PATH_ROOT+dirname);
        	if (!dirFile.exists()) {
				dirFile.mkdirs();
			}
        	//将文件名改为时间+原始文件名，防止重名
        	String fileNameTmp=NameOfDate.getFileName()+"_"+fileName;
            File file = new File(PATH_ROOT+dirname+fileNameTmp);
            while(file.exists()==true){//这个文件如果存在，也就是重名的话
				//先延迟500ms，然后再生成一个名字
				Thread.sleep(500);
				fileNameTmp=NameOfDate.getFileName()+"_"+fileName;
				file = new File(PATH_ROOT+dirname+fileNameTmp);
            }
            FileOutputStream fops = new FileOutputStream(file);  
            fops.write(img);  
            fops.flush();  
            fops.close();
//            System.out.println("图片已经写入到"+(PATH_ROOT+dirname+fileNameTmp));
            return dirname+fileNameTmp;
        } catch (Exception e) {  
            e.printStackTrace();
            return null;
        }  
    }  
    /** 
     * 根据地址获得数据的字节流 
     * @param strUrl 网络连接地址 
     * @return 
     */  
    public static byte[] getImageFromNetByUrl(String strUrl){  
        try {  
            URL url = new URL(strUrl);  
            HttpURLConnection conn = (HttpURLConnection)url.openConnection();  
            conn.setRequestMethod("GET");  
            conn.setConnectTimeout(5 * 1000);  
            InputStream inStream = conn.getInputStream();//通过输入流获取图片数据  
            byte[] btImg = readInputStream(inStream);//得到图片的二进制数据  
            return btImg;  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
        return null;  
    } 
    
    /** 
     * 直接给一个流，文件上传用的到
     * @param inStream 图片流
     * @return 
     */  
    public static byte[] getImageFromNetByUrl(InputStream inStream){  
        try {  
            byte[] btImg = readInputStream(inStream);//得到图片的二进制数据  
            return btImg;  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
        return null;  
    }  
    
    /** 
     * 从输入流中获取数据 
     * @param inStream 输入流 
     * @return 
     * @throws Exception 
     */  
    public static byte[] readInputStream(InputStream inStream) throws Exception{  
        ByteArrayOutputStream outStream = new ByteArrayOutputStream();  
        byte[] buffer = new byte[1024];  
        int len = 0;  
        while( (len=inStream.read(buffer)) != -1 ){  
            outStream.write(buffer, 0, len);  
        }  
        inStream.close();  
        return outStream.toByteArray();  
    }  
  
    
    public static void main(String[] args) {  
    String url = "http://www.baidu.com/img/baidu_sylogo1.gif";  
	    byte[] btImg = getImageFromNetByUrl(url);  
	    if(null != btImg && btImg.length > 0){  
//	        System.out.println("读取到：" + btImg.length + " 字节");  
	        String fileName = "百度.gif";  
	        writeImageToDisk(btImg, fileName);  
	    }else{  
	        System.out.println("没有从该连接获得内容");  
	    }  
	}
}  