package com.zs.entity;

import java.util.Date;

public class Credit implements EntityUtils{
    private Integer id;

    private String customer;

    private Date time;

    private Date repaymentTime;

    private String note;

    private Double money;

    private String state;

    private Integer traId;

    private Transaction tra;
    
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCustomer() {
        return customer;
    }

    public void setCustomer(String customer) {
        this.customer = customer == null ? null : customer.trim();
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public Date getRepaymentTime() {
        return repaymentTime;
    }

    public void setRepaymentTime(Date repaymentTime) {
        this.repaymentTime = repaymentTime;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note == null ? null : note.trim();
    }

    public Double getMoney() {
        return money;
    }

    public void setMoney(Double money) {
        this.money = money;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state == null ? null : state.trim();
    }

    public Integer getTraId() {
        return traId;
    }

    public void setTraId(Integer traId) {
        this.traId = traId;
    }

	public Transaction getTra() {
		return tra;
	}

	public void setTra(Transaction tra) {
		this.tra = tra;
	}

	@Override
	public int validity() {
		if (customer == null) {
			return -1;
		}
		if (time == null) {
			return -2;
		}
		if (repaymentTime == null) {
			return -3;
		}
		if (money == null) {
			return -4;
		}
		if (state == null) {
			return -5;
		}
		if (traId == null) {
			return -6;
		}
		return 1;
	}
}