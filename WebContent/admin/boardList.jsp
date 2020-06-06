<%@page import="java.net.URLEncoder"%>
<%@page import="util.PagingUtil"%>
<%@page import="model.BbsDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./isLogin.jsp" %>
<%@ include file="./isFlag.jsp" %>
<%@ include file="./common/CalendarScript.jsp" %>
<%
//한글깨짐처리 - 검색폼에서 입력된 한글이 전송되기때문
request.setCharacterEncoding("UTF-8");

/* DB연결하기 */
//1.web.xml에 저장된 컨텍스트 초기화 파라미터를 application객체를 통해 가져옴
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MariaConnectURL");
//2.DAO객체 생성 및 DB커넥션
BbsDAO dao = new BbsDAO(drv,url);//DB연결 끝

Map<String,Object> param = new HashMap<String,Object>();//폼값을 받아서 파라미터를 저장할변수 생성
param.put("bname", bname); 


String queryStr = "";//검색시 페이지번호로 쿼리스트링을 넘겨주기 위한 용도(url부분에 뜬다.)
queryStr = "bname=" + bname + "&"; //필수파라미터에 대한 쿼리스트링 처리

//검색어 입력시 전송된 폼값을 받아 Map에 저장
String searchColumn = request.getParameter("searchColumn");
String searchWord = request.getParameter("searchWord");
if(searchWord!=null){
	//검색어를 입력한 경우 Map에 값을 입력함.
	param.put("Column", searchColumn);
	param.put("Word", searchWord);
	//검색어가 있을때 쿼리스트링을 만들어준다.
	queryStr += "searchColumn=" +searchColumn + "&searchWord=" +searchWord+ "&";
}
//board테이블에 입력된 전체 레코드 갯수를 카운트하여 반환받음
int totalRecordCount = dao.getTotalRecordCount(param);

/*****페이지처리 start******/
//web.xml의 초기화 파라미터 가져와서 정수로 변경후 저장
int pageSize = 
Integer.parseInt(application.getInitParameter("PAGE_SIZE"));
int blockPage = 
Integer.parseInt(application.getInitParameter("BLOCK_PAGE"));
int imgpageSize =
Integer.parseInt(application.getInitParameter("IMG_PAGE_SIZE"));

//***페이지계산 변수설정
int totalPage;
int nowPage;
int start;
int end;
//페이지계산 photo는 6개의 자료씩 추출해야한다.
if(bname.equals("photo")){
	//전체페이지수 계산
	totalPage = (int)Math.ceil((double)totalRecordCount/imgpageSize);
	
	/*
	현제페이지번호 : 파라미터가 없을때는 무조건 1페이지로 지정하고, 있을때는 해당 값을
		얻어와서 지정한다. 즉 리스트에 처음 진입했을때는 1페이지가 된다.
	*/
	nowPage = (request.getParameter("nowPage")==null
	|| request.getParameter("nowPage").equals(""))
	? 1 : Integer.parseInt(request.getParameter("nowPage"));
	
	//한페이지에 출력할 게시물의 범위를 결정한다. 
	start = (nowPage-1)*imgpageSize;
	end = imgpageSize;
}else{

	totalPage = (int)Math.ceil((double)totalRecordCount/pageSize);

	nowPage = (request.getParameter("nowPage")==null
	|| request.getParameter("nowPage").equals(""))
	? 1 : Integer.parseInt(request.getParameter("nowPage"));

	start = (nowPage-1)*pageSize;
	end = pageSize;
}//페이지계산끝


//게시물의 범위를 Map컬렉션에 저장하고 DAO로 전달한다.
param.put("start", start); 
param.put("end", end); 
//조건에 맞는 레코드를 select하여 결과셋을 List컬렉션으로 반환받음
List<BbsDTO> bbs = dao.selectListPage(param); 
dao.close();
%>

<!DOCTYPE html>
<html>
	<%@ include file="./common/indexHead.jsp" %>
