package com.zs.entity;

import java.util.Date;

public class Params {
    private String pId;

    private String group;

    private String pName;

    private String pValue;

    private String pV1;

    private String pV2;

    private String pV3;
    
    private String status;

    private Integer createUser;

    private Date createTime;

    public String getpId() {
        return pId;
    }

    public void setpId(String pId) {
        this.pId = pId == null ? null : pId.trim();
    }

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group == null ? null : group.trim();
    }

    public String getpName() {
        return pName;
    }

    public void setpName(String pName) {
        this.pName = pName == null ? null : pName.trim();
    }

    public String getpValue() {
        return pValue;
    }

    public void setpValue(String pValue) {
        this.pValue = pValue == null ? null : pValue.trim();
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status == null ? null : status.trim();
    }

    public Integer getCreateUser() {
        return createUser;
    }

    public void setCreateUser(Integer createUser) {
        this.createUser = createUser;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

	public String getpV1() {
		return pV1;
	}

	public void setpV1(String pV1) {
		this.pV1 = pV1;
	}

	public String getpV2() {
		return pV2;
	}

	public void setpV2(String pV2) {
		this.pV2 = pV2;
	}

	public String getpV3() {
		return pV3;
	}

	public void setpV3(String pV3) {
		this.pV3 = pV3;
	}
    
    
}