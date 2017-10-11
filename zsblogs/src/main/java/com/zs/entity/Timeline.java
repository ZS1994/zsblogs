package com.zs.entity;

import java.math.BigDecimal;
import java.util.Date;

public class Timeline {
    private BigDecimal id;

    private BigDecimal pId;

    private BigDecimal uId;

    private Date createTime;

    private String detaInfo;

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public BigDecimal getpId() {
        return pId;
    }

    public void setpId(BigDecimal pId) {
        this.pId = pId;
    }

    public BigDecimal getuId() {
        return uId;
    }

    public void setuId(BigDecimal uId) {
        this.uId = uId;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getDetaInfo() {
        return detaInfo;
    }

    public void setDetaInfo(String detaInfo) {
        this.detaInfo = detaInfo == null ? null : detaInfo.trim();
    }
	public Timeline(BigDecimal pId, BigDecimal uId, String detaInfo) {
		super();
		this.pId = pId;
		this.uId = uId;
		this.detaInfo = detaInfo;
	}

	public Timeline() {
		super();
	}
}