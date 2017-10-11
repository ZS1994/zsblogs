package com.zs.entity.other;

import java.util.List;

/**
 * 张顺，2017-2-23
 * easyui的分页对象
 * @author it023
 *
 */
public class EasyUIPage {
	int total;//最大页数
	List<Object> rows;//当前页的数据
	
	public int getTotal() {
		return total;
	}
	public void setTotal(int total) {
		this.total = total;
	}
	public List<Object> getRows() {
		return rows;
	}
	public void setRows(List<Object> rows) {
		this.rows = rows;
	}
	public EasyUIPage(int total, List<Object> rows) {
		super();
		this.total = total;
		this.rows = rows;
	}
	public EasyUIPage() {
		super();
	}
	
	
}
