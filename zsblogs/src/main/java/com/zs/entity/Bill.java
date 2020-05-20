package com.zs.entity;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.Date;

public class Bill implements EntityUtils{
	
	public final static String TYPE_JIAOYI = "交易";
	public final static String TYPE_HUANZHANG = "还账";
	public final static String TYPE_RUKU = "入库";
	
	
    private Integer id;

    private Date time;

    private String people;

    private Double money;

    private String type;

    private Integer relId;

    
    private Transaction tra;
    private Credit credit;
    private Stock stock;
    
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
    @JsonFormat(pattern="yyyy/MM/dd HH:mm:ss",timezone = "GMT+8")
    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public String getPeople() {
        return people;
    }

    public void setPeople(String people) {
        this.people = people == null ? null : people.trim();
    }

    public Double getMoney() {
        return money;
    }

    public void setMoney(Double money) {
        this.money = money;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type == null ? null : type.trim();
    }

    public Integer getRelId() {
        return relId;
    }

    public void setRelId(Integer relId) {
        this.relId = relId;
    }

	public Transaction getTra() {
		return tra;
	}

	public void setTra(Transaction tra) {
		this.tra = tra;
	}

	public Credit getCredit() {
		return credit;
	}

	public void setCredit(Credit credit) {
		this.credit = credit;
	}

	public Stock getStock() {
		return stock;
	}

	public void setStock(Stock stock) {
		this.stock = stock;
	}

	@Override
	public int validity() {
		if (time == null) {
			return -1;
		}
		if (people == null) {
			return -2;
		}
		if (money == null) {
			return -3;
		}
		if (type == null) {
			return -4;
		}
		if (relId == null) {
			return -5;
		}
		return 1;
	}
}