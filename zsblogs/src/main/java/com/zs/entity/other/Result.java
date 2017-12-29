package com.zs.entity.other;

public class Result<T> {
	private String result;
	private Integer code;
	private T data;
	private String description;//描述
	
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	public Integer getCode() {
		return code;
	}
	public void setCode(Integer code) {
		this.code = code;
	}
	public T getData() {
		return data;
	}
	public void setData(T data) {
		this.data = data;
	}
	public Result(String result, Integer code, T data) {
		super();
		this.result = result;
		this.code = code;
		this.data = data;
	}
	@Override
	public String toString() {
		return "Result [result=" + result + ", code=" + code + ", data=" + data + "]";
	}
	public Result() {
		super();
	}
	public Result(String result, Integer code, T data, String description) {
		super();
		this.result = result;
		this.code = code;
		this.data = data;
		this.description = description;
	}
	
	
}
