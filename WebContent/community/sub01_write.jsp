<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp"%>
<%@ include file="../space/isLogin.jsp"%>
<%@ include file="../space/isFlag.jsp"%>
<%	
if(bname.equals("employee")&&!(session.getAttribute("USER_GRADE").equals("10"))){
%>	<script>
		alert("관리자만 이용가능 합니다.");
		location.href = "../main/main.jsp";
	</script>
<%	
}
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
				<%@ include file="../include/community_leftmenu.jsp"%>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<img src="<%=img %>" alt="직원자료실" class="con_title" />
					<p class="location">
						<img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;><%=boardTitle %>&nbsp;
					<p>
				</div>
			
				<!-- 게시판내용  -->
				<div>
					<form name="writeFrm" method="post" action = "../Community/Write" onsubmit="return checkValidate(this);" enctype="multipart/form-data">
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
										<input type="file" class="form-control" id='chumFile1' name='chumFile1'/>
									</td>
								</tr>
							</tbody>
						</table>
						<div class="row mb-3">
							<div class="col text-right" style="">
								<!-- 각종 버튼 부분 -->
								<button type="submit" class="btn btn-danger">전송하기</button>
								<button type="reset" class="btn btn-dark">Reset</button>
								<button type="button" class="btn btn-warning" onclick="location.href='../Community/List?bname=<%=bname%>';">리스트보기</button>
							</div>
						</div>
					</form>
				</div>
				<!-- 게시판내용 끝 -->
			</div>
		</div>
		<%@ include file="../include/quick.jsp"%>
	</div>
	</center>
	<%@ include file="../include/footer.jsp"%>
</body>
</html>