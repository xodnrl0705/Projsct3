<%@page import="util.JavascriptUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	session.removeAttribute("USER_ID");
	session.removeAttribute("USER_PW");
	
	session.invalidate();

	JavascriptUtil.jsAlertLocation("로그아웃되었습니다!","login.html", out);
	return;

	
	/*  response.sendRedirect("login.html");*/
%>