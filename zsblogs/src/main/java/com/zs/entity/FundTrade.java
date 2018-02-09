package com.zs.entity;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class FundTrade {
    private Integer id;

    private Integer uId;

    private String fiId;

    private Double buyMoney;

    private Double buyNumber;

    private Date createTime;

    private String type;

    
    //---------------------
    private Users u;
    private FundInfo fi;
    
    
    
    public Users getU() {
		return u;
	}

	public void setU(Users u) {
		this.u = u;
	}

	public FundInfo getFi() {
		return fi;
	}

	public void setFi(FundInfo fi) {
		this.fi = fi;
	}

	public Integer getId() {
        return id;
    }

    public FundTrade setId(Integer id) {
        this.id = id;
        return this;
    }

    public Integer getuId() {
        return uId;
    }

    public FundTrade setuId(Integer uId) {
        this.uId = uId;
        return this;
    }

    public String getFiId() {
        return fiId;
    }

    public FundTrade setFiId(String fiId) {
        this.fiId = fiId == null ? null : fiId.trim();
        return this;
    }

    public Double getBuyMoney() {
        return buyMoney;
    }

    public FundTrade setBuyMoney(Double buyMoney) {
        this.buyMoney = buyMoney;
        return this;
    }

    public Double getBuyNumber() {
        return buyNumber;
    }

    public FundTrade setBuyNumber(Double buyNumber) {
        this.buyNumber = buyNumber;
        return this;
    }
    @JsonFormat(pattern="yyyy/MM/dd",timezone = "GMT+8")
    public Date getCreateTime() {
        return createTime;
    }

    public FundTrade setCreateTime(Date createTime) {
        this.createTime = createTime;
        return this;
    }

    public String getType() {
        return type;
    }

    public FundTrade setType(String type) {
        this.type = type == null ? null : type.trim();
        return this;
    }
}
