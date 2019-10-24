package com.zs.tools;

import org.springframework.util.StopWatch;

/**
 * 用于分析代码执行耗时分析的工具封装，封装了spring的
 * 2019-10-24
 * @author 张顺
 */
public class StopWatchUtil extends StopWatch{

	//是否开启，0：不开启，1：开启
	private static int status = 1;
	
	
	
	@Override
	public void start() throws IllegalStateException {
		if (status == 1) {
			super.start();
		}
	}
	
	@Override
	public void start(String name) throws IllegalStateException {
		if (status == 1) {
			super.start(name);
		}
	}
	
	@Override
	public void stop(){
		if (status == 1) {
			super.stop();
		}
	}
	
	@Override
	public String prettyPrint() {
		if (status == 1) {
			String result = super.prettyPrint();
			return result;
		}
		return null;
	}

	public static int getStatus() {
		return status;
	}

	public static void setStatus(int status) {
		StopWatchUtil.status = status;
	}
	
}
