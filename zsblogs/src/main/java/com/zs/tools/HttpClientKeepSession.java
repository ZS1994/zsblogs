package com.zs.tools;

import java.io.IOException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.List;
import org.apache.http.HeaderIterator;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.ParseException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.CookieStore;
import org.apache.http.client.HttpClient;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.protocol.HttpClientContext;
import org.apache.http.conn.ssl.NoopHostnameVerifier;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.SSLContextBuilder;
import org.apache.http.conn.ssl.TrustStrategy;
import org.apache.http.cookie.Cookie;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.DefaultConnectionKeepAliveStrategy;
import org.apache.http.impl.client.DefaultRedirectStrategy;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.impl.cookie.BasicClientCookie;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.apache.http.config.Registry;
import org.apache.http.config.RegistryBuilder;
import org.apache.http.conn.socket.ConnectionSocketFactory;
import org.apache.http.conn.socket.PlainConnectionSocketFactory;
/**
 * 保持同一session的HttpClient工具类
 * @author zhangwenchao
 *
 */
public class HttpClientKeepSession {

		private static final Logger LOG = LogManager.getLogger(HttpClient.class);
		public  static CloseableHttpClient httpClient = null;
		public  static HttpClientContext context = null;
		public  static CookieStore cookieStore = null;
		public  static RequestConfig requestConfig = null;

		private static final String HTTP = "http";
	    private static final String HTTPS = "https";
	    private static SSLConnectionSocketFactory sslsf = null;
	    private static PoolingHttpClientConnectionManager cm = null;
	    private static SSLContextBuilder builder = null;
		
		
		static {
			init();
		}

