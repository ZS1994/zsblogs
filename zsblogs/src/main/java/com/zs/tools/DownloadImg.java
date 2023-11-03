package com.zs.tools;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * 2017-11-20
 * 下载图片
 *
 * @author 张顺
 */
@Component
public class DownloadImg {

    private Logger log = Logger.getLogger(getClass());

    private String pathRoot;

    public String getPathRoot() {
        return pathRoot;
    }

    public void setPathRoot(String pathRoot) {
        this.pathRoot = pathRoot;
    }

    /**
     * 测试
     *
     * @param args
     */
    public String download(String url, String fileName) {
        InputStream inputStream = getImageinputFromNetByUrl(url);
        if (null != inputStream) {
            return writeImageToDisk(inputStream, fileName);
        } else {
            log.error("没有从该连接获得内容:" + url + "   (文件名:" + fileName + ")");
            return null;
        }
    }

    /**
     * 将图片写入到磁盘
     *
     * @param img      图片数据流
     * @param fileName 文件保存时的名称
     */
    public String writeImageToDisk(InputStream inputStream, String fileName) {
        FileOutputStream fops = null;
        try {
            //先创建一个文件夹
            String dirname = NameOfDate.getDir();
            File dirFile = new File(pathRoot + dirname);
            if (!dirFile.exists()) {
                dirFile.mkdirs();
            }
            //将文件名改为时间+原始文件名，防止重名
            String fileNameTmp = NameOfDate.getFileName() + "_" + fileName;
            File file = new File(pathRoot + dirname + "/" + fileNameTmp);
            while (file.exists() == true) {//这个文件如果存在，也就是重名的话
                //先延迟500ms，然后再生成一个名字
                Thread.sleep(500);
                fileNameTmp = NameOfDate.getFileName() + "_" + fileName;
                file = new File(pathRoot + dirname + "/" + fileNameTmp);
            }
            fops = new FileOutputStream(file);
            readInputStream(inputStream, fops);
            return dirname + "/" + fileNameTmp;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            IOUtils.closeQuietly(fops);
            IOUtils.closeQuietly(inputStream);
        }
    }

    /**
     * 根据地址获得数据的字节流
     *
     * @param strUrl 网络连接地址
     * @return
     */
    public static InputStream getImageinputFromNetByUrl(String strUrl) {
        try {
            URL url = new URL(strUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5 * 1000);
            InputStream inStream = conn.getInputStream();//通过输入流获取图片数据  
            return inStream;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    /**
     * 从输入流中获取数据
     *
     * @param inStream 输入流
     * @return
     * @throws Exception
     */
    public void readInputStream(InputStream inStream, FileOutputStream outStream) throws Exception {
        byte[] buffer = new byte[1024];
        int len = 0;
        while ((len = inStream.read(buffer, 0, 1024)) != -1) {
            outStream.write(buffer, 0, len);
        }
        outStream.close();
        inStream.close();
    }


    public static void main(String[] args) {
        String url = "http://www.baidu.com/img/baidu_sylogo1.gif";
        String fileName = "百度.gif";
        DownloadImg dli = new DownloadImg();
        dli.setPathRoot(Constans.PATH_ROOT);
        try {
            dli.readInputStream(getImageinputFromNetByUrl(url), new FileOutputStream(dli.pathRoot + NameOfDate.getDir() + "/" + fileName));
        } catch (FileNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        ;
    }
}  