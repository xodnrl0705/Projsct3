<%@page import="util.JavascriptUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

//멀티게시판 구현을 위한 파라미터 처리
String bname = request.getParameter("bname");
if(bname == null || bname.equals("")){
	//만약 bname의 값이 없다면 로그인 화면으로 강제이동시킨다.
	JavascriptUtil.jsAlertLocation("필수파라미터 누락됨(게시판종류) 홈화면으로 이동합니다.", "../main/main.jsp", out);//자바스크립트를 띄어주는 코드 alert
	return;
}
%>