package com.zs.controller.rest;


import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.zs.controller.rest.BaseRestController.Code;
import com.zs.entity.other.Result;

@RestController
@RequestMapping("/api/test")
public class TestConR {

	/*测试 跨域、权限、时间轴是否生效*/
	@RequestMapping(value="/testCors",method=RequestMethod.POST)
	public Result<String> testCors(String a){
		System.out.println("[a]"+a);
		return new Result<String>(BaseRestController.SUCCESS, Code.SUCCESS, a);
	}
	
}
