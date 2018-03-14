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
	private String xt="xt";
	
	
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
		new LoveXiaoPeiDataBean(xt, "-------2016-10-12-------",1500, new ListPlus().addPlus(
			new LoveXiaoPeiDataBean(zs, "在干嘛呀",5000, new ListPlus().addPlus(
				new LoveXiaoPeiDataBean(zs, "我刚吃完饭，准备出去走走了，你呢",new ListPlus().addPlus(
					new LoveXiaoPeiDataBean(xp, "我也刚吃完饭，在和闺蜜一起看电视呢",new ListPlus().addPlus(
						new LoveXiaoPeiDataBean(zs, "哦", new ListPlus().addPlus(
							new LoveXiaoPeiDataBean(zs, "那不打扰你看电视啦",new ListPlus().addPlus(
								new LoveXiaoPeiDataBean(xp, "没事，不打扰呀，我想和你说说话",new ListPlus().addPlus(
									new LoveXiaoPeiDataBean(zs, "<img src=\"http://img.t.sinajs.cn/t4/appstyle/expression/ext/normal/0b/tootha_org.gif\" alt=\"[嘻嘻]\" data-w-e=\"1\">",new ListPlus().addPlus(
										new LoveXiaoPeiDataBean(xt, "-------2018-5-17-------",1500, new ListPlus().addPlus(
											new LoveXiaoPeiDataBean(zs, "明天周末了，你休息吗",new ListPlus().addPlus(
												new LoveXiaoPeiDataBean(xp, "不休息，要加班，你呢",new ListPlus().addPlus(
													new LoveXiaoPeiDataBean(zs, "我休息",new ListPlus().addPlus(
														new LoveXiaoPeiDataBean(zs, "明天晚上来我这里吧，给你做好吃的",new ListPlus().addPlus(
															new LoveXiaoPeiDataBean(xp, "我可能很晚才能下班，不用了",new ListPlus().addPlus(
																new LoveXiaoPeiDataBean(zs, "没事，我等你",new ListPlus().addPlus(
																	new LoveXiaoPeiDataBean(xp, "<img src=\"http://img.t.sinajs.cn/t4/appstyle/expression/ext/normal/6e/shamea_org.gif\" alt=\"[害羞]\" data-w-e=\"1\">",new ListPlus().addPlus(
																		new LoveXiaoPeiDataBean(xt, "-------2020-1-1-------",1500,new ListPlus().addPlus(
																			new LoveXiaoPeiDataBean(zs, "明天你去接孩子吧，公司里有点事", new ListPlus().addPlus(
																				new LoveXiaoPeiDataBean(xp, "嗯，放心吧",new ListPlus().addPlus(
																					new LoveXiaoPeiDataBean(zs, "爱你，小佩",new ListPlus().addPlus(
																						new LoveXiaoPeiDataBean(xt, "-------小佩，恭喜你达成了[完美结局·1]-------",0,null)
																					))
																				))
																			))
																		))
																	))
																))
															))
														).addPlus(
															new LoveXiaoPeiDataBean(xp, "好啊",new ListPlus().addPlus(
																new LoveXiaoPeiDataBean(xt, "-------2020-2-1-------",1500,new ListPlus().addPlus(
																	new LoveXiaoPeiDataBean(zs, "在家在干什么呢", new ListPlus().addPlus(
																		new LoveXiaoPeiDataBean(xp, "我在哥这玩呢",new ListPlus().addPlus(
																			new LoveXiaoPeiDataBean(zs, "我明天就出发了",new ListPlus().addPlus(
																				new LoveXiaoPeiDataBean(xp, "嗯，你记得把我那件红色的衣服带上哦",new ListPlus().addPlus(
																					new LoveXiaoPeiDataBean(zs, "嗯，记着呢",new ListPlus().addPlus(
																						new LoveXiaoPeiDataBean(xt, "-------小佩，恭喜你达成了[完美结局·2]-------",0,null)
																					))
																				))
																			))
																		))
																	))
																))
															))
														))
													))
												))	
											))
										))	
									))
								))
							).addPlus(
								new LoveXiaoPeiDataBean(xp, "嗯嗯，下次再聊",new ListPlus().addPlus(
									new LoveXiaoPeiDataBean(zs, "嗯",new ListPlus().addPlus(
										new LoveXiaoPeiDataBean(xt, "-------2018-5-17-------",1500,new ListPlus().addPlus(
											new LoveXiaoPeiDataBean(zs, "在干嘛呢",new ListPlus().addPlus(
												new LoveXiaoPeiDataBean(xp, "在家里，你呢",new ListPlus().addPlus(
													new LoveXiaoPeiDataBean(zs, "我在散步",new ListPlus().addPlus(
														new LoveXiaoPeiDataBean(xp, "你一个人吗",new ListPlus().addPlus(
															new LoveXiaoPeiDataBean(zs, "是的",new ListPlus().addPlus(
																new LoveXiaoPeiDataBean(xp, "一个人多无聊呀，可以喊朋友一起嘛",new ListPlus().addPlus(
																	new LoveXiaoPeiDataBean(zs, "还好吧，习惯了", new ListPlus().addPlus(
																		new LoveXiaoPeiDataBean(xp, "你那里朋友很少吗",new ListPlus().addPlus(
																			new LoveXiaoPeiDataBean(zs, "不是很多",new ListPlus().addPlus(
																				new LoveXiaoPeiDataBean(xt, "-------2020-1-1-------",1500,new ListPlus().addPlus(
																					new LoveXiaoPeiDataBean(zs, "hi",new ListPlus().addPlus(
																						new LoveXiaoPeiDataBean(xp, "嗨，好久没有联系了",new ListPlus().addPlus(
																							new LoveXiaoPeiDataBean(zs, "是啊，最近在干嘛呀",new ListPlus().addPlus(
																								new LoveXiaoPeiDataBean(xp, "还是老样子呀，上班日常，你呢，在陪女朋友吧",new ListPlus().addPlus(
																									new LoveXiaoPeiDataBean(zs, "没有女朋友，你呢",6000,new ListPlus().addPlus(
																										new LoveXiaoPeiDataBean(xp, "我也是单身",new ListPlus().addPlus(
																											new LoveXiaoPeiDataBean(zs, "其实我一直都喜欢你",10000,new ListPlus().addPlus(
																												new LoveXiaoPeiDataBean(zs, "你还在原来的城市吗", new ListPlus().addPlus(
																													new LoveXiaoPeiDataBean(xp, "我也喜欢你", new ListPlus().addPlus(
																														new LoveXiaoPeiDataBean(xt, "-------小佩，恭喜你达成了[希望结局]-------",0,null)
																													))	
																												).addPlus(
																													new LoveXiaoPeiDataBean(xp, "你会来找我吗", new ListPlus().addPlus(
																														new LoveXiaoPeiDataBean(zs, "会的",new ListPlus().addPlus(
																															new LoveXiaoPeiDataBean(xt, "-------小佩，恭喜你达成了[希望结局]-------",0,null)
																														))
																													))
																												))
																											))
																										))		
																									).addPlus(
																										new LoveXiaoPeiDataBean(xp, "嗯，我遇到了一个对的人，他对我很好", new ListPlus().addPlus(
																											new LoveXiaoPeiDataBean(zs, "哈哈，那恭喜你了", new ListPlus().addPlus(
																												new LoveXiaoPeiDataBean(xp, "谢谢",new ListPlus().addPlus(
																													new LoveXiaoPeiDataBean(zs, "不用谢，希望你幸福",10000,new ListPlus().addPlus(
																														new LoveXiaoPeiDataBean(xt, "-------小佩，恭喜你达成了[遗憾结局]-------",0,null)
																													))
																												))	
																											))	
																										))	
																									))
																								))
																							))	
																						))	
																					))
																				))
																			))	
																		))
																	).addPlus(
																		new LoveXiaoPeiDataBean(xp, "如果可以的话我可以陪你一起", new ListPlus().addPlus(
																			new LoveXiaoPeiDataBean(zs, "&nbsp;&nbsp;&nbsp;&nbsp;", 6000,new ListPlus().addPlus(
																				new LoveXiaoPeiDataBean(zs, "我也愿意陪你",10000,new ListPlus().addPlus(
																					new LoveXiaoPeiDataBean(xt, "-------2038-5-1-------",1500,new ListPlus().addPlus(
																						new LoveXiaoPeiDataBean(zs, "你知道吗，我们女儿可能谈恋爱了", new ListPlus().addPlus(
																							new LoveXiaoPeiDataBean(xp, "真的吗，怪不得小丫头天天往外跑",new ListPlus().addPlus(
																								new LoveXiaoPeiDataBean(zs, "我也是有一次偶然在外面看到的，小男孩看起来很温柔",new ListPlus().addPlus(
																									new LoveXiaoPeiDataBean(xp, "哈哈，真期待能看一下这个小男孩",new ListPlus().addPlus(
																										new LoveXiaoPeiDataBean(xt, "-------小佩，恭喜你达成了[完美结局·3]-------",0,null)
																									))
																								))
																							))
																						))
																					))
																				))
																			))
																		))
																	))
																))
															))
														))
													))
												))
											).addPlus(
												new LoveXiaoPeiDataBean(xp, "没干嘛呢", new ListPlus().addPlus(
													new LoveXiaoPeiDataBean(zs, "&nbsp;&nbsp;&nbsp;&nbsp;", new ListPlus().addPlus(
														new LoveXiaoPeiDataBean(xp, "......", new ListPlus().addPlus(
															new LoveXiaoPeiDataBean(xt, "-------小佩，恭喜你达成了[和平结局]-------",0,null)	
														))
													))
												))
											))
										))
									))
								))
							))
						))
					))
				))
			))
		));
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