<body id="page-top">
	<%@ include file="./common/indexTop.jsp" %>
	<div id="wrapper">
		<!-- 사이드바메뉴 -->
		<%@ include file="./common/indexSidebar.jsp" %>
	<div id="content-wrapper">
	<!-- /.content-wrapper -->
      	<div class="container-fluid"><!-- 게시판내용 -->
        	<div class="pt-3 pl-3 pr-3">
			<h3>열린공간 / <small><%=boardTitle %></small></h3>
			<!-- 검색부분 -->
			<div class="row">
			<form class="form-inline ml-auto" name="searchFrm" method="get">	
				<input type="hidden" name="bname" value="<%=bname %>"/> <!--검색시 필수파라미터인 bname이 전달되어야한다.  -->
				<div class="form-group">
					<select name="searchColumn" class="form-control">
						<option value="title">제목</option>
						<option value="content">내용</option>
						<option value="id">작성자</option>
					</select>
				</div>
				<div class="input-group">
					<input type="text" name="searchWord"  class="form-control"/>
					<div class="input-group-btn">
						<button type="submit" class="btn btn-warning">
							<i class='fa fa-search' style='font-size:20px'></i>
						</button>
					</div>
				</div>
			</form>	
			</div>
			<!-- 검색부분 끝-->
			<!-- 자유,공지, 자료게시판리스트부분 -->
		<% if(bname.equals("freeboard")||bname.equals("notice")||bname.equals("dataroom")){%> 
			<div class="row mt-3">
				<table class="table table-bordered table-hover table-striped" style=TABLE-layout:fixed>
				<colgroup>
					<col width="60px"/>
					<col width="*"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="80px"/>
				<%if(bname.equals("dataroom")) {%>
					<col width="60px"/>
				<%} %>
					<col width="80px"/>
					<col width="80px"/>
				</colgroup>				
				<thead>
				<tr style="background-color: rgb(133, 133, 133); " class="text-center text-white">
					<th>번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>작성일</th>
					<th>조회수</th>
				<%if(bname.equals("dataroom")) {%>
					<th>첨부</th>
				<%} %>
					<th>수정</th>
					<th>삭제</th>
				</tr>
				</thead>	
							
				<tbody>
				<% if(bbs.isEmpty()){%> 
					<tr>
						<td colspan="8" align="center" height="100">
							등록된 게시물이 없습니다.
						</td>
					</tr>
				<%}else{ 
					
					int vNum = 0;
					int countNum = 0;
					
					for(BbsDTO dto : bbs){
						vNum = totalRecordCount - (((nowPage-1)*pageSize)+countNum++);
					%>
					<!-- 리스트반복 시작 -->
					<tr>
						<td class="text-center"><%=vNum %></td>
						<td class="text-left" style="text-overflow : ellipsis; overflow : hidden;"><a href="boardView.jsp?num=<%=dto.getNum() %>&nowPage=<%=nowPage%>&<%=queryStr%>"><%=dto.getTitle() %></a></td>
						<td class="text-center"><%=dto.getId() %></td>
						<td class="text-center"><%=dto.getPostdate() %></td>
						<td class="text-center"><%=dto.getVisitcount() %></td>
					<% if(bname.equals("dataroom")) { %>
						
						<td class="text-center">
						<%if(dto.getOfile() != null || dto.getSfile() != null){ %>
						
						<a href="Download2.jsp?oName=<%=URLEncoder.encode(dto.getOfile(),"UTF-8") %>&sName=<%=URLEncoder.encode(dto.getSfile(),"UTF-8") %>">
						<img src="../images/disk.png" width="20" alt="" />
						</a>
						<%} %>
						</td>
					<%} %>	
						<td class="text-center"><button type="button" class="btn btn-secondary btn-sm"
							onclick="location.href='boardEdit.jsp?bname=<%=bname %>&num=<%=dto.getNum()%>';">수정</button></td>
						<td class="text-center"><button type="button" class="btn btn-success btn-sm" id="deletebtn"
							onclick="isDelete();">삭제</button></td>
						<script>
							function isDelete() {
								var c = confirm("삭제할까요?");
								if(c){
									location.href = "deleteProc.jsp?bname=<%=bname %>&num=<%=dto.getNum()%>";
								}
								
							}
						</script>
					</tr>
					<!-- 리스트반복 end -->
				<% 
					} 
				}	%>	
				</tbody>
				</table>
			</div>
			<!-- 자유,공지, 자료게시판리스트부분 끝-->
		<% } else if(bname.equals("photo")) {%>
			<!-- 사진게시판 리스트부분 -->
			<div class="row mt-3">
				<% if(bbs.isEmpty()){%> 
				<table class="table table-bordered table-hover table-striped">
					<tr>
						<td colspan="8" align="center" height="100">
							등록된 게시물이 없습니다.
						</td>
					</tr>
				</table>
				<%}else{ 
					int vNum = 0;
					int countNum = 0;
					
						for(BbsDTO dto : bbs){
							vNum = totalRecordCount - (((nowPage-1)*imgpageSize)+countNum++);
						%>
				<!-- 리스트반복 시작 -->
				<table class="table" style="width: 100px;">
					<tr>
						<td><%=vNum %></td>
					</tr>
					<tr>
						<td><img style="width: 200px; height: 200px" src="../Upload/<%=dto.getSfile() %>" /></td>
					</tr>
					<tr>
						<td>
						<a href="boardView.jsp?num=<%=dto.getNum() %>&nowPage=<%=nowPage%>&<%=queryStr%>">
						<%=dto.getTitle() %></a>
						</td>
					</tr>
					<tr>
						<td><%=dto.getId() %></td>
					</tr>
					<tr>
						<td><%=dto.getPostdate() %></td>
					</tr>
					<tr>
						<td>조회수 : <%=dto.getVisitcount() %></td>
					</tr>
				</table>
					<%   }
					}	%><!-- 리스트반복 끝 -->
			</div>
			<!-- 사진게시판 리스트부분 끝-->
			<%} else{%>
			<!-- 켈린더게시판 리스트부분시작 -->
			<div class="row mt-3">
				<form name="calendarFrm" id="calendarFrm" action="" method="post">
		<div id="content" style="width: 712px;">
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
				<tr>
					<td align="right"><input type="button" value="오늘"
						onclick="javascript:location.href='./boardList.jsp?bname=<%=bname%>' "/>
					</td>
				</tr>
			</table>
			<!--날짜 네비게이션  -->
			<table width="100%" border="0" cellspacing="1" cellpadding="1"
				id="KOO" bgcolor="#F3F9D7" style="border: 1px solid #CED99C">
				<tr>
					<td height="60">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td height="10"></td>
							</tr>
							<tr>
								<td align="center"><a
									href="./boardList.jsp?bname=<%=bname%>&year=<%=year-1%>&amp;month=<%=month%>"
									target="_self"> <b>&lt;&lt;</b>
									<!-- 이전해 -->
								</a> <%if(month > 0 ){ %> <a
									href="./boardList.jsp?bname=<%=bname%>&year=<%=year%>&amp;month=<%=month-1%>"
									target="_self"> <b>&lt;</b>
									<!-- 이전달 -->
								</a> <%} else {%> <b>&lt;</b> <%} %> &nbsp;&nbsp; <%=year%>년 <%=month+1%>월
									&nbsp;&nbsp; <%if(month < 11 ){ %> <a
									href="./boardList.jsp?bname=<%=bname%>&year=<%=year%>&amp;month=<%=month+1%>"
									target="_self"> <!-- 다음달 -->
										<b>&gt;</b>
								</a> <%}else{%> <b>&gt;</b> <%} %> <a
									href="./boardList.jsp?bname=<%=bname%>&year=<%=year+1%>&amp;month=<%=month%>"
									target="_self"> <!-- 다음해 -->
										<b>&gt;&gt;</b>
								</a></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<br>
			<table border="0" cellspacing="1" cellpadding="1" bgcolor="#FFFFFF">
				<THEAD>
					<TR bgcolor="#CECECE">
						<TD width='100px'>
							<DIV align="center">
								<font color="red">일</font>
							</DIV>
						</TD>
						<TD width='100px'>
							<DIV align="center">월</DIV>
						</TD>
						<TD width='100px'>
							<DIV align="center">화</DIV>
						</TD>
						<TD width='100px'>
							<DIV align="center">수</DIV>
						</TD>
						<TD width='100px'>
							<DIV align="center">목</DIV>
						</TD>
						<TD width='100px'>
							<DIV align="center">금</DIV>
						</TD>
						<TD width='100px'>
							<DIV align="center">
								<font color="#529dbc">토</font>
							</DIV>
						</TD>
					</TR>
				</THEAD>
				<TBODY>
					<TR>
						<%
		//처음 빈공란 표시
		for(int index = 1; index < start1 ; index++ ){
		  out.println("<TD >&nbsp;</TD>");
		  newLine++;
		}
		for(int index = 1; index <= endDay; index++){
		       String color = "";
		       
		       if(newLine == 0){          
		    	   color = "RED";
		       }else if(newLine == 6){    
		    	   color = "#529dbc";
		       }else{                     
		    	   color = "BLACK";};

       String sUseDate = Integer.toString(year); 
       sUseDate += Integer.toString(month+1).length() == 1 ? "0" + Integer.toString(month+1) : Integer.toString(month+1);
       sUseDate += Integer.toString(index).length() == 1 ? "0" + Integer.toString(index) : Integer.toString(index);
       
       int iUseDate = Integer.parseInt(sUseDate);
       String backColor = "#EFEFEF";
       if(iUseDate == intToday ) {

             backColor = "#c9c9c9";

       }

       out.println("<TD valign='top' align='left' height='92px' bgcolor='"+backColor+"' nowrap>");

       %>
		<!--여기부터  -->
						<font color='<%=color%>'> <%=index %>
						</font>
						<%

       out.println("<BR>");
       out.println(iUseDate);
       out.println("<BR>");
		//여기까지가 제목넣을 내용
		
       //기능 제거 
       out.println("</TD>");
       newLine++;
       if(newLine == 7)
       {
         out.println("</TR>");
         if(index <= endDay)
         {
           out.println("<TR>");
         }
         newLine=0;
       }
}
//마지막 공란 LOOP
while(newLine > 0 && newLine < 7)
{

  out.println("<TD>&nbsp;</TD>");

  newLine++;

}
%>

					</TR>

				</TBODY>

			</TABLE>

		</DIV>

	</form>
			<!-- 켈린더게시판 리스트부분 끝 -->
			</div>
			<%} %>
			<!-- 글쓰기 버튼부분 시작 -->
			<div class="row">
				<div class="col text-right">
					<button type="button" class="btn btn-primary"
						onclick="location.href='boardWrite.jsp?bname=<%=bname %>';">글쓰기</button>
				</div>
			</div>
			<!-- 글쓰기 버튼부분 끝 -->
			<!-- 페이지번호 부분 -->
			<div class="row mt-3">
				<div class="col">
					<!-- 페이지번호 부분(사진일때) -->
				<% if(bname.equals("photo")){%>
					<ul class="pagination justify-content-center">
						<%=PagingUtil.pagingBS4(totalRecordCount, imgpageSize, blockPage, nowPage, "boardList.jsp?"+queryStr) %> 
					</ul>
				<%}else{ %>
				<!-- 페이지번호 부분(나머지) -->
					<ul class="pagination justify-content-center">
						<%=PagingUtil.pagingBS4(totalRecordCount, pageSize, blockPage, nowPage, "boardList.jsp?"+queryStr) %> 
					</ul>
				<%} %>
				</div>				
			</div>	
			<!-- 페이지번호 부분 끝-->
		</div>
      </div><!-- 게시판내용 끝 -->
      <!-- Sticky Footer -->
      <footer class="sticky-footer">
        <div class="container my-auto">
          <div class="copyright text-center my-auto">
            <span>Copyright Â© Your Website 2019</span>
          </div>
        </div>
      </footer>
		</div>
	</div><!-- /#wrapper -->
	<!-- Scroll to Top Button-->
	<a class="scroll-to-top rounded" href="#page-top">
	  <i class="fas fa-angle-up"></i>
	</a>
	<!-- Logout Modal-->
	<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">로그아웃</h5>
	        <button class="close" type="button" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">Ã</span>
	        </button>
	      </div>
	      <div class="modal-body">로그아웃 버튼을 누르시면 로그아웃이 진행됩니다. 취소하려면 취소버튼을 누르세요.</div>
	      <div class="modal-footer">
	        <button class="btn btn-secondary" type="button" data-dismiss="modal">취소</button>
	        <a class="btn btn-primary" href="logout.jsp">로그아웃</a>
	      </div>
	    </div>
	  </div>
	</div>
	<!-- Bootstrap core JavaScript-->
	<script src="vendor/jquery/jquery.min.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	<!-- Core plugin JavaScript-->
	<script src="vendor/jquery-easing/jquery.easing.min.js"></script>
	<!-- Page level plugin JavaScript-->
	<script src="vendor/chart.js/Chart.min.js"></script>
	<script src="vendor/datatables/jquery.dataTables.js"></script>
	<script src="vendor/datatables/dataTables.bootstrap4.js"></script>
	<!-- Custom scripts for all pages-->
	<script src="js/sb-admin.min.js"></script>
	<!-- Demo scripts for this page-->
	<script src="js/demo/datatables-demo.js"></script>
	<script src="js/demo/chart-area-demo.js"></script>
</body>
</html>