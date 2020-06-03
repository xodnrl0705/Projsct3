<%@page import="model.BbsDAO"%>
<%@page import="model.BbsDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 글작성 완료 전 로그인 체크하기 -->
<%@ include file="./isLogin.jsp" %>
<%@ include file="./isFlag.jsp" %>
<%
request.setCharacterEncoding("UTF-8");

//폼값전송받기
String num = request.getParameter("num");//제목
String title = request.getParameter("title");//제목
String content = request.getParameter("content");//내용
String attachedfile = request.getParameter("attachedfile");//내용


BbsDTO dto = new BbsDTO();
dto.setNum(num);
dto.setTitle(title);
dto.setContent(content);
dto.setAttachedfile(attachedfile);

BbsDAO dao = new BbsDAO(application);
//DTO객체를 DAO로 전달하여 게시물 업데이트(수정)
int affected = dao.updateEdit(dto); 

if(affected==1){
	response.sendRedirect("boardView.jsp?bname="+bname+"&num="+dto.getNum());
}
else{

%>
	<script>
		alert("수정하기에 실패하였습니다.");
		history.go(-1);
	</script>
<%
}
%>
