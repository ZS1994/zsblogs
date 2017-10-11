package com.zs.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/menu")
public class IndexCon{
	
	@RequestMapping("/index")
	public String gotoIndex(){
		return "/index";
	}
	
}
