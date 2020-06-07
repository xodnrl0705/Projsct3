<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp"%>
<%@ include file="./isLogin.jsp"%>
<%@ include file="./isFlag.jsp"%>

<body>
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
	<%if(bname.equals("photo")){%>

		if(f.chumFile1.value == ""){
			alert("파일첨부를 해주세요");
			return false
		}
	<%}%>
	}
	</script>
	<% 
	if(bname == null || (bname.equals("notice")) || (bname.equals("schedule"))){

		JavascriptUtil.jsAlertLocation("필수파라미터 누락됨(공지사항,일정게시판 글쓰기 안됨) 홈화면으로 이동합니다.", "../main/main.jsp", out);//자바스크립트를 띄어주는 코드 alert
		return;
	}
	%>
	<center>
	<div id="wrap">
		<%@ include file="../include/top.jsp"%>
		<img src="../images/space/sub_image.jpg" id="main_visual" />
		<div class="contents_box">
			<div class="left_contents">
				<%@ include file="../include/space_leftmenu.jsp"%>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<img src="<%=img %>" alt="공지사항" class="con_title" />
					<p class="location">
						<img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;<%=bname%>
					<p>
				</div>
				<!-- 게시판내용  -->
				<div>
				<!-- 정보자료실,사진게시판  -->
				<% if(bname.equals("dataroom") || bname.equals("photo")){%> 
					<form name="writeFrm" method="post" action = "chum_writeProc.jsp" onsubmit="return checkValidate(this);" enctype="multipart/form-data">
						<input type="hidden" name="bname" value="<%=bname %>" />
						<table class="table table-bordered">
							<colgroup>
								<col width="20%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th class="text-center" style="vertical-align: middle;">제목</th>
									<td><input type="text" name="title" id="title"
										class="form-control" />
									</td>
								</tr>
								<tr>
									<th class="text-center" style="vertical-align: middle;">내용</th>
									<td><textarea name="content" id="content" rows="10"
											class="form-control"></textarea>
									</td>
								</tr>
								<tr>
									<th class="text-center" style="vertical-align:middle;">첨부파일</th>
									<td>
										<% if(bname.equals("photo")){%>
											<input type="file" accept="image/*" class="form-control" id='chumFile1' name='chumFile1'/>
										<%}else{%>
											<input type="file" class="form-control" id='chumFile1' name='chumFile1'/>
										<%} %>
									</td>
								</tr>
							</tbody>
						</table>
						<div class="row mb-3">
							<div class="col text-right" style="">
								<!-- 각종 버튼 부분 -->
								<button type="submit" class="btn btn-danger">전송하기</button>
								<button type="reset" class="btn btn-dark">Reset</button>
								<button type="button" class="btn btn-warning" onclick="location.href='sub01_list.jsp?bname=<%=bname%>';">리스트보기</button>
							</div>
						</div>
					</form>
					<!-- 정보자료실,사진 게시판 끝  -->
					<!-- 공지사항,자유 게시판  -->
				<% }else{ %>
					<form name="writeFrm" method="post" action = "writeProc.jsp" onsubmit="return checkValidate(this);">
						<input type="hidden" name="bname" value="<%=bname %>" />
						<table class="table table-bordered">
							<colgroup>
								<col width="20%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th class="text-center" style="vertical-align: middle;">제목</th>
									<td><input type="text" name="title" id="title"
										class="form-control" />
									</td>
								</tr>
								<tr>
									<th class="text-center" style="vertical-align: middle;">내용</th>
									<td><textarea name="content" id="content" rows="10"
											class="form-control"></textarea>
									</td>
								</tr>
							</tbody>
						</table>
						<div class="row mb-3">
							<div class="col text-right" style="">
								<!-- 각종 버튼 부분 -->
								<button type="submit" class="btn btn-danger">전송하기</button>
								<button type="reset" class="btn btn-dark">Reset</button>
								<button type="button" class="btn btn-warning" onclick="location.href='sub01_list.jsp?bname=<%=bname%>';">리스트보기</button>
							</div>
						</div>
					</form>
					<!-- 공지사항,자유 게시판 끝 -->
				<% } %>
				
				</div>
				<!-- 게시판내용 끝 -->
			</div>
		</div>
		<%@ include file="../include/quick.jsp"%>
	</div>


	<%@ include file="../include/footer.jsp"%>
	</center>
</body>
</html>