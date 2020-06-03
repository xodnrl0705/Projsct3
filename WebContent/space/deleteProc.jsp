<%@page import="model.BbsDAO"%>
<%@page import="model.BbsDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- 파일명 : deleteProc.jsp --%>
<%@ include file="isLogin.jsp" %>
<%@ include file="isFlag.jsp" %>
<%
String num = request.getParameter("num");

BbsDTO dto = new BbsDTO();
BbsDAO dao = new BbsDAO(application);

dto = dao.selectView(num);

dto.setNum(num);
int affected = dao.delete(dto);

if(affected==1){
	JavascriptUtil.jsAlertLocation("삭제되었습니다",
			"sub01_list.jsp?bname=" + bname , out);
}
else{
	out.println(JavascriptUtil.jsAlertBack("삭제실패하였습니다."));
}


%>
    