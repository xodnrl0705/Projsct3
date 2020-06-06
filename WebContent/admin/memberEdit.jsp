<%@page import="model.MembershipDTO"%>
<%@page import="model.MembershipDAO"%>
<%@page import="model.BbsDTO"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file ="isLogin.jsp" %><!-- 필수파라미터 체크로직  -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="../bootstrap4.4.1/jquery/jquery-3.5.1.min.js"></script>
<%
//폼값받기
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
<script>
//우편번호검색 API
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                // 조합된 참고항목을 해당 필드에 넣는다.
                document.getElementById("sample6_extraAddress").value = extraAddr;
            
            } else {
                document.getElementById("sample6_extraAddress").value = '';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('zip').value = data.zonecode;
            document.getElementById("addr").value = addr;
            
        }
    }).open();
}

$(function() {
	$('#editBtn').click(function(){//버튼을 클릭했을때
		if(!$('#name').val()){
			alert('이름을 입력해주세요!');
			document.getElementById('name').focus();
			return false;
		}
	
		var pw = $("#pass").val();
		var num = pw.search(/[0-9]/g);
		var eng = pw.search(/[a-z]/ig);

	 	if(pw.length < 4 || pw.length > 12){
			alert("4자리 ~ 12자리 이내로 입력해주세요.");
	  		return false;
	 	}else if(pw.search(/\s/) != -1){
	  		alert("비밀번호는 공백 없이 입력해주세요.");
	  		return false;
	 	}else if(num < 0 || eng < 0 ){
	  		alert("영문,숫자를 혼합하여 입력해주세요.");
	  		return false;
	 	}
	 	
		if(!$('#tel').val()){
			alert('전화번호를 입력해주세요!');
			document.getElementById('tel').focus();
			return false;
		}
		if(!$('#phone').val()){
			alert('핸드폰번호를 입력해주세요!');
			document.getElementById('phone').focus();
			return false;
		}
		if(!$('#email').val()){
			alert('이메일을 입력해주세요!');
			
			document.getElementById('email').focus();
			return false;
		}
		if(!$('#addr').val()){
			alert('주소를 입력해주세요!');
			document.getElementById('addr').focus();
			return false;
		}
		
		var s_url = "./memberEditProc.jsp";
		var s_params = $('#editFrm').serialize();
		
		$.post(
			//인자1 : 전송할 서버의 URL(경로)
			s_url,
			//인자2 : 파라미터(JSON형태로 조립)
			s_params,
		
			//인자3 : 요청후 성공시 실행되는 콜백메소드
			function(resData){
				var d = JSON.parse(resData);
				if(d.result==1){
					alert(d.message);
					location.href = "memberView.jsp?id=<%=dto.getId()%>";
				}
				else{
					alert(d.message);
				}
				
			}
		);
	});
});
function checkFrm(){
	//<form태그의 DOM요소를 가져와서...
	var f = document.getElementById("editFrm");
	//method와 action속성 JS에서 부여한다.
	f.method = "post";
	f.action = "./memberEditProc.jsp";
}

$(function() {//등급 select에서 선택할시 발생되는 change
	$('#grade_check').change(function() {
		
		var value = $('#grade_check option:selected').val(); //선택한이메일의 value값을 읽어온다.
		//alert("선택한 항목의 text:"+text+", value:"+value);
		
		if(value == '1'){
			$('#grade').val('1');
		}
		else{ //그 외 경우
			$('#grade').val(10);
		}
	});
	/* $('#emailchecked').click(function() {
		
		var value = $('#emailchecked').val(); //선택한이메일의 value값을 읽어온다.
		//alert("선택한 항목의 text:"+text+", value:"+value);
		
		if(value == 'yes'){
			$('#emailcheck').val('yes');
		}
		else if (value == ''){ //그 외 경우
			$('#emailcheck').val('no');
		}
	}); */
	
});




</script>


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
						<form id="editFrm" onsubmit="return checkFrm();" style="width: 100%;">
							<table class="table table-bordered" >
								<colgroup>
									<col width="20%" />
									<col width="30%" />
									<col width="20%" />
									<col width="30%" />

								</colgroup>
								<tbody>
									<tr>
										<th class="text-center table-active align-middle">이름</th>
										<td><input type="text" class="form-control" name="name"
											id="name" value="<%=dto.getName()%>" /></td>
										<th class="text-center table-active align-middle">아이디</th>
										<td><input type="text" class="form-control" name="id"
											id="id" value="<%=dto.getId()%>" readonly /></td>
									</tr>
									<tr>
										<th class="text-center table-active align-middle">등록일</th>
										<td><input type="text" class="form-control"
											name="regidate" id="regidate" value="<%=dto.getRegidate()%>"
											readonly /></td>
										<th class="text-center table-active align-middle">비밀번호</th>
										<td><input type="text" class="form-control" name="pass"
											id="pass" value="<%=dto.getPass()%>" /></td>
									</tr>
									<tr>
										<th class="text-center table-active align-middle">전화번호</th>
										<td><input type="text" class="form-control" name="tel"
											id="tel" value="<%=dto.getTel()%>" /></td>
										<th class="text-center table-active align-middle">핸드폰번호</th>
										<td><input type="text" class="form-control" name="phone"
											id="phone" value="<%=dto.getPhone()%>" /></td>
									</tr>
									<tr>
										<th class="text-center table-active align-middle">이메일</th>
										<td><input type="text" class="form-control" name="email"
											id="email" value="<%=dto.getEmail()%>" /></td>
										<th class="text-center table-active align-middle">등급</th>
										<td>
											<%
										String s1 = "", s2="";
										if(dto.getGrade().equals("10")){
											s1 = "selected ";
										}else{
											s2 = "selected ";
										}
										
										%> 
										<select class="mt-2" name="grade_check" id="grade_check" >
											<option <%=s1 %> value="10">관리자</option>
											<option <%=s2 %> value="1">회원</option>
										</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
										
										</td>
									</tr>

									<tr>
										<th class="text-center table-active align-middle">우편번호</th>
										<td><input type="text" class="form-control" name="zip"
											id="zip" value="<%=dto.getZip()%>" readonly /> <a
											href="javascript:;" title="새 창으로 열림"
											onclick="execDaumPostcode();">[우편번호검색]</a></td>
										<th class="text-center table-active align-middle">주소</th>
										<td><input type="text" class="form-control" name="addr"
											id="addr" value="<%=dto.getAddr()%>" /> <input type="hidden"
											name="sample6_extraAddress" id="sample6_extraAddress"
											placeholder="참고항목" class="join_input"
											style="width: 550px; margin-top: 5px;" /></td>
									</tr>
								</tbody>
							</table>
							<input type="hid#den" name="grade" id="grade" value="<%=dto.getGrade()%>">
						</form>
					</div>
					<div class="row mb-3">
						<div class="col text-right">
							<button type="button" id ="editBtn" class="btn btn-danger">전송하기</button>
							<button type="reset" class="btn btn-dark">Reset</button>
							<button type="button" class="btn btn-warning" onclick="location.href='memberList.jsp?id=<%=id %>';">리스트보기</button>
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