		private static void init() {
			try {
	            builder = new SSLContextBuilder();
	            // 全部信任 不做身份鉴定
	            builder.loadTrustMaterial(null, new TrustStrategy() {
	                @Override
	                public boolean isTrusted(X509Certificate[] x509Certificates, String s) throws CertificateException {
	                    return true;
	                }
	            });
	            sslsf = new SSLConnectionSocketFactory(builder.build(), new String[]{"SSLv2Hello", "SSLv3", "TLSv1", "TLSv1.2"}, null, NoopHostnameVerifier.INSTANCE);
	            Registry<ConnectionSocketFactory> registry = RegistryBuilder.<ConnectionSocketFactory>create()
	                    .register(HTTP, new PlainConnectionSocketFactory())
	                    .register(HTTPS, sslsf)
	                    .build();
	            cm = new PoolingHttpClientConnectionManager(registry);
	            cm.setMaxTotal(200);//max connection
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
			
			context = HttpClientContext.create();
			cookieStore = new BasicCookieStore();
			// 配置超时时间（连接服务端超时1秒，请求数据返回超时2秒）
			requestConfig = RequestConfig.custom().setConnectTimeout(120000).setSocketTimeout(60000)
					       .setConnectionRequestTimeout(60000).build();
			// 设置默认跳转以及存储cookie
			httpClient = HttpClientBuilder.create()
					     .setKeepAliveStrategy(new DefaultConnectionKeepAliveStrategy())
					     .setRedirectStrategy(new DefaultRedirectStrategy()).setDefaultRequestConfig(requestConfig)
					     .setDefaultCookieStore(cookieStore)
					     .setSSLSocketFactory(sslsf)
					     .setConnectionManager(cm)
					     .setConnectionManagerShared(true)
					     .build();
		}

		/**
		 * http get
		 * 
		 * @param url
		 * @return response
		 * @throws ClientProtocolException
		 * @throws IOException
		 */
		public static CloseableHttpResponse get(String url) throws ClientProtocolException, IOException {
			HttpGet httpget = new HttpGet(url);
			CloseableHttpResponse response = httpClient.execute(httpget, context);
			try {
				cookieStore = context.getCookieStore();
				List<Cookie> cookies = cookieStore.getCookies();
				for (Cookie cookie : cookies) {
					LOG.debug("key:" + cookie.getName() + "  value:" + cookie.getValue());
				}
			} finally {
				response.close();
			}
			return response;
		}

		/**
		 * http post
		 * 
		 * @param url
		 * @param parameters
		 *            form表单
		 * @return String
		 * @throws ClientProtocolException
		 * @throws IOException
		 */
		public static String post(String url, String parameters)
				throws ClientProtocolException, IOException {
			String content=null;
			HttpPost httpPost = new HttpPost(url);
			httpPost.setHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko");
			httpPost.setHeader("Host", "kyfw.12306.cn");
			httpPost.setHeader("Referer", "https://kyfw.12306.cn/otn/passport?redirect=/otn/");
			List<NameValuePair> nvps = toNameValuePairList(parameters);
			if (nvps!=null) {
				httpPost.setEntity(new UrlEncodedFormEntity(nvps, "UTF-8"));
			}
			CloseableHttpResponse response = httpClient.execute(httpPost, context);
			
			try {
				cookieStore = context.getCookieStore();
				List<Cookie> cookies = cookieStore.getCookies();
				for (Cookie cookie : cookies) {
					LOG.debug("key:" + cookie.getName() + "  value:" + cookie.getValue());
				}
			} finally {
//				printResponse(response);
				HttpEntity entity = response.getEntity();  
                if (entity != null) { 
                	content=EntityUtils.toString(entity);
                }
				printCookies();
				response.close();
			}
			return content;
			
		}
		
		@SuppressWarnings("unused")
		private static List<NameValuePair> toNameValuePairList(String parameters) {
			if (parameters==null) {
				return null;
			}
			List<NameValuePair> nvps = new ArrayList<NameValuePair>();
			String[] paramList = parameters.split("&");
			for (String parm : paramList) {
				int index = -1;
				for (int i = 0; i < parm.length(); i++) {
					index = parm.indexOf("=");
					break;
				}
				String key = parm.substring(0, index);
				String value = parm.substring(++index, parm.length());
				nvps.add(new BasicNameValuePair(key, value));
			}
			System.out.println(nvps.toString());
			return nvps;
		}

		/**
		 * 手动增加cookie
		 * @param name
		 * @param value
		 * @param domain
		 * @param path
		 */
		public static void addCookie(String name, String value, String domain, String path) {
			BasicClientCookie cookie = new BasicClientCookie(name, value);
			cookie.setDomain(domain);
			cookie.setPath(path);
			cookieStore.addCookie(cookie);
		}

		/**
		 * 把结果console出来
		 * 
		 * @param httpResponse
		 * @throws ParseException
		 * @throws IOException
		 */
		public static void printResponse(HttpResponse httpResponse) throws ParseException, IOException {
			// 获取响应消息实体
			HttpEntity entity = httpResponse.getEntity();
			// 响应状态
			System.out.println("status:" + httpResponse.getStatusLine());
			System.out.println("respones-headers:");
			HeaderIterator iterator = httpResponse.headerIterator();
			while (iterator.hasNext()) {
				System.out.println("\t" + iterator.next());
			}
			// 判断响应实体是否为空
			if (entity != null) {
				String responseString = EntityUtils.toString(entity);
				System.out.println("response length:" + responseString.length());
				System.out.println("response content:" + responseString.replace("\r\n", ""));
				EntityUtils.consume(entity);
			}
			System.out.println("------------------------------------------------------------------------------------------\r\n");
		}

		/**
		 * 把当前cookie从控制台输出出来
		 * 
		 */
		public static void printCookies() {
			System.out.println("cookies-headers:");
			cookieStore = context.getCookieStore();
			List<Cookie> cookies = cookieStore.getCookies();
			for (Cookie cookie : cookies) {
				System.out.println("key:" + cookie.getName() + "  value:" + cookie.getValue());
			}
		}

		/**
		 * 检查cookie的键值是否包含传参
		 * 
		 * @param key
		 * @return
		 */
		public static boolean checkCookie(String key) {
			cookieStore = context.getCookieStore();
			List<Cookie> cookies = cookieStore.getCookies();
			boolean res = false;
			for (Cookie cookie : cookies) {
				if (cookie.getName().equals(key)) {
					res = true;
					break;
				}
			}
			return res;
		}

		/**
		 * 直接把Response内的Entity内容转换成String
		 * 
		 * @param httpResponse
		 * @return
		 * @throws ParseException
		 * @throws IOException
		 */
		public static String toString(CloseableHttpResponse httpResponse) throws ParseException, IOException {
			// 获取响应消息实体
			HttpEntity entity = httpResponse.getEntity();
			if (entity != null)
				return EntityUtils.toString(entity);
			else
				return null;
		}
		
		
		
		public static void main(String[] args) throws ClientProtocolException, IOException {
			
			//用户登陆
			String content = HttpClientKeepSession.post("https://kyfw.12306.cn//passport/captcha/captcha-image?login_site=E&module=login&rand=sjrand&0.8987567214019803",null);
			System.out.println(content);
			
		}
		//tk=cbSCy_pZmpyH2VqfibTvvB2exTKqYfo-Xcyi9Zar3o1LHuAuhuz1z0
		
		
		
}
