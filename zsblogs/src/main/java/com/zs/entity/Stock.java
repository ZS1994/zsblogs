package com.zs.entity;

import java.util.Date;

public class Stock implements EntityUtils{
	
	public final static String STATE_RUKU = "入库";
	public final static String STATE_CHUKU = "出库";
	
	
    private Integer id;

    private Integer gId;

    private Double quantity;

    private String state;

    private Date time;

    private Double purchasePrice;

    private Integer traId;

    private String people;

    
    private Goods goods;
    private Transaction tra;
    
    public Transaction getTra() {
		return tra;
	}

	public void setTra(Transaction tra) {
		this.tra = tra;
	}

	public Goods getGoods() {
		return goods;
	}

	public void setGoods(Goods goods) {
		this.goods = goods;
	}

	public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getgId() {
        return gId;
    }

    public void setgId(Integer gId) {
        this.gId = gId;
    }

    public Double getQuantity() {
        return quantity;
    }

    public void setQuantity(Double quantity) {
        this.quantity = quantity;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state == null ? null : state.trim();
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public Double getPurchasePrice() {
        return purchasePrice;
    }

    public void setPurchasePrice(Double purchasePrice) {
        this.purchasePrice = purchasePrice;
    }

    public Integer getTraId() {
        return traId;
    }

    public void setTraId(Integer traId) {
        this.traId = traId;
    }

    public String getPeople() {
        return people;
    }

    public void setPeople(String people) {
        this.people = people == null ? null : people.trim();
    }

	@Override
	public int validity() {
		if (gId == null) {
			return -1;
		}
		if (quantity == null) {
			return -2;
		}
		if (state == null) {
			return -3;
		}
		if (time == null) {
			return -4;
		}
		if (people == null) {
			return -5;
		}
		return 1;
	}
}