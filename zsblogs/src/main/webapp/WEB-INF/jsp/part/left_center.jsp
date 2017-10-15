<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<jsp:include page="/WEB-INF/jsp/part/include_bootstrap.jsp"/>
    <base href="<%=basePath%>">
    <title>中间部分（测试组件是否正常）</title>
  </head>
  
  <body>
  	<jsp:include page="/WEB-INF/jsp/part/left_part.jsp"/>
  	<div class="p_body">
  			<div class="container" style="padding-top: 50px;width: 90%;">
			    <h2>
				    Spring Data REST 远程代码执行漏洞（CVE-2017-8046）分析与复现
			    </h2>
					其河 ·2017-09-29 14:21
			    <pre>
public static class Code{
	public static final int ERROR=-1;
	public static final int SUCCESS=0;
	public static final int LICENCE_NO=1;
	public static final int LICENCE_TIMEOUT=2;
	public static final int LOGIN_PASS_ERROR=11;
	public static final int LOGIN_USER_NO=12;
	public static final int LOGIN_INFO_NO=13;
	public static final int ROLE_USER_NO_PERMISSION=101;
	public static final int ROLE_USER_NO_ROLE=102;
	public static final int ROLE_NO_PERMISSION=103;
	public static final int PERMISSION_NO_EXIST=104;
}
			    </pre>
			    asdasdas
			    
			    
		    </div>
  			
  		
  		
  	</div>
  	
  </body>
</html>
