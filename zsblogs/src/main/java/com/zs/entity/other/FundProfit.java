package com.zs.entity.other;

import java.util.List;

public class FundProfit {

	private String fundName;//名称
	private List<String> xTime;//x轴，时间
	private List<Double> yRate1;//涨幅
	private List<Double> yRate2;//收益率
	private List<TimeValueBean> marks;//标记
	private List<Double> yRate3;//收益率同比
	private List<Double> yRateJs;//假定的收益率，即指数收益率
	
	
	public List<Double> getyRateJs() {
		return yRateJs;
	}
	public void setyRateJs(List<Double> yRateJs) {
		this.yRateJs = yRateJs;
	}
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
	public List<Double> getyRate3() {
		return yRate3;
	}
	public void setyRate3(List<Double> yRate3) {
		this.yRate3 = yRate3;
	}
	public FundProfit(String fundName, List<String> xTime, List<Double> yRate1, List<Double> yRate2) {
		super();
		this.fundName = fundName;
		this.xTime = xTime;
		this.yRate1 = yRate1;
		this.yRate2 = yRate2;
	}
	public FundProfit(String fundName, List<String> xTime, List<Double> yRate1, List<Double> yRate2,
			List<TimeValueBean> marks, List<Double> yRate3) {
		super();
		this.fundName = fundName;
		this.xTime = xTime;
		this.yRate1 = yRate1;
		this.yRate2 = yRate2;
		this.marks = marks;
		this.yRate3 = yRate3;
	}
	public FundProfit() {
		super();
	}
	
}
