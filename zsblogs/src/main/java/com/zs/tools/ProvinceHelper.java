package com.zs.tools;

import org.apache.log4j.Logger;

public class ProvinceHelper {

	
	
	private static final String pros1[]={"北京","天津","河北","山西","内蒙古","辽宁","吉林","黑龙江","上海","江苏","浙江","安徽","福建","江西","山东","河南",
					"湖北","湖南","广东","广西","海南","重庆","四川","贵州","云南","西藏","陕西","甘肃","青海","宁夏","新疆","香港","澳门","台湾"};
	
	private static final String pros2[]={"北京市","天津市","河北省","山西省","内蒙古自治区",
					"辽宁省","吉林省","黑龙江省",
					"上海市","江苏省","浙江省","安徽省","福建省","江西省","山东省",
					"河南省","湖北省","湖南省","广东省","广西壮族自治区","海南省",
					"重庆市","四川省","贵州省","云南省","西藏自治区",
					"陕西省","甘肃省","青海省","宁夏回族自治区","新疆维吾尔自治区",
					"香港特别行政区","澳门特别行政区","台湾省"};

	
	public static String getProvince(String address) {
		Logger log=Logger.getLogger(ProvinceHelper.class);
		for (int i = 0; i < pros1.length; i++) {
			if (address.indexOf(pros1[i])==0) {
				return pros2[i];
			}
		}
		log.error("【从哲盟返回的省份（目的地）提取省份失败】源数据为："+address);
		return null;
	}
	
	
}
