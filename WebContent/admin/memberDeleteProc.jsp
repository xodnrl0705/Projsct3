<%@page import="util.JavascriptUtil"%>
<%@page import="model.MembershipDAO"%>
<%@page import="model.MembershipDTO"%>
<%@page import="model.BbsDAO"%>
<%@page import="model.BbsDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- 파일명 : deleteProc.jsp --%>
<%@ include file="isLogin.jsp" %>
<%
String id = request.getParameter("id");

MembershipDTO dto = new MembershipDTO();
MembershipDAO dao = new MembershipDAO(application);

dto = dao.selectView(id);

dto.setId(id);
int affected = dao.delete(dto); 

if(affected==1){
	JavascriptUtil.jsAlertLocation("삭제되었습니다",
			"memberList.jsp" , out);
}
else{
	out.println(JavascriptUtil.jsAlertBack("삭제실패하였습니다."));
}


%>
    