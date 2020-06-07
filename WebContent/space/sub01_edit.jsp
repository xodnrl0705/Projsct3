<%@page import="model.BbsDTO"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp"%>
<%@ include file="./isLogin.jsp"%>
<%@ include file="./isFlag.jsp"%>
<%
if(bname == null || (bname.equals("notice")) || (bname.equals("schedule"))){

	JavascriptUtil.jsAlertLocation("필수파라미터 누락됨(공지사항,일정게시판 글쓰기 안됨) 홈화면으로 이동합니다.", "../main/main.jsp", out);//자바스크립트를 띄어주는 코드 alert
	return;
}
//폼값 받기 - 파라미터로 전달된 게시물의 일련번호
String num = request.getParameter("num");
BbsDAO dao = new BbsDAO(application);

//게시물을 가져와서 DTO객체로 반환
BbsDTO dto = dao.selectView(num); 

dao.close();


%>
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
	}
</script>

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
					<!-- 자료첨부 게시판  -->
					<% if(bname.equals("dataroom") || bname.equals("photo")){%>
					<form name="writeFrm" method="post" action = "chum_editProc.jsp"  onsubmit="return checkValidate(this);" enctype="multipart/form-data">
						<input type="hidden" name="num" value="<%=dto.getNum() %>" />
						<input type="hidden" name="bname" value="<%=bname %>" />
						<table class="table table-bordered" style=TABLE-layout:fixed>
							<colgroup>
								<col width="20%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th class="text-center" style="vertical-align: middle;">제목</th>
									<td><input type="text" name="title" id="title" value="<%=dto.getTitle()%>"
										class="form-control" />
									</td>
								</tr>
								<tr>
									<th class="text-center" style="vertical-align: middle;">내용</th>
									<td><textarea name="content" id="content" rows="10" 
											class="form-control"><%=dto.getContent()%></textarea>
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
										<% if(bname.equals("photo")){%>
											<input type="file" accept="image/*" class="form-control" id='chumFile1' name='chumFile1'/>
										<%}else{%>
											<input type="file" class="form-control" id='chumFile1' name='chumFile1' value=""/>
										<%} %>
									<%}else{ %>
										<% if(bname.equals("photo")){%>
											<input type="file" accept="image/*" class="form-control" id='chumFile1' name='chumFile1'/>
										<%}else{%>
											<input type="file" class="form-control" id='chumFile1' name='chumFile1'/>
										<%} %>
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
								<button type="button" class="btn btn-warning"
									onclick="location.href='sub01_list.jsp?bname=<%=bname%>';">리스트보기</button>
							</div>
						</div>
					</form>
					<!-- 자료첨부 게시판 끝 -->
					<%}else if(bname.equals("freeboard")){ %>
					<!-- 자유 게시판(공지사항은 못씀)  -->
					<form name="writeFrm" method="post" action = "editProc.jsp"  onsubmit="return checkValidate(this);">
						<input type="hidden" name="num" value="<%=dto.getNum() %>" />
						<input type="hidden" name="bname" value="<%=bname %>" />
						<table class="table table-bordered">
							<colgroup>
								<col width="20%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th class="text-center" style="vertical-align: middle;">제목</th>
									<td><input type="text" name="title" id="title" value="<%=dto.getTitle()%>"
										class="form-control" />
									</td>
								</tr>
								<tr>
									<th class="text-center" style="vertical-align: middle;">내용</th>
									<td><textarea name="content" id="content" rows="10" 
											class="form-control"><%=dto.getContent()%></textarea>
									</td>
								</tr>
							</tbody>
						</table>
						<div class="row mb-3">
							<div class="col text-right" style="">
								<!-- 각종 버튼 부분 -->
								<button type="submit" class="btn btn-danger">전송하기</button>
								<button type="reset" class="btn btn-dark">Reset</button>
								<button type="button" class="btn btn-warning"
									onclick="location.href='sub01_list.jsp?bname=<%=bname%>';">리스트보기</button>
							</div>
						</div>
					</form>
					<!-- 자유 게시판 끝 -->
					<%} %>
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