<%@page import="util.JavascriptUtil"%>
<%@page import="java.util.Map"%>
<%@page import="model.MembershipDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String id = request.getParameter("user_id");
String pw = request.getParameter("user_password");
 
String drv = application.getInitParameter("MariaJDBCDriver");//MariaDB정보로 변경되므로 초기화파라미터를 수정한다.
String url = application.getInitParameter("MariaConnectURL");

MembershipDAO dao = new MembershipDAO(drv, url); 


Map<String,String> memberInfo = dao.getMemberMap(id, pw);
//Map의id키값에 저장된 값이 있는지 확인
if(memberInfo.get("id")!=null && memberInfo.get("grade").equals("10")){
	//해당 아이디가 있고 등급도 관리자등급이라면...세션영역에 아이디, 패스워드, 이름을 속성으로 저장한다.
	session.setAttribute("USER_ID", memberInfo.get("id"));
	session.setAttribute("USER_PW", memberInfo.get("pass"));
	session.setAttribute("USER_NAME", memberInfo.get("name"));
	
	response.sendRedirect("index.jsp");
}else if(memberInfo.get("id")!=null && memberInfo.get("grade") != "10"){
	//해당 아이디가 있지만 등급이 관리자등급이 아니라면...
	JavascriptUtil.jsAlertLocation("해당아이디는 관리자등급이 아닙니다. 관리자에게 문의주세요!","login.html", out);
	return;
}
else{

	JavascriptUtil.jsAlertLocation("아이디와 비밀번호를 다시 입력해주세요!","login.html", out);
	return;
} 
%>