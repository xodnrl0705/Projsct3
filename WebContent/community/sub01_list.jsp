<%@page import="java.net.URLEncoder"%>
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
			</div>
			<!-- 검색부분 -->
			<div class="row text-right" style="margin-bottom: 20px;">
				<form class="form-inline ml-auto" name="searchFrm" >
					<input type="hidden" name="bname" value="<%=bname %>" />
					<div class="form-group">
						<select name="searchColumn" class="form-control">
							<option value="title">제목</option>
							<option value="content">내용</option>
							<option value="id">작성자</option>
						</select>
					</div>
					<div class="input-group">
						<input type="text" name="searchWord" class="form-control" />
						<div class="input-group-btn">
							<button type="submit" class="btn btn-warning">
								<i class='fa fa-search' style='font-size: 25px'></i>
							</button>
						</div>
					</div>
				</form>
			</div>
			<!-- 검색부분 끝  -->
			<!-- 게시판 리스트 부분 -->
			<div class="row">
				<table class="table table-bordered table-hover "
					style="TABLE-layout: fixed">
					<colgroup>
						<col width="80px" />
						<col width="*" />
						<col width="120px" />
						<col width="120px" />
						<col width="80px" />
						<col width="50px" />
					</colgroup>
					<thead class="thead-light">
						<tr class="success">
							<th class="text-center">번호</th>
							<th class="text-center">제목</th>
							<th class="text-center">작성자</th>
							<th class="text-center">작성일</th>
							<th class="text-center">조회수</th>
							<th class="text-center">첨부</th>
						</tr>
					</thead>
					<tbody>
<!-- 
	ListCtrl 서블릿에서 request영역에 저장한 ResultSet을 JSTL과 EL을
	통해 화면에 내용을 출력한다. 
		choose
			when ->lists 컬렉션에 아무값도 없을때
			otherwise - >ResultSet 결과가 있을때 (즉 출력할 레코드가 있을때)

-->
	<c:choose>
		<c:when test="${empty lists }">
			<tr>
				<td colspan="6">등록된 게시물이 없습니다^^*</td>
			</tr>
		</c:when>
		<c:otherwise>
			<c:forEach items="${lists }" var="row" varStatus="loop">
				<tr>
					<td class="text-center">
					${map.totalCount - (((map.nowPage-1) * map.pageSize) + loop.index) }
					</td>
					<td class="text-left">
						<a href="../Community/View?bname=${map.bname}&num=${row.num}&nowPage=${map.nowPage}&searchColumn=${map.Column}&searchWord=${map.Word}">${row.title } </a>
					</td>
					<td class="text-center">${row.id }</td>
					<td class="text-center">${row.postdate }</td>
					<td class="text-center">${row.visitcount }</td>
					<td class="text-center">
					<c:if test="${not empty row.ofile}">
							<a
								href="./Download?filename=${row.ofile }&num=${row.num}">
								<img src="../images/disk.png" width="20" alt="" />
							</a>
					</c:if></td>
				</tr>
			</c:forEach>
		</c:otherwise>
	</c:choose>
					</tbody>
				</table>
			</div>
			<!-- 게시판 리스트 부분 끝 -->
			<!-- 게시판 버튼 및 페이징 처리 -->
			<div class="row">
					<div class="col text-right">
						<button type="button" class="btn btn-primary"
							onclick="location.href='../Community/Write?bname=<%=bname%>';">글쓰기</button>
					</div>
				</div>
				<div class="row mt-3" >
					<div class="col">
						<ul class="pagination justify-content-center" >${map.pagingImg }</ul>
					</div>
				</div>
			<!-- 게시판 버튼 및 페이징 처리 끝-->
		</div>
		<!-- contents_box -->
		<%@ include file="../include/quick.jsp"%>
	</div>
	<!-- wrap -->
	<%@ include file="../include/footer.jsp"%>
	</center>
</body>
</html>