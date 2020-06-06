<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.multipart.FileRenamePolicy"%>
<%@page import="model.BbsDAO"%>
<%@page import="model.BbsDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 글작성 완료 전 로그인 체크하기 -->
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
String num = null;//번호
String title = null;//제목
String content = null;//내용
String bname = null;//bname

//저장된 파일명을 변경하기 위한 객체 생성
File oldFile = null;
File newFile = null;
String realFileName = null;

try{

	mr = new MultipartRequest(request, saveDirectory, maxPostSize, encoding, policy);

	//서버에 저장된 파일명 가져오기
	String fileName = mr.getFilesystemName("chumFile1");
	
	num = mr.getParameter("num");
	
	title = mr.getParameter("title");
	content = mr.getParameter("content");
	bname = mr.getParameter("bname");
	String orgOfile = mr.getParameter("orgOfile");
	String orgSfile = mr.getParameter("orgSfile");
	
	
	BbsDTO dto = new BbsDTO();
	dto.setNum(num);
	dto.setTitle(title);
	dto.setContent(content);
	System.out.println();
	
	if(fileName != null){
		String nowTime = new SimpleDateFormat("yyyy_MM_dd_H_m_s_S").format(new Date());
		
		int idx = -1;
		idx = fileName.lastIndexOf(".");
		realFileName = nowTime + fileName.substring(idx, fileName.length());
		
		oldFile = new File(saveDirectory+oldFile.separator+fileName);
		newFile = new File(saveDirectory+oldFile.separator+realFileName);
		
		//저장된 파일명을 변경한다.
		oldFile.renameTo(newFile);
		//파일명들 저장
		dto.setOfile(mr.getOriginalFileName("chumFile1"));
		dto.setSfile(realFileName);
	}else{
		dto.setOfile(orgOfile);
		dto.setSfile(orgSfile);
	}
	
	
	BbsDAO dao = new BbsDAO(application);
	//DTO객체를 DAO로 전달하여 게시물 업데이트(수정)
	int affected = dao.updatechumEdit(dto); 
	if(affected==1){
		response.sendRedirect("boardView.jsp?bname="+bname+"&num="+dto.getNum());
	}else{
		%>
			<script>
				alert("수정하기에 실패하였습니다.");
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
		request.getRequestDispatcher("boardEdit.jsp").forward(request,response);
	}
	%>
	
	
