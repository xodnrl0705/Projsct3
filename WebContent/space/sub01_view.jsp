<%@page import="model.BbsDTO"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp"%>
<%@ include file="isFlag.jsp"%>
<%
/*
검색후 파라미터 처리를 위한 추가부분
	: 리스트에서 검색후 상세보기 , 그리고 다시 리스트보기를 
	눌렀을때 검색이 유지되도록 처리하기위한 코드삽입
*/
String queryStr = "bname="+bname+"&";
String searchColumn  = request.getParameter("searchColumn");
String searchWord  = request.getParameter("searchWord");
if(searchWord!=null){
	queryStr += "searchColumn=" + searchColumn+"&searchWord="+searchWord+"&";
}
//3페이지에서 상세보기했다면 리스트로 돌아갈때도 3페이지로 가야한다.
String nowPage = request.getParameter("nowPage");
if(nowPage == null || nowPage.equals(""))
	nowPage = "1";
queryStr += "&nowPage=" + nowPage;

//폼값 받기 - 파라미터로 전달된 게시물의 일련번호
String num = request.getParameter("num");
BbsDAO dao = new BbsDAO(application);

//게시물의 조회수 +1증가
dao.updateVisitCount(num);  

//게시물을 가져와서 DTO객체로 반환
BbsDTO dto = dao.selectView(num);  

dao.close();
%>

<body>
	<!-- <center> -->
	<div id="wrap">
		<%@ include file="../include/top.jsp"%>
		<img src="../images/space/sub_image.jpg" id="main_visual" />
		<div class="contents_box">
			<div class="left_contents">
				<%@ include file="../include/space_leftmenu.jsp"%>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<img src="<%=img%>" alt="공지사항" class="con_title" />
					<p class="location">
						<img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;<%=bname%>
					<p>
				</div>
				<div>
					<!-- view부분  -->
					<table class="table table-bordered">
						<colgroup>
							<col width="20%" />
							<col width="30%" />
							<col width="20%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th class="text-center" style="vertical-align: middle;">아이디</th>
								<td><%=dto.getId() %></td>
								<th class="text-center" style="vertical-align: middle;">작성일</th>
								<td><%=dto.getPostdate() %></td>
							</tr>
							<tr>
								<th class="text-center" style="vertical-align: middle;">작성자</th>
								<td><%=dto.getName() %></td>
								<th class="text-center" style="vertical-align: middle;">조회수</th>
								<td><%=dto.getVisitcount() %></td>
							</tr>
							<tr>
							<%if(bname.equals("dataroom")) {%>
								<th class="text-center" style="vertical-align: middle;">제목</th>
								<td><%=dto.getTitle() %></td>
								<th class="text-center" style="vertical-align: middle;">다운로드수</th>
								<td><%=dto.getDowncount() %></td> 
							
							<%}else{ %>
							
								<th class="text-center" style="vertical-align: middle;">제목</th>
								<td colspan="3"><%=dto.getTitle() %></td>
							
							<%} %>
							</tr>
							<tr>
								<th class="text-center" style="vertical-align: middle;">내용</th>
								<td colspan="3" class="align-middle" style="height:200px;">
									<%=dto.getContent().replace("\r\n", "<br/>") %>
								</td>
							</tr>
							<%if (bname.equals("dataroom")) {%>
							<tr>
								<th class="text-center" style="vertical-align: middle;">첨부파일</th>
								<td colspan="3">
									파일명.jpg <a href="">[다운로드]</a>
								</td>
							</tr>
							<% } %>
						</tbody>
					</table>

					<!-- 각종버튼부분 -->
					<%if(bname.equals("freeboard")){ %>
					<div class="row mb-3">
						<div class="col text-right pr-3">
							<button type="button" class="btn btn-secondary"
								onclick="location.href='sub01_edit.jsp?num=<%=dto.getNum()%>&bname=<%=bname%>';">수정하기</button>
							<button type="button" class="btn btn-success"
								onclick="isDelete();">삭제하기</button>
							<button type="button" class="btn btn-warning" onclick="location.href='sub01_list.jsp?<%=queryStr%>';">리스트보기</button>
						</div>
						<form name="deleteFrm">
							<input type="hidden" name="num" value="<%=dto.getNum() %>" />
							<input type="hidden" name="bname" value="<%=bname %>" />
						</form>
						<script>
							function isDelete() {
								var c = confirm("삭제할까요?");
								if(c){
									var f = document.deleteFrm;
									f.method = "post";
									f.action = "deleteProc.jsp";
									f.submit();
								}
								
							}
						</script>
					</div>
					<%}else {%>
					<div class="row mb-3">
						<div class="col text-right pr-3">
							<button type="button" class="btn btn-warning" onclick="location.href='sub01_list.jsp?<%=queryStr%>';">리스트보기</button>
						</div>
					</div>
					
					<%} %>
					<!-- 각종버튼부분 끝 -->
				</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp"%>
	</div>


	<%@ include file="../include/footer.jsp"%>
	<!-- </center> -->
</body>
</html>