package com.zs.entity;

import java.math.BigDecimal;
import java.util.Date;

public class LcToken {
    private String token;

    private BigDecimal uId;

    private Date invalidTime;

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token == null ? null : token.trim();
    }

    public BigDecimal getuId() {
        return uId;
    }

    public void setuId(BigDecimal uId) {
        this.uId = uId;
    }

    public Date getInvalidTime() {
        return invalidTime;
    }

    public void setInvalidTime(Date invalidTime) {
        this.invalidTime = invalidTime;
    }

	public LcToken(String token, BigDecimal uId, Date invalidTime) {
		super();
		this.token = token;
		this.uId = uId;
		this.invalidTime = invalidTime;
	}

	public LcToken() {
		super();
	}
    
}