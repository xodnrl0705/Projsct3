<%@page import="model.MembershipDAO"%>
<%@page import="java.sql.Date"%>
<%@page import="model.MembershipDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

request.setCharacterEncoding("UTF-8");

String name = request.getParameter("name");
String id = request.getParameter("id");
String pass = request.getParameter("pass");
String tel1 = request.getParameter("tel1");
String tel2 = request.getParameter("tel2");
String tel3 = request.getParameter("tel3");
String mobile1 = request.getParameter("mobile1");
String mobile2 = request.getParameter("mobile2");
String mobile3 = request.getParameter("mobile3");
String email_1 = request.getParameter("email_1");
String email_2 = request.getParameter("email_2");
String zip = request.getParameter("zip1"); 
String addr1 = request.getParameter("addr1");
String addr2 = request.getParameter("addr2"); 
String emailcheck = request.getParameter("open_email"); 

String tel = tel1 + "-"+ tel2 + "-"+ tel3;
String phone = mobile1 + "-"+ mobile2 + "-"+ mobile3;
String email = email_1 + "@"+ email_2;
String addr = addr1 + " " + addr2;
if(emailcheck == null){
	emailcheck = "no";
}

System.out.println(emailcheck);

//dto객체에 속성들 저장
MembershipDTO dto = new MembershipDTO();
dto.setName(name);
dto.setId(id);
dto.setPass(pass);
dto.setTel(tel);
dto.setPhone(phone);
dto.setEmail(email);
dto.setZip(zip);
dto.setAddr(addr);
dto.setEmailcheck(emailcheck);


MembershipDAO dao = new MembershipDAO(application);
int affected = dao.memberJoin(dto);//입력한 dto객체를 db에 저장

if(affected==1){
	//회원가입에 성공했을때..
	
	response.sendRedirect("login.jsp");
}
else{
	//회원가입에 실패했을때...
}
%>
	<script>
		alert("회원가입에 실패하였습니다.");
		history.go(-1);
	</script>
<%
//out.print("글쓰기처리:"+request.getParameter("title"));

%>



%>
