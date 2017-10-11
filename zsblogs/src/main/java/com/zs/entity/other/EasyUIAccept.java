package com.zs.entity.other;

import java.util.Date;
import java.util.Map;

/**张顺，2017-2-28
 * 用于接收easyui数据表格的所有参数的封装
 * @author it023
 * @param <T>
 */
public class EasyUIAccept {
	//Integer year,String sort,String order,Integer page,Integer rows
	private String sort;//要排序的列名
	private String order;//正序还是倒叙
	private Integer page;//当前页码
	private Integer rows;//每页数量
	private Integer start;//开始条数,>开始条数
	private Integer end;//结束条数,<=结束条数
	//以下是属性条件查询字段
	private String id;
	//------------------
	private Integer int1;
	private Integer int2;
	private Integer int3;
	private Integer int4;
	private Integer int5;
	//--------
	private String str1;
	private String str2;
	private String str3;
	private String str4;
	private String str5;
	private String str6;
	private String str7;
	private String str8;
	private String str9;
	private String str10;
	private String str11;
	private String str12;
	private String str13;
	private String str14;
	private String str15;
	//---------
	private Date date1;
	private Date date2;
	private Date date3;
	private Date date4;
	//----------------------
	private Double d1;
	private Double d2;
	private Double d3;
	private Double d4;
	private Double d5;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getSort() {
		return sort;
	}
	public void setSort(String sort) {
		this.sort = sort;
	}
	public String getOrder() {
		return order;
	}
	public void setOrder(String order) {
		this.order = order;
	}
	public Integer getPage() {
		return page;
	}
	public void setPage(Integer page) {
		this.page = page;
	}
	public Integer getRows() {
		return rows;
	}
	public void setRows(Integer rows) {
		this.rows = rows;
	}
	public Integer getInt1() {
		return int1;
	}
	public void setInt1(Integer int1) {
		this.int1 = int1;
	}
	public Integer getInt2() {
		return int2;
	}
	public void setInt2(Integer int2) {
		this.int2 = int2;
	}
	public Integer getInt3() {
		return int3;
	}
	public void setInt3(Integer int3) {
		this.int3 = int3;
	}
	public Integer getInt4() {
		return int4;
	}
	public void setInt4(Integer int4) {
		this.int4 = int4;
	}
	public Integer getInt5() {
		return int5;
	}
	public void setInt5(Integer int5) {
		this.int5 = int5;
	}
	public String getStr1() {
		return str1;
	}
	public void setStr1(String str1) {
		this.str1 = str1;
	}
	public String getStr2() {
		return str2;
	}
	public void setStr2(String str2) {
		this.str2 = str2;
	}
	public String getStr3() {
		return str3;
	}
	public void setStr3(String str3) {
		this.str3 = str3;
	}
	public String getStr4() {
		return str4;
	}
	public void setStr4(String str4) {
		this.str4 = str4;
	}
	public String getStr5() {
		return str5;
	}
	public void setStr5(String str5) {
		this.str5 = str5;
	}
	public String getStr6() {
		return str6;
	}
	public void setStr6(String str6) {
		this.str6 = str6;
	}
	public String getStr7() {
		return str7;
	}
	public void setStr7(String str7) {
		this.str7 = str7;
	}
	public String getStr8() {
		return str8;
	}
	public void setStr8(String str8) {
		this.str8 = str8;
	}
	public String getStr9() {
		return str9;
	}
	public void setStr9(String str9) {
		this.str9 = str9;
	}
	public String getStr10() {
		return str10;
	}
	public void setStr10(String str10) {
		this.str10 = str10;
	}
	public String getStr11() {
		return str11;
	}
	public void setStr11(String str11) {
		this.str11 = str11;
	}
	public String getStr12() {
		return str12;
	}
	public void setStr12(String str12) {
		this.str12 = str12;
	}
	public String getStr13() {
		return str13;
	}
	public void setStr13(String str13) {
		this.str13 = str13;
	}
	public String getStr14() {
		return str14;
	}
	public void setStr14(String str14) {
		this.str14 = str14;
	}
	public String getStr15() {
		return str15;
	}
	public void setStr15(String str15) {
		this.str15 = str15;
	}
	public Date getDate1() {
		return date1;
	}
	public void setDate1(Date date1) {
		this.date1 = date1;
	}
	public Date getDate2() {
		return date2;
	}
	public void setDate2(Date date2) {
		this.date2 = date2;
	}
	public Date getDate3() {
		return date3;
	}
	public void setDate3(Date date3) {
		this.date3 = date3;
	}
	public Date getDate4() {
		return date4;
	}
	public void setDate4(Date date4) {
		this.date4 = date4;
	}
	public Double getD1() {
		return d1;
	}
	public void setD1(Double d1) {
		this.d1 = d1;
	}
	public Double getD2() {
		return d2;
	}
	public void setD2(Double d2) {
		this.d2 = d2;
	}
	public Double getD3() {
		return d3;
	}
	public void setD3(Double d3) {
		this.d3 = d3;
	}
	public Double getD4() {
		return d4;
	}
	public void setD4(Double d4) {
		this.d4 = d4;
	}
	public Double getD5() {
		return d5;
	}
	public void setD5(Double d5) {
		this.d5 = d5;
	}
	public Integer getStart() {
		return start;
	}
	public void setStart(Integer start) {
		this.start = start;
	}
	public Integer getEnd() {
		return end;
	}
	public void setEnd(Integer end) {
		this.end = end;
	}
	@Override
	public String toString() {
		return "EasyUIAccept [sort=" + sort + ", order=" + order + ", page=" + page + ", rows=" + rows + ", start="
				+ start + ", end=" + end + ", int1=" + int1 + ", int2=" + int2 + ", int3=" + int3 + ", int4=" + int4
				+ ", int5=" + int5 + ", str1=" + str1 + ", str2=" + str2 + ", str3=" + str3 + ", str4=" + str4
				+ ", str5=" + str5 + ", str6=" + str6 + ", str7=" + str7 + ", str8=" + str8 + ", str9=" + str9
				+ ", str10=" + str10 + ", str11=" + str11 + ", str12=" + str12 + ", str13=" + str13 + ", str14=" + str14
				+ ", str15=" + str15 + ", date1=" + date1 + ", date2=" + date2 + ", date3=" + date3 + ", date4=" + date4
				+ ", d1=" + d1 + ", d2=" + d2 + ", d3=" + d3 + ", d4=" + d4 + ", d5=" + d5 + "]";
	}
	
}
