<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<script src="../common/jquery/jquery-3.5.1.js"></script>
<%
String date = request.getParameter("date");
if(date==""||date==null){
	date = "1 ";
}
date = date.replaceAll("-","");
String tet = request.getParameter("tet");






%>


</head>
<body>


<%-- <h3><%=date %></h3> --%>
<h3><%=tet %></h3>


</body>
</html>