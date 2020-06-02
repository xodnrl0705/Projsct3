<%@page import="util.PagingUtil"%>
<%@page import="model.BbsDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./islogin.jsp" %>
<%@ include file="./isFlag.jsp" %>
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

//전체페이지수 계산
int totalPage = (int)Math.ceil((double)totalRecordCount/pageSize);

/*
현제페이지번호 : 파라미터가 없을때는 무조건 1페이지로 지정하고, 있을때는 해당 값을
	얻어와서 지정한다. 즉 리스트에 처음 진입했을때는 1페이지가 된다.
*/
int nowPage = (request.getParameter("nowPage")==null
|| request.getParameter("nowPage").equals(""))
? 1 : Integer.parseInt(request.getParameter("nowPage"));

//한페이지에 출력할 게시물의 범위를 결정한다. 
int start = (nowPage-1)*pageSize;
int end = pageSize;

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
			<h3><%=boardTitle %></h3>
			<div class="row">
			<!-- 검색부분 -->
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
			<div class="row mt-3">
				<!-- 게시판리스트부분 -->
				<table class="table table-bordered table-hover table-striped">
				<colgroup>
					<col width="60px"/>
					<col width="*"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="80px"/>
					<col width="60px"/>
				</colgroup>				
				<thead>
				<tr style="background-color: rgb(133, 133, 133); " class="text-center text-white">
					<th>번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>작성일</th>
					<th>조회수</th>
					<th>첨부</th>
				</tr>
				</thead>				
				<tbody>
				<% if(bbs.isEmpty()){%> 
					<tr>
						<td colspan="6" align="center" height="100">
							등록된 게시물이 없습니다.
						</td>
					</tr>
				<%}else{ 
					
					int vNum = 0;
					int countNum = 0;
					
					for(BbsDTO dto : bbs){
						vNum = totalRecordCount - (((nowPage-1)*pageSize)+countNum++);
					%>
					<!-- 리스트반복 start -->
					<tr>
						<td class="text-center"><%=vNum %></td>
						<td class="text-left"><a href="BoardView.jsp?num=<%=dto.getNum() %>&nowPage=<%=nowPage%>&<%=queryStr%>"><%=dto.getTitle() %></a></td>
						<td class="text-center"><%=dto.getId() %></td>
						<td class="text-center"><%=dto.getPostdate() %></td>
						<td class="text-center"><%=dto.getVisitcount() %></td>
						<td class="text-center"><i class="material-icons" style="font-size:20px">attach_file</i></td>
					</tr>
					<!-- 리스트반복 end -->
				<% 
					} 
				}	%>	
				</tbody>
				</table>
			</div>
			<div class="row">
				<div class="col text-right">
					<button type="button" class="btn btn-primary"
						onclick="location.href='boardWrite.jsp?bname=<%=bname %>';">글쓰기</button>
				</div>
			</div>
			<div class="row mt-3">
				<div class="col">
					<!-- 페이지번호 부분 -->
					<ul class="pagination justify-content-center">
						<%=PagingUtil.pagingBS4(totalRecordCount, pageSize, blockPage, nowPage, "boardList.jsp?"+queryStr) %> 
					</ul>
				</div>				
			</div>	
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