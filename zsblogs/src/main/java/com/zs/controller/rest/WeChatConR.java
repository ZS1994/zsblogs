package com.zs.controller.rest;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.zs.entity.other.WeChatAccept;
import com.zs.tools.Constans;
import com.zs.tools.Trans;
import com.zs.tools.mail.MailManager;
import com.zs.tools.mail.MailModel;

@RestController
@RequestMapping("/api/weChat")
public class WeChatConR {

	private Logger log=Logger.getLogger(getClass());
	private MailManager mail=MailManager.getInstance();
	
	private final String TOKEN = "123456";
	/**
	 * 验证验证是否来来自微信服务器
	 * @return
	 */
	@RequestMapping("/token")
	public String checkToken(WeChatAccept accept, HttpServletRequest req, HttpServletResponse resp){
		try {
			ArrayList<String> alTmp = new ArrayList<>();
			alTmp.add(TOKEN);
			alTmp.add(accept.getTimestamp());
			alTmp.add(accept.getNonce());
			Collections.sort(alTmp, new Comparator<String>() {
	            @Override
	            public int compare(String o1, String o2) {
	                try {
	                    String str1 = new String(o1.toString().getBytes("GB2312"),"ISO-8859-1");
	                    String str2 = new String(o2.toString().getBytes("GB2312"),"ISO-8859-1");
	                    return str1.compareTo(str2);
	                } catch (UnsupportedEncodingException e) {
	                    e.printStackTrace();
	                }
	                return 0;
	            }
	        });
			StringBuffer sbTmp = new StringBuffer();
			for (String s : alTmp) {
				sbTmp.append(s);
			}
			//sha1加密
			String strTmp = Constans.getSha1(sbTmp.toString());
			if (strTmp.equals(accept.getSignature())) {
				return accept.getEchostr();
			}
		} catch (Exception e) {
			e.printStackTrace();
			mail.addMail(new MailModel(Trans.strToHtml(e,req), MailManager.TITLE));
		}
		return "check token fail";
	}  
	
	
	
	
	
}
