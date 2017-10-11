package com.zs.tools.mail;

/**
 * 邮件体
 * @author it023
 */
public class MailModel {

	private String toAddress;
	private String ccAddress;
	private String mailContent;
	private String title;
	
	
	public String getToAddress() {
		return toAddress;
	}
	public void setToAddress(String toAddress) {
		this.toAddress = toAddress;
	}
	public String getCcAddress() {
		return ccAddress;
	}
	public void setCcAddress(String ccAddress) {
		this.ccAddress = ccAddress;
	}
	public String getMailContent() {
		return mailContent;
	}
	public void setMailContent(String mailContent) {
		this.mailContent = mailContent;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	
	
	public MailModel(String toAddress, String ccAddress, String mailContent,
			String title) {
		super();
		this.toAddress = toAddress;
		this.ccAddress = ccAddress;
		this.mailContent = mailContent;
		this.title = title;
	}
	public MailModel() {
		super();
	}
	public MailModel(String mailContent, String title) {
		super();
		this.mailContent = mailContent;
		this.title = title;
	}
	
}
