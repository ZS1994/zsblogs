package com.zs.entity;

import java.util.Date;

public class Token {
    private String token;

    private Integer uId;

    private Date invalidTime;

    
    
    public Token() {
		super();
	}

	public Token(String token, Integer uId, Date invalidTime) {
		super();
		this.token = token;
		this.uId = uId;
		this.invalidTime = invalidTime;
	}

	public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token == null ? null : token.trim();
    }

    public Integer getuId() {
        return uId;
    }

    public void setuId(Integer uId) {
        this.uId = uId;
    }

    public Date getInvalidTime() {
        return invalidTime;
    }

    public void setInvalidTime(Date invalidTime) {
        this.invalidTime = invalidTime;
    }
}