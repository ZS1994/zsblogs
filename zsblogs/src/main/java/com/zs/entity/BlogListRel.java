package com.zs.entity;

public class BlogListRel {
    private Integer id;

    private Integer blId;

    private Integer bId;

    
    
    public BlogListRel() {
		super();
	}

	public BlogListRel(Integer blId, Integer bId) {
		super();
		this.blId = blId;
		this.bId = bId;
	}

	public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getBlId() {
        return blId;
    }

    public void setBlId(Integer blId) {
        this.blId = blId;
    }

    public Integer getbId() {
        return bId;
    }

    public void setbId(Integer bId) {
        this.bId = bId;
    }
}