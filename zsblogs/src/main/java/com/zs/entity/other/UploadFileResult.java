package com.zs.entity.other;

import java.util.List;

public class UploadFileResult {

	private int errno;//即错误代码，0 表示没有错误。如果有错误，errno != 0，可通过下文中的监听函数 fail 拿到该错误码进行自定义处理
	private List<String> data;//data 是一个数组，返回若干图片的线上地址
	
	public int getErrno() {
		return errno;
	}
	public UploadFileResult setErrno(int errno) {
		this.errno = errno;
		return this;
	}
	public List<String> getData() {
		return data;
	}
	public UploadFileResult setData(List<String> data) {
		this.data = data;
		return this;
	}
	
	
}
