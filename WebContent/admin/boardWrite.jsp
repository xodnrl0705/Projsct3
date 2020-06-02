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

<!DOCTYPE html>
<html>
	<%@ include file="./common/indexHead.jsp" %>
<body id="page-top">
	<%@ include file="./common/indexTop.jsp" %>
	<div id="wrapper">
		<!-- 사이드바메뉴 -->
		<%@ include file="./common/indexSidebar.jsp" %>
	<div id="content-wrapper">
	
      	<div class="container-fluid"><!-- 게시판내용 -->
        	<div class="pt-3 pl-3 pr-3">
        	<h3>게시판 - <small>Write(작성)</small></h3>
        	<div class="pt-3 pl-3 pr-3">
				<form name="writeFrm" method="post" action="writeProc.jsp" onsubmit="return checkValidate(this);">
					<table class="table table-bordered table-striped">
						<colgroup>
							<col width="20%"/>
							<col width="*"/>
						</colgroup>
						<tbody>
							<tr>
								<th class="text-center" 
									style="vertical-align:middle;">제목</th>
								<td>
									<input type="text" class="form-control" name="title" />
								</td>
							</tr>
							<tr>
								<th class="text-center" 
									style="vertical-align:middle;">내용</th>
								<td>
									<textarea rows="10" name="content"
										class="form-control" ></textarea>
								</td>
							</tr>
							<tr>
								<th class="text-center"
									style="vertical-align:middle;">첨부파일</th>
								<td>
									<input type="file" class="form-control" />
								</td>
							</tr>
						</tbody>
					</table>
					<div class="row mb-3">
						<div class="col text-right">
							<!-- 각종 버튼 부분 -->
							<!-- <button type="button" class="btn">Basic</button> -->
							<!-- <button type="button" class="btn btn-primary" 
								onclick="location.href='BoardWrite.jsp';">글쓰기</button> -->
							<!-- <button type="button" class="btn btn-secondary">수정하기</button>
							<button type="button" class="btn btn-success">삭제하기</button>
							<button type="button" class="btn btn-info">답글쓰기</button>
							<button type="button" class="btn btn-light">Light</button>
							<button type="button" class="btn btn-link">Link</button> -->
							<button type="submit" class="btn btn-danger">전송하기</button>
							<button type="reset" class="btn btn-dark">Reset</button>
							<button type="button" class="btn btn-warning" onclick="location.href='boardList.jsp?bname=<%=bname %>';">리스트보기</button>
						</div>
					</div>
				</form>	
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
		</div><!-- /.content-wrapper -->
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