package com.zs.entity.other;

import java.util.List;

public class FundProfit {

	private String fundName;//名称
	private List<String> xTime;//x轴，时间
	private List<Double> yRate1;
	private List<Double> yRate2;
	private List<TimeValueBean> marks;//标记
	
	
	public List<TimeValueBean> getMarks() {
		return marks;
	}
	public void setMarks(List<TimeValueBean> marks) {
		this.marks = marks;
	}
	public String getFundName() {
		return fundName;
	}
	public void setFundName(String fundName) {
		this.fundName = fundName;
	}
	public List<String> getxTime() {
		return xTime;
	}
	public void setxTime(List<String> xTime) {
		this.xTime = xTime;
	}
	public List<Double> getyRate1() {
		return yRate1;
	}
	public void setyRate1(List<Double> yRate1) {
		this.yRate1 = yRate1;
	}
	public List<Double> getyRate2() {
		return yRate2;
	}
	public void setyRate2(List<Double> yRate2) {
		this.yRate2 = yRate2;
	}
	public FundProfit(String fundName, List<String> xTime, List<Double> yRate1, List<Double> yRate2) {
		super();
		this.fundName = fundName;
		this.xTime = xTime;
		this.yRate1 = yRate1;
		this.yRate2 = yRate2;
	}
	public FundProfit() {
		super();
	}
	
}
