package com.zs.entity;

import java.util.Date;

public class BlogList {
    private Integer id;

    private String name;

    private Date createTime;

    private Integer blOrder;

    private Integer uId;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Integer getBlOrder() {
        return blOrder;
    }

    public void setBlOrder(Integer blOrder) {
        this.blOrder = blOrder;
    }

    public Integer getuId() {
        return uId;
    }

    public void setuId(Integer uId) {
        this.uId = uId;
    }
}