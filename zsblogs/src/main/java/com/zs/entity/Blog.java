package com.zs.entity;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

public class Blog {
    private Integer id;

    private String title;

    private Date createTime;

    private String content;

    private String summary;
    
    private String ishide;
    
    
    //-------------
    private String blIds;
    private Users user;
    private String blogListNames;//所属栏目（名字）
    private Integer readCount;//阅读次数

	public Integer getReadCount() {
		return readCount;
	}

	public void setReadCount(Integer readCount) {
		this.readCount = readCount;
	}

	public String getBlogListNames() {
		return blogListNames;
	}

	public void setBlogListNames(String blogListNames) {
		this.blogListNames = blogListNames;
	}

	public Users getUser() {
		return user;
	}

	public void setUser(Users user) {
		this.user = user;
	}

	public String getBlIds() {
		return blIds;
	}

	public void setBlIds(String blIds) {
		this.blIds = blIds;
	}

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
    @JsonFormat(pattern="yyyy/MM/dd HH:mm:ss",timezone = "GMT+8")
    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content == null ? null : content.trim();
    }

	@Override
	public String toString() {
		return "Blog [id=" + id + ", title=" + title + ", createTime=" + createTime + ", content=" + content
				+ ", summary=" + summary + ", ishide=" + ishide + ", blIds=" + blIds + "]";
	}

	public Blog() {
		super();
	}

	public Blog(String title, String content, String summary, String blIds) {
		super();
		this.title = title;
		this.content = content;
		this.summary = summary;
		this.blIds = blIds;
	}
    
    
}