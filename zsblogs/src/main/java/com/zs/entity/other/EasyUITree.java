package com.zs.entity.other;

import java.util.List;
import java.util.Map;

/**
 * 张顺，2017-3-7
 * 树控件数据结构封装
 * @author it023
 */
public class EasyUITree {
	
	String id;
	String text;
	String iconCls;
	boolean checked;
	String state;
	Object attributes;
	List<EasyUITree> children;
	public EasyUITree() {
		super();
	}
	public EasyUITree(String id, String text, String iconCls, boolean checked, String state, Object attributes,
			List<EasyUITree> children) {
		super();
		this.id = id;
		this.text = text;
		this.iconCls = iconCls;
		this.checked = checked;
		this.state = state;
		this.attributes = attributes;
		this.children = children;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public String getIconCls() {
		return iconCls;
	}
	public void setIconCls(String iconCls) {
		this.iconCls = iconCls;
	}
	public boolean isChecked() {
		return checked;
	}
	public void setChecked(boolean checked) {
		this.checked = checked;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public Object getAttributes() {
		return attributes;
	}
	public void setAttributes(Object attributes) {
		this.attributes = attributes;
	}
	public List<EasyUITree> getChildren() {
		return children;
	}
	public void setChildren(List<EasyUITree> children) {
		this.children = children;
	}
	
}
