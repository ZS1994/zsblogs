package com.zs.tools;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;

import com.google.gson.Gson;
import com.zs.controller.rest.BaseRestController;
import com.zs.entity.other.Result;

public class HttpClientReq {

	private static Logger log = Logger.getLogger(HttpClientReq.class);
	private static Gson gson=new Gson();
	/**  
	 * @author John丶辉
     * 发送http get请求  
     */    
    public static String httpGet(String url,String uid,String data) throws Exception{    
    	String encode = "utf-8";    
    	String content = null;  
        CloseableHttpClient closeableHttpClient = HttpClientBuilder.create().build();     
        String udata = URLEncoder.encode(data,encode);
        log.warn(udata);
        HttpGet httpGet = new HttpGet(url+"?uid="+uid+"&data="+udata);
        CloseableHttpResponse response = null;    
        try {    
        	response = closeableHttpClient.execute(httpGet);    
            HttpEntity entity = response.getEntity();    
            content = EntityUtils.toString(entity, encode);    
        } catch (Exception e) {    
            e.printStackTrace();    
        }finally{    
            try {    
            	response.close();    
            } catch (IOException e) {    
                e.printStackTrace();    
            }    
        }    
        try {  //关闭连接、释放资源    
            closeableHttpClient.close();    
        } catch (IOException e) {    
            e.printStackTrace();    
        }   
        Result<String> er=new Result<String>(BaseRestController.ERROR, BaseRestController.Code.ERROR, "该值是httpGet默认返回值，如果收到这个，说明该方法运行失败。");
        if(content==null){
        	content=gson.toJson(er);
        }
        return content;    
    }    
	
	/**
	 * @author John丶辉
	 * @param url
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public static String httpPost(String url,String uid,String data) throws Exception {
		String encode = "utf-8"; 
		String content = null;  
		// 创建默认的httpClient实例.    
        CloseableHttpClient httpclient = HttpClients.createDefault();  
        // 创建httppost    
        HttpPost httppost = new HttpPost(url);  
        // 创建参数队列    
        List<NameValuePair> formparams = new ArrayList<NameValuePair>();  
        formparams.add(new BasicNameValuePair("uid", uid));
        formparams.add(new BasicNameValuePair("data", data));
        UrlEncodedFormEntity uefEntity;  
        try {  
            uefEntity = new UrlEncodedFormEntity(formparams, encode);  
            httppost.setEntity(uefEntity);  
            CloseableHttpResponse response = httpclient.execute(httppost);  
            try {  
                HttpEntity entity = response.getEntity();  
                if (entity != null) { 
                	content=EntityUtils.toString(entity, encode);
                }
            } finally {
                response.close();
            }  
        } catch (Exception e) {  
        	e.printStackTrace();
        } finally {  
            // 关闭连接,释放资源    
            try {  
                httpclient.close();  
            } catch (IOException e) {  
                e.printStackTrace();  
            }  
        } 
        Result<String> er=new Result<String>(BaseRestController.ERROR, BaseRestController.Code.ERROR, "该值是httpGet默认返回值，如果收到这个，说明该方法运行失败。");
        if(content==null){
        	content=gson.toJson(er);
        }
        return content;
    }
	
	/**  
	 * @author John丶辉
     * 发送http delete请求  
     */    
    public static String httpDelete(String url,String uid,String data) throws Exception{    
        String encode = "utf-8";    
        String content = null;   
        //since 4.3 不再使用 DefaultHttpClient    
        CloseableHttpClient closeableHttpClient = HttpClientBuilder.create().build();     
        String udata = URLEncoder.encode(data,encode);
        HttpDelete httpdelete = new HttpDelete(url+"?uid="+uid+"&data="+udata);    
        CloseableHttpResponse response = null;    
        try {    
        	response = closeableHttpClient.execute(httpdelete);    
            HttpEntity entity = response.getEntity();    
            content = EntityUtils.toString(entity, encode);    
        } catch (Exception e) {    
            e.printStackTrace();    
        }finally{    
            try {    
            	response.close();    
            } catch (IOException e) {    
                e.printStackTrace();    
            }    
        }    
        try {   //关闭连接、释放资源    
            closeableHttpClient.close();    
        } catch (IOException e) {
            e.printStackTrace();
        } 
        Result<String> er=new Result<String>(BaseRestController.ERROR, BaseRestController.Code.ERROR, "该值是httpGet默认返回值，如果收到这个，说明该方法运行失败。");
        if(content==null){
        	content=gson.toJson(er);
        }
        return content;    
    }    

    /**
     * @author John丶辉
     * @param url
     * @param params
     * @return
     * @throws Exception
     */
    public static String httpPut(String url,String uid,String data) throws Exception {
		String encode = "utf-8";
		String content = null; 
		// 创建默认的httpClient实例.    
        CloseableHttpClient httpclient = HttpClients.createDefault();  
        // 创建httpput    
        String udata = URLEncoder.encode(data,encode);
        HttpPut httpput = new HttpPut(url+"?uid="+uid+"&data="+udata);  
        try {  
            CloseableHttpResponse response = httpclient.execute(httpput);  
            try {  
                HttpEntity entity = response.getEntity();  
                if (entity != null) { 
                	content=EntityUtils.toString(entity,encode);
                }
            } finally {
                response.close();
            }  
        } catch (Exception e) {  
        	e.printStackTrace();
        } finally {  
            // 关闭连接,释放资源    
            try {  
                httpclient.close();  
            } catch (IOException e) {  
                e.printStackTrace();  
            }  
        }  
        Result<String> er=new Result<String>(BaseRestController.ERROR, BaseRestController.Code.ERROR, "该值是httpGet默认返回值，如果收到这个，说明该方法运行失败。");
        if(content==null){
        	content=gson.toJson(er);
        }
        return content;
    }
    
    
}
