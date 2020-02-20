package com.zs.quartz;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.util.StringUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.zs.tools.CrawlerNo1;
import com.zs.tools.SpringUtil;
import com.zs.tools.WeChatConstans;


/**
 * 2020-1-30
 * @author 张顺
 * 删除所有的素材，一次删一个
 * 
 */
public class WeChatDelAllNewsJob implements Job{

	private WeChatConstans weChatConstans;
	
	
	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		
		if (weChatConstans == null) {
			weChatConstans = (WeChatConstans) SpringUtil.getBean("weChatConstans");
		}
		try {
			String res = weChatConstans.batchgetMaterial("news", 0, 20);
			if (!StringUtils.isEmpty(res)) {
				JSONArray jarr = new JSONObject().parseObject(res).getJSONArray("item");
				if (jarr != null) {
					for (int i = 0; i < jarr.size(); i++) {
						String mid = jarr.getJSONObject(i).getString("media_id");
						if (!StringUtils.isEmpty(mid)) {
							weChatConstans.delMaterial(mid);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		};
	}

	
	
	

}
