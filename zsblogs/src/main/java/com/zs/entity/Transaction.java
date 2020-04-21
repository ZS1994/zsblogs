package com.zs.entity;

import java.util.Date;
import java.util.List;

public class Transaction implements EntityUtils{
    private Integer id;

    private Date time;

    private String customer;

    private String state;

    private String note;

    private List<TransactionDetail> traDets;
    
    
    public List<TransactionDetail> getTraDets() {
		return traDets;
	}

	public void setTraDets(List<TransactionDetail> traDets) {
		this.traDets = traDets;
	}

	public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public String getCustomer() {
        return customer;
    }

    public void setCustomer(String customer) {
        this.customer = customer == null ? null : customer.trim();
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state == null ? null : state.trim();
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note == null ? null : note.trim();
    }

	@Override
	public int validity() {
		if (time == null) {
			return -1;
		}
		if (customer == null) {
			return -2;
		}
		if (state == null) {
			return -3;
		}
		if (traDets == null) {
			return -4;
		}
		return 1;
	}
    
    
    
}