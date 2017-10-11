package com.zs.controller.rest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.zs.entity.other.EasyUIAccept;
import com.zs.entity.other.EasyUIPage;
import com.zs.entity.other.Result;

/**
 * restcontrooler的基类，其他的restcon必须继承它
 * @author 张顺，2017-4-15
 */

public abstract class BaseRestController<T,ID_TYPE>{
	
	public static final String SUCCESS="success";
	public static final String ERROR="error";
	
	/**
	 * 状态码
	 * @author it023
	 */
	public static class Code{
		public static final int ERROR=-1;
		public static final int SUCCESS=0;
		public static final int LICENCE_NO=1;
		public static final int LICENCE_TIMEOUT=2;
		public static final int LOGIN_PASS_ERROR=11;
		public static final int LOGIN_USER_NO=12;
		public static final int LOGIN_INFO_NO=13;
		public static final int ROLE_USER_NO_PERMISSION=101;
		public static final int ROLE_USER_NO_ROLE=102;
		public static final int ROLE_NO_PERMISSION=103;
		public static final int PERMISSION_NO_EXIST=104;
	}
	
	
	/**
	 * 分页查询，查询多条
	 * @param accept
	 * @param req
	 * @param resp
	 * @return
	 */
	public abstract EasyUIPage doQuery(EasyUIAccept accept, HttpServletRequest req, HttpServletResponse resp);
	/**
	 * 查询一条
	 * @param id
	 * @param req
	 * @param resp
	 * @return
	 */
	public abstract Result<T> doGet(ID_TYPE id, HttpServletRequest req, HttpServletResponse resp);
	/**
	 * 添加一条
	 * @param obj
	 * @param req
	 * @param resp
	 * @return
	 */
	public abstract Result<String> doAdd(T obj,HttpServletRequest req,HttpServletResponse resp);
	/**
	 * 修改一条
	 * @param obj
	 * @param req
	 * @param resp
	 * @return
	 */
	public abstract Result<String> doUpdate(T obj,HttpServletRequest req,HttpServletResponse resp);
	/**
	 * 假删除一条
	 * @param id
	 * @param req
	 * @param resp
	 * @return
	 */
	public abstract Result<String> doDeleteFalse(ID_TYPE id, HttpServletRequest req, HttpServletResponse resp);
	/**
	 * 真删除一条
	 * @param id
	 * @param req
	 * @param resp
	 * @return
	 */
	public abstract Result<String> doDeleteTrue(ID_TYPE id, HttpServletRequest req, HttpServletResponse resp);
	/**
	 * 导出数据
	 * @param accept
	 * @param req
	 * @param resp
	 * @return
	 */
	public abstract Result<String> excelExport(EasyUIAccept accept,HttpServletRequest req,HttpServletResponse resp);
	
	
	/**
	 * 导入数据
	 * @param accept
	 * @param req
	 * @param resp
	 * @return
	 */
	public abstract Result<String> excelImport(MultipartFile file,HttpServletRequest req,HttpServletResponse resp);
}
