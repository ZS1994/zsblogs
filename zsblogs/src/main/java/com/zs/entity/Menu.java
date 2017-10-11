package com.zs.entity;

import java.math.BigDecimal;
import java.util.List;

public class Menu {
    private BigDecimal id;

    private String name;

    private String url;

    private String img;

    private BigDecimal pId;

    private BigDecimal mNumber;

    private List<Menu> childMenu;
	
	
    public List<Menu> getChildMenu() {
		return childMenu;
	}

	public void setChildMenu(List<Menu> childMenu) {
		this.childMenu = childMenu;
	}

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

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url == null ? null : url.trim();
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img == null ? null : img.trim();
    }

    public BigDecimal getpId() {
        return pId;
    }

    public void setpId(BigDecimal pId) {
        this.pId = pId;
    }

    public BigDecimal getmNumber() {
        return mNumber;
    }

    public void setmNumber(BigDecimal mNumber) {
        this.mNumber = mNumber;
    }
}