<%@page import="org.json.simple.JSONObject"%>
<%@page import="model.MembershipDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true" %>
<%
//보내준 이름과 이메일 값을 받는다.(사용자가 입력했던)
String name = request.getParameter("name");
String email = request.getParameter("email");
String idORpass = request.getParameter("idORpass");
System.out.println("찾을속성:" + idORpass);//test
MembershipDAO dao = new MembershipDAO(application);

if(idORpass.equals("id")){
	//MembershipDAO객체를 받아서 가입되있는 이름,이메일인지 판단하는과정을 거친다.
	String isMemberid = dao.isMemberid(name,email);
	if(isMemberid == ""){
		out.println("입력하신 정보에 부합하는 아이디가 없습니다. 다시 확인해 주시거나 회원가입을 해주세요.");
	}else{
		out.println("가입하신 아이디는 '"+isMemberid+"'입니다");
	}
}else{
	String id = request.getParameter("id");
	JSONObject json = new JSONObject();
	
	String isMemberpass = dao.isMemberpass(id,name,email);
	if(isMemberpass== ""){
		json.put("result" , 0);
		json.put("msg" , "입력하신 정보로 찾은결과 일치하는 회원정보가 없습니다. 다시확인해주세요.");
	}
	else{
		json.put("result" , 1);
		json.put("msg", "비밀번호는 " + isMemberpass + "입니다.");	
	}
	String jsonTxt = json.toJSONString();
	out.println(jsonTxt);
}
dao.close();
%>