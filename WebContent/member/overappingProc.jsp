<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="util.JavascriptUtil"%>
<%@page import="model.MembershipDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String id = request.getParameter("id");

String drv = application.getInitParameter("MariaJDBCDriver");//MariaDB정보로 변경되므로 초기화파라미터를 수정한다.
String url = application.getInitParameter("MariaConnectURL");

MembershipDAO dao = new MembershipDAO(drv, url); 
JSONObject json = new JSONObject();


boolean idCheck = dao.idCheck(id);
if(idCheck == false){
	json.put("result",1);
	json.put("message", "사용가능한 아이디입니다.");
}else{
	json.put("result",0);
	json.put("message", "중복된 아이디입니다.");
}

dao.close();
String jsonStr = json.toJSONString();
out.print(jsonStr);
%>
