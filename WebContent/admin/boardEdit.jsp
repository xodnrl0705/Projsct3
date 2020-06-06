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
<%
request.setCharacterEncoding("UTF-8");
//폼값 받기 - 파라미터로 전달된 게시물의 일련번호
String num = request.getParameter("num");
BbsDAO dao = new BbsDAO(application);

//게시물을 가져와서 DTO객체로 반환
BbsDTO dto = dao.selectView(num); 

dao.close();
%>

<!DOCTYPE html>
<html>
	<%@ include file="./common/indexHead.jsp" %>
<body id="page-top">
<script>
function checkValidate(f) {
	if(f.title.value ==""){
		alert("제목을 입력해주세요");
		f.title.focus();
		return false
	}
	if(f.content.value ==""){
		alert("내용을 입력해주세요");
		f.content.focus();
		return false
	}
	if(bname.equals("photo")))
		if(!(f.chumFile1.value)){
			alert("파일을 넣어주세요");
			return false
		}
}
</script>


	<%@ include file="./common/indexTop.jsp" %>
	<div id="wrapper">
		<!-- 사이드바메뉴 -->
		<%@ include file="./common/indexSidebar.jsp" %>
	<div id="content-wrapper">
	
      	<div class="container-fluid"><!-- 게시판내용 -->
        	<div class="pt-3 pl-3 pr-3">
        	<h3>게시판 - <small>Edit(수정)</small></h3>
        	<div class="pt-3 pl-3 pr-3">
        	<!-- 정보자료실 게시판  -->
        	<%if(bname.equals("dataroom")||bname.equals("photo")) {%>
				<form name="writeFrm" method="post" action="chum_editProc.jsp" onsubmit="return checkValidate(this);" enctype="multipart/form-data">
					<input type="hidden" name="num" value="<%=dto.getNum() %>"/>
					<input type="hidden" name="bname" value="<%=bname %>"/> <!--검색시 필수파라미터인 bname이 전달되어야한다.  -->
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
									<input type="text" class="form-control" name="title" id="title" value="<%=dto.getTitle()%>"/>
								</td>
							</tr>
							<tr>
								<th class="text-center" 
									style="vertical-align:middle;">내용</th>
								<td>
									<textarea rows="10" name="content" id="content" 
										class="form-control" ><%=dto.getContent()%></textarea>
								</td>
							</tr>
							<tr>
								<th class="text-center" 
									style="vertical-align:middle;">첨부파일</th>
								<td>
								<%if(dto.getOfile() != null || dto.getSfile() != null){ %>
									<input type="hidden" class="form-control" id='orgOfile' name='orgOfile' 
									value = "<%=dto.getOfile()%>"/>
									<input type="hidden" class="form-control" id='orgSfile' name='orgSfile' 
									value = "<%=dto.getSfile()%>"/>
									<input type="file" class="form-control" id='chumFile1' name='chumFile1'
									value = "" />
								<%}else{ %>
									<input type="file" class="form-control" id='chumFile1' name='chumFile1'/>
								<%} %>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="row mb-3">
						<div class="col text-right">
							<button type="submit" class="btn btn-danger">전송하기</button>
							<button type="reset" class="btn btn-dark">Reset</button>
							<button type="button" class="btn btn-warning" onclick="location.href='boardList.jsp?bname=<%=bname %>';">리스트보기</button>
						</div>
					</div>
				</form>	
				<!-- 정보자료실 게시판 끝  -->
				<!-- 나머지 게시판  -->
				<%}else{%>
				<form name="writeFrm" method="post" action="editProc.jsp" onsubmit="return checkValidate(this);">
					<input type="hidden" name="num" value="<%=dto.getNum() %>"/>
					<input type="hidden" name="bname" value="<%=bname %>"/> <!--검색시 필수파라미터인 bname이 전달되어야한다.  -->
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
									<input type="text" class="form-control" name="title" id="title" value="<%=dto.getTitle()%>"/>
								</td>
							</tr>
							<tr>
								<th class="text-center" 
									style="vertical-align:middle;">내용</th>
								<td>
									<textarea rows="10" name="content" id="content" 
										class="form-control" ><%=dto.getContent()%></textarea>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="row mb-3">
						<div class="col text-right">
							<button type="submit" class="btn btn-danger">전송하기</button>
							<button type="reset" class="btn btn-dark">Reset</button>
							<button type="button" class="btn btn-warning" onclick="location.href='boardList.jsp?bname=<%=bname %>';">리스트보기</button>
						</div>
					</div>
				</form>	
				<%} %>
				<!-- 나머지 게시판 끝 -->
			</div>	
			</div>
      	</div>
      	<!-- 게시판내용 끝 -->
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