<%@page import="model.MembershipDTO"%>
<%@page import="model.MembershipDAO"%>
<%@page import="util.PagingUtil"%>
<%@page import="model.BbsDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="./isLogin.jsp"%>

<%
request.setCharacterEncoding("UTF-8");

MembershipDAO dao = new MembershipDAO(application);
Map<String,Object> param = new HashMap<String,Object>();

String queryStr = "";

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
List<MembershipDTO> bbs = dao.selectListPage(param); 
dao.close();


%>

<!DOCTYPE html>
<html>
<%@ include file="./common/indexHead.jsp"%>
<body id="page-top">
	<%@ include file="./common/indexTop.jsp"%>
	<div id="wrapper">
		<!-- 사이드바메뉴 -->
		<%@ include file="./common/indexSidebar.jsp"%>
		<!-- /.content-wrapper -->
		<div id="content-wrapper">
			<div class="container-fluid">
				<!-- 게시판내용 -->
				<div class="pt-3 pl-3 pr-3">
					<h3>회원관리</h3>
					<!-- 검색부분 -->
					<div class="row">
						<form class="form-inline ml-auto" name="searchFrm" method="get">
							<div class="form-group">
								<select name="searchColumn" class="form-control">
									<option value="name">이름</option>
									<option value="id">아이디</option>
									<option value="phone">핸드폰번호</option>
									<option value="email">이메일</option>
									<option value="grade">회원등급</option>
								</select>
							</div>
							<div class="input-group">
								<input type="text" name="searchWord" class="form-control" />
								<div class="input-group-btn">
									<button type="submit" class="btn btn-warning">
										<i class='fa fa-search' style='font-size: 20px'></i>
									</button>
								</div>
							</div>
						</form>
					</div>
					<!-- 검색부분 끝-->
					<!-- 회원정보 내용 -->
					<div class="row mt-3">
						<!-- 게시판리스트부분 -->
						<table class="table table-bordered table-hover table-striped">
							<colgroup>
								<col width="7%" />
								<col width="10%" />
								<col width="18%" />
								<col width="20%" />
								
								<col width="20%"  />
								<col width="15%" />
								<col width="5%" />
								<col width="5%" />
							</colgroup>
							<thead>
								<tr style="background-color: rgb(133, 133, 133);"
									class="text-center text-white">
									<th>번호</th>
									<th>이름</th>
									<th>아이디</th>
									<th>핸드폰번호</th>
									
									<th>이메일</th>
									<th>회원등급</th>
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
								
								for(MembershipDTO dto : bbs){
									vNum = totalRecordCount - (((nowPage-1)*pageSize)+countNum++);
								%>
							
								<!-- 리스트반복 start -->
								<tr>
									<td class="text-center"><%=vNum%></td>
									<td class="text-center"><a
										href="memberView.jsp?name=<%=dto.getName()%>&nowPage=<%=nowPage%>&<%=queryStr%>"><%=dto.getName()%></a></td>
									<td class="text-center"><%=dto.getId()%></td> 
									<td class="text-center"><%=dto.getPhone()%></td>
									
									<td class="text-center"><%=dto.getEmail()%></td>
									<td class="text-center"><%=dto.getGrade()%></td>
									<td class="text-center"><button type="button"
											class="btn btn-secondary btn-sm"
											onclick="location.href='memberEdit.jsp?&Id=<%=dto.getId()%>';">수정</button></td>
									<td class="text-center"><button type="button"
											class="btn btn-success btn-sm" id="deletebtn"
											onclick="isDelete();">삭제</button></td>
									<script>
										function isDelete() {
											var c = confirm("삭제할까요?");
											if(c){
												location.href = "deleteProc.jsp?&id=<%=dto.getId()%>";
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
					<div class="row mt-3">
						<div class="col">
							<!-- 페이지번호 부분 -->
							<ul class="pagination justify-content-center">
								<%=PagingUtil.pagingBS4(totalRecordCount, pageSize, blockPage, nowPage, "boardList.jsp?"+queryStr) %> 
							</ul>
						</div>				
					</div>
					
					
					<!-- 회원정보 내용 끝-->
				</div>
				<!-- 게시판내용 끝 -->
			</div>
		</div>
		<!-- Sticky Footer -->
		<footer class="sticky-footer">
			<div class="container my-auto">
				<div class="copyright text-center my-auto">
					<span>Copyright Â© Your Website 2019</span>
				</div>
			</div>
		</footer>
	</div>
	</div>
	<!-- /#wrapper -->
	<!-- Scroll to Top Button-->
	<a class="scroll-to-top rounded" href="#page-top"> <i
		class="fas fa-angle-up"></i>
	</a>
	<!-- Logout Modal-->
	<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">로그아웃</h5>
					<button class="close" type="button" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">Ã</span>
					</button>
				</div>
				<div class="modal-body">로그아웃 버튼을 누르시면 로그아웃이 진행됩니다. 취소하려면 취소버튼을
					누르세요.</div>
				<div class="modal-footer">
					<button class="btn btn-secondary" type="button"
						data-dismiss="modal">취소</button>
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