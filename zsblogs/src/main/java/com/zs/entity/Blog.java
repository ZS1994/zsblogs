package com.zs.entity;

import java.util.Date;

public class Blog {
    private Integer id;

    private String title;

    private Date createTime;

    private Integer blId;

    private String content;

    private String summary;
    
    private String ishide;
    
    
    public String getIshide() {
		return ishide;
	}

	public void setIshide(String ishide) {
		this.ishide = ishide;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title == null ? null : title.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Integer getBlId() {
        return blId;
    }

    public void setBlId(Integer blId) {
        this.blId = blId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content == null ? null : content.trim();
    }
}