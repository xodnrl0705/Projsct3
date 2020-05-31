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

boolean idCheck = false;
idCheck = dao.idCheck(id);

%>
<script type ="text/javascript">
function idUse(){
	
	if(<%=idCheck%> == false){
		opener.document.loginfrm.idcheck.value = "<%= id%>";
		self.close();
	}
	else{
		opener.document.loginfrm.id.value = "";
		self.close();		
	}

} 
</script>
</head>
<body>
	<% if(idCheck == false){ %>  
	<h3>'<%=id %>'는 사용할수 있는 아이디입니다.</h3>
	<form name="overlapFrm">
		<input type="button" value="아이디사용하기" onclick="idUse();"	/>
	</form>
	<%}else{ %>
	<h3>'<%=id %>'는 이미 등록된 아이디입니다.</h3>
	<form name="overlapFrm">
		<input type="button" value="아이디사용하기" onclick="idUse();"	/>
	</form>
	<%} %>
</body>
</html>