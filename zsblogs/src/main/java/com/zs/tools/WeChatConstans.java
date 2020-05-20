package com.zs.tools;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.activation.MimetypesFileTypeMap;
import javax.annotation.Resource;

import org.apache.ibatis.annotations.Param;
import org.apache.log4j.Logger;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestTemplate;

import com.alibaba.fastjson.JSONObject;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.zs.dao.ParamsMapper;
import com.zs.entity.Params;
import com.zs.entity.other.WeChatAddNews;

/**
 * 微信的工具集
 * @author 张顺
 *
 */
@Component("weChatConstans")
public class WeChatConstans {

	
	private Gson gson = new Gson();
	private static final String PID = "weChat_token";
	private static final String WECHAT = "weChat";
	private Logger log = Logger.getLogger(getClass());

	private RestTemplate restTemplate = new RestTemplate();
	{
		restTemplate.getMessageConverters().set(1, new StringHttpMessageConverter(StandardCharsets.UTF_8));
	}
	
	@Resource
	private ParamsMapper paramsMapper;
	
	
	/**微信上传图片
	 * @throws Exception */
	public String uploadimg(String imgPath) throws Exception{
		String urlStr = "https://api.weixin.qq.com/cgi-bin/media/uploadimg?access_token="+getToken(); 
		File file = new File(imgPath);
		
		String res = "";
		HttpURLConnection conn = null;
		String BOUNDARY = "---------------------------123821742118716"; // boundary就是request头和上传文件内容的分隔符
		try {
			URL url = new URL(urlStr);
			conn = (HttpURLConnection) url.openConnection();
			conn.setConnectTimeout(5000);
			conn.setReadTimeout(30000);
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setUseCaches(false);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Connection", "Keep-Alive");
			conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.6)");
			conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + BOUNDARY);
			OutputStream out = new DataOutputStream(conn.getOutputStream());
	
			// file
			String inputName = "";
			String filename = file.getName();
			String contentType = new MimetypesFileTypeMap().getContentType(file);
			if (filename.endsWith(".png")) {
				contentType = "image/png";
			}
			if (contentType == null || contentType.equals("")) {
				contentType = "application/octet-stream";
			}
		
			StringBuffer strBuf = new StringBuffer();
			strBuf.append("\r\n").append("--").append(BOUNDARY).append("\r\n");
			strBuf.append("Content-Disposition: form-data; name=\"" + inputName + "\"; filename=\"" + filename + "\"\r\n");
			strBuf.append("Content-Type:" + contentType + "\r\n\r\n");
			out.write(strBuf.toString().getBytes());
			DataInputStream in = new DataInputStream(new FileInputStream(file));
			int bytes = 0;
			byte[] bufferOut = new byte[1024];
			while ((bytes = in.read(bufferOut)) != -1) {
				out.write(bufferOut, 0, bytes);
			}
			in.close();
			byte[] endData = ("\r\n--" + BOUNDARY + "--\r\n").getBytes();
			out.write(endData);
			out.flush();
			out.close();
	
