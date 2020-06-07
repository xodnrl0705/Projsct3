<%@page import="java.net.URLEncoder"%>
<%@page import="model.BbsDTO"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	<center>
	<!-- wrap -->
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
				<!-- view부분  -->
				<div>
					<table class="table table-bordered" style=TABLE-layout:fixed>
						<colgroup>
							<col width="20%" />
							<col width="30%" />
							<col width="20%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th class="text-center" style="vertical-align: middle;">아이디</th>
								<td>${dto.id }</td>
								<th class="text-center" style="vertical-align: middle;">작성일</th>
								<td>${dto.postdate }</td>
							</tr>
							<tr>
								<th class="text-center" style="vertical-align: middle;">작성자</th>
								<td>${dto.name }</td>
								<th class="text-center" style="vertical-align: middle;">조회수</th>
								<td>${dto.visitcount}</td>
							</tr>
							<tr>
								<th class="text-center" style="vertical-align: middle;">제목</th>
								<td colspan="3">${dto.title}</td>
							</tr>
							<tr>
								<th class="text-center" style="vertical-align: middle; ">내용</th>
								<td colspan="3" class="align-middle"  >
								${dto.content }
							</td>
							</tr>
							<tr>
								<th class="text-center" style="vertical-align: middle;">첨부파일</th>
								<td colspan="3">
							<!-- 첨부파일이 있는 경우에만 디스플레이 함 -->
							<c:if test='${not empty dto.ofile }'>
								${dto.ofile }
								<a href="./Download?filename=${dto.ofile }&num=${dto.num }">
									[다운로드]
								</a>
							</c:if>
								</td>
							</tr>
						</tbody>
					</table>
					<!-- 각종버튼부분 -->
					<div class="row mb-3">
						<div class="col text-right pr-3">
						<c:if test='${USER_ID eq dto.id }'>
						<!-- 자기아이디일때만 사용가능 -->
							<button type="button" class="btn btn-secondary"
								onclick="location.href='../Community/Edit?${queryStr}&num=${dto.num }';">수정하기</button>
							<button type="button" class="btn btn-success"      
								onclick="location.href='../Community/Delete?${queryStr}&num=${dto.num }';">삭제하기</button>
						</c:if>
							<button type="button" class="btn btn-warning" onclick="location.href='../Community/List?${queryStr}';">리스트보기</button>
						</div>
						<form name="deleteFrm">
							<input type="hidden" name="num" value="${dto.num }" />
							<input type="hidden" name="bname" value="<%=bname %>" />
						</form>
					</div>
					<!-- 각종버튼부분 끝 -->
				</div>
			</div>	
		</div>
		<!-- contents_box -->
		<%@ include file="../include/quick.jsp"%>
	</div>
	<!-- wrap -->
	<%@ include file="../include/footer.jsp"%>
	</center>
</body>
</html>