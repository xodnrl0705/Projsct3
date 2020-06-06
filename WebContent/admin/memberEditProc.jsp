<%@page import="org.json.simple.JSONObject"%>
<%@page import="model.MembershipDAO"%>
<%@page import="model.MembershipDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./isLogin.jsp" %>
<%
request.setCharacterEncoding("UTF-8");

String name = request.getParameter("name");
String id = request.getParameter("id");
String pass = request.getParameter("pass");
String tel = request.getParameter("tel");
String phone = request.getParameter("phone");
String email = request.getParameter("email");
String grade = request.getParameter("grade");
String emailcheck = request.getParameter("emailcheck");
String zip = request.getParameter("zip");
String addr = request.getParameter("addr");

//dto객체에 속성들 저장
MembershipDTO dto = new MembershipDTO();
dto.setName(name);
dto.setId(id);
dto.setPass(pass);
dto.setTel(tel);
dto.setPhone(phone);
dto.setEmail(email);
dto.setGrade(grade);
dto.setZip(zip);
dto.setAddr(addr);




MembershipDAO dao = new MembershipDAO(application);
//DTO객체를 DAO로 전달하여 게시물 업데이트(수정)
int affected = dao.updateEdit(dto); 
JSONObject json = new JSONObject();

if(affected==1){
	json.put("result",1);
	json.put("message", "수정이 완료되었습니다.");
	
}else{
	json.put("result",0);
	json.put("message", "수정이 올바르게되지 않았습니다.");
}
dao.close();
String jsonStr = json.toJSONString();
out.print(jsonStr);

%>
