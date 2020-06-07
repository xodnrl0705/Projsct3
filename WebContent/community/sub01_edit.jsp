<%@page import="model.BbsDTO"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
		<img src="../images/community/sub_image.jpg" id="main_visual" />
		<!-- contents_box -->
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
					<!-- 자료첨부 게시판  -->
					<form name="writeFrm" method="post" action = "../Community/Edit"  onsubmit="return checkValidate(this);" enctype="multipart/form-data">
						<input type="hid#den" name="num" value="${num }" />
						<input type="hid#den" name="bname" value="<%=bname %>" />
						<!-- 
						기존에 등록한 파일이 있는경우 수정시 첨부하지 않으면 기존파일을 
						유지해야하므로 별도의 hidden폼이 필요하다
						즉 새로운 파일을 등록하면 새로운값으로 업데이트하고
						파일을 등록하지 않으면 기존파일명으로 데이터를 유지하게된다
						 -->
						<input type="hid#den"  name="originalfile" value="${dto.ofile }"/>
						
						<table class="table table-bordered" style=TABLE-layout:fixed>
							<colgroup>
								<col width="20%" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th class="text-center" style="vertical-align: middle;">제목</th>
									<td><input type="text" name="title" id="title" value="${dto.title}"
										class="form-control" />
									</td>
								</tr>
								<tr>
									<th class="text-center" style="vertical-align: middle;">내용</th>
									<td><textarea name="content" id="content" rows="10" 
											class="form-control">${dto.content}</textarea>
									</td>
								</tr>
								<tr>
									<th class="text-center" 
										style="vertical-align:middle;">첨부파일</th>
									<td>
									첨부파일명 : ${dto.ofile }
									<input type="file" class="form-control" name="chumFile1" />
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
									onclick="location.href='../Community/List?=${queryStr }';">리스트보기</button>
							</div>
						</div>
					</form>
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