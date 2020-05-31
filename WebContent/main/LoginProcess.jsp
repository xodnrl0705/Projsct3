<%@page import="util.JavascriptUtil"%>
<%@page import="java.util.Map"%>
<%@page import="model.MembershipDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String id = request.getParameter("user_id");
String pw = request.getParameter("user_pass");
String id_save = request.getParameter("id_save");

String drv = application.getInitParameter("MariaJDBCDriver");//MariaDB정보로 변경되므로 초기화파라미터를 수정한다.
String url = application.getInitParameter("MariaConnectURL");

MembershipDAO dao = new MembershipDAO(drv, url); 

Map<String,String> memberInfo = dao.getMemberMap(id, pw);
//Map의id키값에 저장된 값이 있는지 확인
if(memberInfo.get("id")!=null){
	//저장된 값이 있따면...세션영역에 아이디, 패스워드, 이름을 속성으로 저장한다.
	session.setAttribute("USER_ID", memberInfo.get("id"));
	session.setAttribute("USER_PW", memberInfo.get("pass"));
	session.setAttribute("USER_NAME", memberInfo.get("name"));
	
	if(id_save==null){
		//아이디저장하기에 체크하지 않았을때...
		//쿠키를 삭제하기 위해 빈 쿠키를 생성한다.
		Cookie ck = new Cookie("USER_ID","");
		ck.setPath(request.getContextPath());
		ck.setMaxAge(0);//유효시간이 0이므로 사용할수 없는 쿠키가 된다.
		response.addCookie(ck);
	}
	else{
		//체크했을때...
		//사용자가 입력한 이이디로 쿠키를 생성한다.
		Cookie ck = new Cookie("USER_ID",id);
		System.out.println(request.getContextPath());
		ck.setPath(request.getContextPath());
		ck.setMaxAge(60*60*24*100);
		response.addCookie(ck);
		
	}
	
	response.sendRedirect("main.jsp");
}
else{

	JavascriptUtil.jsAlertLocation("아이디와 비밀번호를 다시 입력해주세요!","main.jsp", out);
	return;
} 
%>