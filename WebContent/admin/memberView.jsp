<%@page import="model.MembershipDTO"%>
<%@page import="model.MembershipDAO"%>
<%@page import="model.BbsDTO"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "isLogin.jsp" %><!-- 필수파라미터 체크로직  -->
<%
/*
검색후 파라미터 처리를 위한 추가부분
	: 리스트에서 검색후 상세보기 , 그리고 다시 리스트보기를 
	눌렀을때 검색이 유지되도록 처리하기위한 코드삽입
*/
String searchColumn  = request.getParameter("searchColumn");
String searchWord  = request.getParameter("searchWord");
String queryStr = "";
if(searchWord!=null){
	queryStr += "searchColumn=" + searchColumn+"&searchWord="+searchWord+"&";
}
//3페이지에서 상세보기했다면 리스트로 돌아갈때도 3페이지로 가야한다.
String nowPage = request.getParameter("nowPage");
if(nowPage == null || nowPage.equals(""))
	nowPage = "1";
queryStr += "&nowPage=" + nowPage;


String id = request.getParameter("id");
MembershipDAO dao = new MembershipDAO(application);

//게시물을 가져와서 DTO객체로 반환
MembershipDTO dto = dao.selectView(id);   

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
	<!-- /.content-wrapper -->
	<div id="content-wrapper">
      	<div class="container-fluid">
			<!-- 게시판내용 -->
        	<div class="pt-3 pl-3 pr-3">
				<h3><a href="memberList.jsp">회원관리 / </a><small>회원정보 / <%=id %></small></h3>

					<div class="row mt-3 mr-1">
						<table class="table table-bordered">
							<colgroup>
								<col width="15%" />
								<col width="20%" />
								<col width="15%" />
								<col width="20%" />
								<col width="15%" />
								<col width="15%" />
							</colgroup>
							<tbody>
								<tr>
									<th class="text-center table-active align-middle">이름</th>
									<td><%=dto.getName() %></td>
									<th class="text-center table-active align-middle">아이디</th>
									<td><%=dto.getId() %></td>
									<th class="text-center table-active align-middle">비밀번호</th>
									<td><%=dto.getPass() %></td>
								</tr>
								<tr>
									<th class="text-center table-active align-middle">전화번호</th>
									<td><%=dto.getTel() %></td>
									<th class="text-center table-active align-middle">핸드폰번호</th>
									<td><%=dto.getPhone() %></td>
									<th class="text-center table-active align-middle">이메일</th>
									<td><%=dto.getEmail() %></td>
								</tr>
								<tr>
									<th class="text-center table-active align-middle">우편번호</th>
									<td><%=dto.getZip() %></td>
									<th class="text-center table-active align-middle">주소</th>
									<td colspan="4"><%=dto.getAddr() %></td>
								</tr>
								<tr>
									<th class="text-center table-active align-middle">등록일</th>
									<td><%=dto.getRegidate() %></td>
									<th class="text-center table-active align-middle">회원등급</th>
									<td>
										<%
										String grade="";
										switch(dto.getGrade()){
										case "10":
											grade = "관리자";
											break;
										case "1":
											grade = "회원";
											break;
										default:
											grade = "???";
										}
										%>
										<%=grade%>
									</td> 
									<th class="text-center table-active align-middle">이메일 수신동의</th>
									<td ><%=dto.getEmailcheck() %></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="row mb-3">
				<div class="col text-right pr-4">
					<button type="button" class="btn btn-secondary"
						onclick="location.href='memberEdit.jsp?id=<%=dto.getId()%>';">수정하기</button>
					<button type="button" class="btn btn-success"
						onclick="isDelete();">삭제하기</button>
					<button type="button" class="btn btn-warning" onclick="location.href='memberList.jsp?<%=queryStr %>';">리스트보기</button>
				</div>
				<form name="deleteFrm">
					<input type="hidden" name="id" value="<%=dto.getId() %>" />
				</form>
				<script>
					function isDelete() {
						var c = confirm("삭제할까요?");
						if(c){
							var f = document.deleteFrm;
							f.method = "post";
							f.action = "memberDeleteProc.jsp";
							f.submit();
						}
						
					}
				</script>
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