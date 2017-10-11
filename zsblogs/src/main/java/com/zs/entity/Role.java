package com.zs.entity;

import java.math.BigDecimal;

public class Role {
    private BigDecimal id;

    private String name;

    private String describtion;

    private String pers;

    public BigDecimal getId() {
        return id;
    }

    public void setId(BigDecimal id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getDescribtion() {
        return describtion;
    }

    public void setDescribtion(String describtion) {
        this.describtion = describtion == null ? null : describtion.trim();
    }

    public String getPers() {
        return pers;
    }

    public void setPers(String pers) {
        this.pers = pers == null ? null : pers.trim();
    }
}