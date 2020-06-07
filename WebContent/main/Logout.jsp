<%@page import="util.JavascriptUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	session.removeAttribute("USER_ID");
	session.removeAttribute("USER_PW");
	session.removeAttribute("USER_GRADE");
	
	session.invalidate();

	JavascriptUtil.jsAlertLocation("로그아웃되었습니다!","main.jsp", out);
	return;

	
	/*  response.sendRedirect("login.html");*/
%>