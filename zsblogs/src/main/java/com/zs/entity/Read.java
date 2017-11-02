package com.zs.entity;

import java.util.Date;

public class Read {
    private Integer id;

    private Integer uId;

    private Integer bId;

    private Date createTime;

    //---------------
    private Users user;
    
    
    public Users getUser() {
		return user;
	}

	public void setUser(Users user) {
		this.user = user;
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

    public Integer getbId() {
        return bId;
    }

    public void setbId(Integer bId) {
        this.bId = bId;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

	public Read() {
		super();
	}

	public Read(Integer uId, Integer bId) {
		super();
		this.uId = uId;
		this.bId = bId;
		this.createTime=new Date();
	}
    
}