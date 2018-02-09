package com.zs.entity;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class FundHistory {
    private Integer id;

    private String fiId;

    private Date time;

    private Double netvalue;

    //--------------------
    private FundInfo fi;
    
    
    public FundInfo getFi() {
		return fi;
	}

	public void setFi(FundInfo fi) {
		this.fi = fi;
	}

	public Integer getId() {
        return id;
    }

    public FundHistory setId(Integer id) {
        this.id = id;
        return this;
    }

    public String getFiId() {
        return fiId;
    }

    public FundHistory setFiId(String fiId) {
        this.fiId = fiId == null ? null : fiId.trim();
        return this;
    }
    @JsonFormat(pattern="yyyy/MM/dd",timezone = "GMT+8")
    public Date getTime() {
        return time;
    }

    public FundHistory setTime(Date time) {
        this.time = time;
        return this;
    }

    public Double getNetvalue() {
        return netvalue;
    }

    public FundHistory setNetvalue(Double netvalue) {
        this.netvalue = netvalue;
        return this;
    }
}
