package com.zs.entity;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

public class FundInfo {
    private String id;

    private String manager;

    private String scale;

    private String type;

    private String company;

    private Integer grade;

    private Double buyMin;

    private Double buyRate;

    private Double selloutRateOne;

    private Double selloutRateTwo;

    private Double selloutRateThree;

    private Double managerRate;

    private Date createDate;

    private String name;

    public String getId() {
        return id;
    }

    public FundInfo setId(String id) {
        this.id = id == null ? null : id.trim();
        return this;
    }

    public String getManager() {
        return manager;
    }

    public FundInfo setManager(String manager) {
        this.manager = manager == null ? null : manager.trim();
        return this;
    }

    public String getScale() {
        return scale;
    }

    public FundInfo setScale(String scale) {
        this.scale = scale == null ? null : scale.trim();
        return this;
    }

    public String getType() {
        return type;
    }

    public FundInfo setType(String type) {
        this.type = type == null ? null : type.trim();
        return this;
    }

    public String getCompany() {
        return company;
    }

    public FundInfo setCompany(String company) {
        this.company = company == null ? null : company.trim();
        return this;
    }

    public Integer getGrade() {
        return grade;
    }

    public FundInfo setGrade(Integer grade) {
        this.grade = grade;
        return this;
    }

    public Double getBuyMin() {
        return buyMin;
    }

    public FundInfo setBuyMin(Double buyMin) {
        this.buyMin = buyMin;
        return this;
    }

    public Double getBuyRate() {
        return buyRate;
    }

    public FundInfo setBuyRate(Double buyRate) {
        this.buyRate = buyRate;
        return this;
    }

    public Double getSelloutRateOne() {
        return selloutRateOne;
    }

    public FundInfo setSelloutRateOne(Double selloutRateOne) {
        this.selloutRateOne = selloutRateOne;
        return this;
    }

    public Double getSelloutRateTwo() {
        return selloutRateTwo;
    }

    public FundInfo setSelloutRateTwo(Double selloutRateTwo) {
        this.selloutRateTwo = selloutRateTwo;
        return this;
    }

    public Double getSelloutRateThree() {
        return selloutRateThree;
    }

    public FundInfo setSelloutRateThree(Double selloutRateThree) {
        this.selloutRateThree = selloutRateThree;
        return this;
    }

    public Double getManagerRate() {
        return managerRate;
    }

    public FundInfo setManagerRate(Double managerRate) {
        this.managerRate = managerRate;
        return this;
    }
    @JsonFormat(pattern="yyyy/MM/dd",timezone = "GMT+8")
    public Date getCreateDate() {
        return createDate;
    }

    public FundInfo setCreateDate(Date createDate) {
        this.createDate = createDate;
        return this;
    }

    public String getName() {
        return name;
    }

    public FundInfo setName(String name) {
        this.name = name == null ? null : name.trim();
        return this;
    }
}
