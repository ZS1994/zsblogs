package com.zs.entity;

/**
 * 2020-3-3
 * 该接口为实体类的扩展接口，实现该接口将拥有一些额外的辅助方法，比如合法性校验等
 * @author 张顺
 */
public interface EntityUtils {

	public final static Integer CODE_NULL_OBJECT = -999;
	public final static Integer CODE_NULL_ID = -500;
	
	/**
	 * 合法性校验，不判断主键（因为主要场景是添加），判断其他必填项，为空返回<0，全通过返回1
	 * @return
	 */
	public int validity();
	
}
