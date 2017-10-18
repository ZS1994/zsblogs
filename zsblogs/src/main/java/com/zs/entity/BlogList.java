package com.zs.entity;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class BlogList {
    private Integer id;

    private String name;

    private Date createTime;

    private Integer blOrder;

    private Integer uId;

    //-----------
    private Users user;//用户
    private Integer blogsNum;//博客数量
    
    
    public Users getUser() {
		return user;
	}

	public void setUser(Users user) {
		this.user = user;
	}

	public Integer getBlogsNum() {
		return blogsNum;
	}

	public void setBlogsNum(Integer blogsNum) {
		this.blogsNum = blogsNum;
	}

	public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }
    @JsonFormat(pattern="yyyy/MM/dd HH:mm:ss",timezone = "GMT+8")
    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Integer getBlOrder() {
        return blOrder;
    }

    public void setBlOrder(Integer blOrder) {
        this.blOrder = blOrder;
    }

    public Integer getuId() {
        return uId;
    }

    public void setuId(Integer uId) {
        this.uId = uId;
    }
}