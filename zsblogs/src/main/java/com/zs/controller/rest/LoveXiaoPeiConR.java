package com.zs.controller.rest;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.zs.controller.rest.BaseRestController.Code;
import com.zs.entity.other.ListPlus;
import com.zs.entity.other.LoveXiaoPeiDataBean;
import com.zs.entity.other.Result;

@RestController
@RequestMapping("/api/loveXiaoPei")
public class LoveXiaoPeiConR {

	private String zs="zs";
	private String xp="xp";
	
	private LoveXiaoPeiDataBean bean;
	
	
	/**
	 * 初始化数据,剧情的设计就在这里
	 * 我先说下大致的剧本吧，有两个事件：生日、之前的信任危机
	 * 3个结局：10年后我问她帮我去接下孩子、（还没想好）
	 * @return
	 */
	@RequestMapping("/init")
	public LoveXiaoPeiDataBean initData(){
		bean=
		new LoveXiaoPeiDataBean(zs, "小佩，早！", new ListPlus().addPlus(
			new LoveXiaoPeiDataBean(xp, "张顺，早上好！", new ListPlus().addPlus(
				new LoveXiaoPeiDataBean(zs, "待会再聊吧",new ListPlus().addPlus(
					new LoveXiaoPeiDataBean(xp, "不，我就要现在就聊",new ListPlus().addPlus(
						new LoveXiaoPeiDataBean(zs, "好啊",10000, new ListPlus().addPlus(
							new LoveXiaoPeiDataBean(xp, "明天我就过来看你好不好")
						).addPlus(
							new LoveXiaoPeiDataBean(xp, "明天给你打电话")
						))
					)) 
				).addPlus(
					new LoveXiaoPeiDataBean(xp, "好的")
				))))
		).addPlus(
			new LoveXiaoPeiDataBean(xp, "再见"))
		);
		return bean;
	}
	
	//得到下一节点
	@RequestMapping("/next")
	public ListPlus getNextPoint(String id){
		return null;
	}
	
	//得到上一节点
	@RequestMapping("/last")
	public LoveXiaoPeiDataBean getLastPoint(String id){
		return null;
	}
	

}
