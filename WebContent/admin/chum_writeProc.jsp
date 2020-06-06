<%@page import="util.JavascriptUtil"%>
<%@page import="model.BbsDAO"%>
<%@page import="model.BbsDTO"%>
<%@page import="java.util.Date"%>
<%@page import="java.io.File"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.multipart.FileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="./isLogin.jsp" %>

<%
//한글깨짐처리(post로 폼값전송시 깨짐 부분 처리)
request.setCharacterEncoding("UTF-8");

//파일 업로드를 위한 MultipartRequest객체의 파라미터 준비
String saveDirectory = application.getRealPath("/Upload");//1.파일을 업로드할 서버의 물리적경로 가져오기
int maxPostSize = 1024 * 5000;//2. 업로드할 파일의 최대용량 설정(바이트단위)
String encoding = "UTF-8"; //3.인코딩 타입 설정
FileRenamePolicy policy = new DefaultFileRenamePolicy();//4.파일명 중복처리

//전송된 폼값을 저장하기 위한 변수생성
MultipartRequest mr = null;//파일업로드를 위한 객체
String title = null;//이름
String content = null;//제목
String bname = null;//bname

//저장된 파일명을 변경하기 위한 객체 생성
File oldFile = null;
File newFile = null;
String realFileName = null;

try{
	/*
	1~4번까지 준비한 인자를 이용하여 MultipartRequest객체를 생성한다.
	객체가 정상적으로 생성되면 파일업로드는 완료된다.
	만약 예외가 발생한다면 주로 최대용량 초과 혹은 디렉토리 경로가
	잘못된 경우가 대부분이다.
	*/
	
	mr = new MultipartRequest(request, saveDirectory, maxPostSize, encoding, policy);
	/*
		서버에 저장된 파일명 변경하기
		: 객체를 생성함과 동시에 업로드는 완료되므로 이미 저장된
		파일에 대해 파일명을 변경한다.
		이유는 한글이나 다른 언어 즉 유니코드로 구성된 파일명은
		서버에서 문제가 될 소지가 있으므로 숫자 혹은 영문으로
		변경하는 것이 좋다.
	*/
	//////추가부분 start///////////////////////
	
	//서버에 저장된 파일명 가져오기
	String fileName = mr.getFilesystemName("chumFile1");
	
	//파일명을 변경하기 위해 현재시간을 가져온다.
	/*
		아래 서식문자중 대문자 S는 초를 1/1000단위로 가져옴.(0~999)
	*/
	String nowTime = new SimpleDateFormat("yyyy_MM_dd_H_m_s_S").format(new Date());
	
	//파일의 확장자를 가져옴
	/*
		파일명에 닷(.)이 2개이상 포함될수 있으므로 lastIndexOf()로
		마지막에 있는 점을 찾아온다. 해당 인덱스를 통해 확장자를
		가져온다.
	*/
	
	int idx = -1;

	if(fileName != null){
		idx = fileName.lastIndexOf(".");
		realFileName = nowTime + fileName.substring(idx, fileName.length());
		oldFile = new File(saveDirectory+oldFile.separator+fileName);
		newFile = new File(saveDirectory+oldFile.separator+realFileName);

		oldFile.renameTo(newFile);
	}
	
	title = mr.getParameter("title");
	content = mr.getParameter("content");
	bname = mr.getParameter("bname");

	BbsDTO dto = new BbsDTO(); 
	dto.setTitle(title);
	dto.setContent(content);
	dto.setId(session.getAttribute("USER_ID").toString());
	dto.setBname(bname);
	dto.setOfile(mr.getOriginalFileName("chumFile1"));
	dto.setSfile(realFileName);
	BbsDAO dao = new BbsDAO(application);
	int affected = dao.insertchumWrite(dto);  
	if(affected == 1){//글쓰기 성공
		response.sendRedirect("boardList.jsp?bname="+bname);
	}
	else{//글쓰기 실패
		%>
		<script>
			alert("글쓰기에 실패하였습니다.");
			history.go(-1);
		</script>
		<%
	}
}catch(Exception e){
	%>
	<script>
		alert("글쓰기에 실패하였습니다.");
		history.go(-1);
	</script>
	<%
		request.getRequestDispatcher("boardWrite.jsp?bname="+bname).forward(request,response);
	}
	%>