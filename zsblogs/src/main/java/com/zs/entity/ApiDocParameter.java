package com.zs.entity;

public class ApiDocParameter {
    private Integer id;

    private Integer adId;

    private String name;

    private String type;

    private Integer ismust;

    private String introduce;

    private String eg;

    //---------
    private ApiDoc apiDoc;
    
    
    public ApiDoc getApiDoc() {
		return apiDoc;
	}

	public void setApiDoc(ApiDoc apiDoc) {
		this.apiDoc = apiDoc;
	}

	public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getAdId() {
        return adId;
    }

    public void setAdId(Integer adId) {
        this.adId = adId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type == null ? null : type.trim();
    }

    public Integer getIsmust() {
        return ismust;
    }

    public void setIsmust(Integer ismust) {
        this.ismust = ismust;
    }

    public String getIntroduce() {
        return introduce;
    }

    public void setIntroduce(String introduce) {
        this.introduce = introduce == null ? null : introduce.trim();
    }

    public String getEg() {
        return eg;
    }

    public void setEg(String eg) {
        this.eg = eg == null ? null : eg.trim();
    }
}