			// 读取返回数据
			StringBuffer strBuf2 = new StringBuffer();
			BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line = null;
			while ((line = reader.readLine()) != null) {
				strBuf2.append(line).append("\n");
			}
			res = strBuf2.toString();
			reader.close();
			reader = null;
		} catch (Exception e) {
			throw e;
		} finally {
			if (conn != null) {
				conn.disconnect();
				conn = null;
			}
		}
		log.info(res);
		return res;
	}
	
	/**新增永久资源*/
	public String addMaterial(String type, String imgPath){
		String urlStr = "https://api.weixin.qq.com/cgi-bin/material/add_material?access_token="+getToken()+"&type="+type; 
		//设置请求体，注意是LinkedMultiValueMap
        MultiValueMap<String, Object> data = new LinkedMultiValueMap();

        //设置上传文件
        FileSystemResource fileSystemResource = new FileSystemResource(imgPath);
        data.add("media", fileSystemResource);

        //上传文件,设置请求头
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.setContentType(MediaType.MULTIPART_FORM_DATA);
        httpHeaders.setContentLength(fileSystemResource.getFile().length());

        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<MultiValueMap<String, Object>>(data,
                httpHeaders);
        try{
            //这里RestTemplate请求返回的字符串直接转换成JSONObject会报异常,后续深入找一下原因
//            ResponseEntity<JSONObject> resultEntity = restTemplate.exchange(url,
//                    HttpMethod.POST, requestEntity, JSONObject.class);
            String resultJSON = restTemplate.postForObject(urlStr, requestEntity, String.class);
            log.info(resultJSON);
            return resultJSON;
        }catch (Exception e){
        	throw e;
        }
	}
	
	/**微信增加永久资源
	 * @throws Exception */
	public String addNews(WeChatAddNews news) throws Exception{
		Map<String, List> mtmp = new HashMap();
		List<WeChatAddNews> arrtmp = new ArrayList();
		arrtmp.add(news);
		mtmp.put("articles", arrtmp);
		String res = restTemplate.postForObject(
				"https://api.weixin.qq.com/cgi-bin/material/add_news?access_token="+getToken(), 
				gson.toJson(mtmp), 
				String.class);
		log.info(res);
		return res;
	}
	
	
	/**刷新token*/
	public void refreshToken() throws Exception{
		String result = HttpClientReq.httpGet("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wx1a36f8bdfd1016d2&secret=6648cbc3342bc4478b1ede940b647664", null, null);
		System.out.println("----------------更新公众号token--------------------------");
		System.out.println(result);
		
		Map<String, Object> mapres = gson.fromJson(result, Map.class);
		
		String accessToken = (String)mapres.get("access_token");
		String expiresIn = String.valueOf(mapres.get("expires_in"));
		
		Params p = new Params();
		if (!StringUtils.isEmpty(accessToken) && !StringUtils.isEmpty(expiresIn)) {
			//先删再存
			paramsMapper.deleteByPk(PID, WECHAT);
			p.setpId(PID);
			p.setGroup(WECHAT);
			p.setpName("公众号的token");
			p.setpValue(accessToken);
			//存有效时间
			p.setpV1(expiresIn);
			p.setCreateTime(new Date());
			//暂时就存我，因为这个字段目前没有什么用处
			p.setCreateUser(1);
			paramsMapper.insertSelective(p);
		}
	}
	
	/**
	 * 获取当前的微信公众号token
	 */
	public String getToken(){
		Params p = paramsMapper.selectByPk(PID, WECHAT);
		if (p != null) {
			return paramsMapper.selectByPk(PID, WECHAT).getpValue();
		}
		return null;
	}
	
	
	/**
	 * 获取素材列表
	 * @return
	 */
	public String batchgetMaterial(String type, Integer offset, Integer count){
	    String accessToken = getToken();
	    if(accessToken != null){
	        String url = "https://api.weixin.qq.com/cgi-bin/material/batchget_material?access_token=" + accessToken;

	        JSONObject jsonObject = new JSONObject();
	        //素材的类型，图片（image）、视频（video）、语音 （voice）、图文（news）
	        jsonObject.put("type", type);
	        //从全部素材的该偏移位置开始返回，0表示从第一个素材 返回
	        jsonObject.put("offset", offset);
	        //返回素材的数量，取值在1到20之间
	        jsonObject.put("count", count);

	        //发起POST请求
	        String resultString = restTemplate.postForObject(url, jsonObject.toJSONString(),String.class);
	        return resultString;
	    }
	    return null;
	}
	
	/**
	 * 获取永久素材的总数
	 * @return
	 */
	public String getMaterialcount(){
		String accessToken = getToken();
	    if(accessToken != null){
	        String url = "https://api.weixin.qq.com/cgi-bin/material/get_materialcount?access_token=" + accessToken;
	        //发起GET请求
	        String resultString = restTemplate.getForObject(url, String.class);
	        return resultString;
	    }
	    return null;
	}
	
	
	/**
	 * 删除永久素材
	 * @return
	 */
	public String delMaterial(String mid){
		String url = "https://api.weixin.qq.com/cgi-bin/material/del_material?access_token=" + getToken();
		JSONObject jsonObject = new JSONObject();
        //获取素材列表来获知素材的media_id
        jsonObject.put("media_id", mid);
		String res = restTemplate.postForObject(url, jsonObject.toString(), String.class);
		log.info(res);
        return res;
	}
	
	
	
}
