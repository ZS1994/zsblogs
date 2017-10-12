package com.zs.entity;

import java.util.Date;

public class Timeline {
    private Integer id;

    private Integer uId;

    private Integer pId;

    private Date createTime;

    private String info;

    
    

	public Timeline(Integer uId, Integer pId, String info) {
		super();
		this.uId = uId;
		this.pId = pId;
		this.info = info;
		this.createTime=new Date();
	}

	public Timeline() {
		super();
	}

	public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getuId() {
        return uId;
    }

    public void setuId(Integer uId) {
        this.uId = uId;
    }

    public Integer getpId() {
        return pId;
    }

    public void setpId(Integer pId) {
        this.pId = pId;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info == null ? null : info.trim();
    }
}