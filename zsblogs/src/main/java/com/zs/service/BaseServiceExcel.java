package com.zs.service;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import com.zs.entity.other.EasyUIAccept;

public interface BaseServiceExcel<T,ID_TYPE> extends BaseService<T, ID_TYPE>{
	
	public String importData(List<String[]> list,String stuNum);
	
	public String exportData(EasyUIAccept accept,HttpServletRequest request);
}
