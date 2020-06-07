<%@page import="java.net.URLEncoder"%>
<%@page import="util.PagingUtil"%>
<%@page import="model.BbsDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp"%>
<%@ include file="isFlag.jsp"%>
<%
	//한글깨짐처리 - 검색폼에서 입력된 한글이 전송되기때문
	request.setCharacterEncoding("UTF-8");

	/* DB연결하기 */
	//1.web.xml에 저장된 컨텍스트 초기화 파라미터를 application객체를 통해 가져옴
	String drv = application.getInitParameter("MariaJDBCDriver");
	String url = application.getInitParameter("MariaConnectURL");
	//2.DAO객체 생성 및 DB커넥션
	BbsDAO dao = new BbsDAO(drv, url);//DB연결 끝

	Map<String, Object> param = new HashMap<String, Object>();//폼값을 받아서 파라미터를 저장할변수 생성
	param.put("bname", bname);

	String queryStr = "";//검색시 페이지번호로 쿼리스트링을 넘겨주기 위한 용도(url부분에 뜬다.)
	queryStr = "bname=" + bname + "&"; //필수파라미터에 대한 쿼리스트링 처리

	//검색어 입력시 전송된 폼값을 받아 Map에 저장
	String searchColumn = request.getParameter("searchColumn");
	String searchWord = request.getParameter("searchWord");
	if (searchWord != null) {
		//검색어를 입력한 경우 Map에 값을 입력함.
		param.put("Column", searchColumn);
		param.put("Word", searchWord);
		//검색어가 있을때 쿼리스트링을 만들어준다.
		queryStr += "searchColumn=" + searchColumn + "&searchWord=" + searchWord + "&";
	}
	//board테이블에 입력된 전체 레코드 갯수를 카운트하여 반환받음
	int totalRecordCount = dao.getTotalRecordCount(param);

	/*****페이지처리 start******/
	//web.xml의 초기화 파라미터 가져와서 정수로 변경후 저장
	int pageSize = 
	Integer.parseInt(application.getInitParameter("PAGE_SIZE"));
	int blockPage = 
	Integer.parseInt(application.getInitParameter("BLOCK_PAGE"));
	int imgpageSize =
	Integer.parseInt(application.getInitParameter("IMG_PAGE_SIZE"));

	//***페이지계산 변수설정
	int totalPage;
	int nowPage;
	int start;
	int end;
	//페이지계산 photo는 6개의 자료씩 추출해야한다.
	if(bname.equals("photo")){
		//전체페이지수 계산
		totalPage = (int)Math.ceil((double)totalRecordCount/imgpageSize);
		
		/*
		현제페이지번호 : 파라미터가 없을때는 무조건 1페이지로 지정하고, 있을때는 해당 값을
			얻어와서 지정한다. 즉 리스트에 처음 진입했을때는 1페이지가 된다.
		*/
		nowPage = (request.getParameter("nowPage")==null
		|| request.getParameter("nowPage").equals(""))
		? 1 : Integer.parseInt(request.getParameter("nowPage"));
		
		//한페이지에 출력할 게시물의 범위를 결정한다. 
		start = (nowPage-1)*imgpageSize;
		end = imgpageSize;
	}else{

		totalPage = (int)Math.ceil((double)totalRecordCount/pageSize);

		nowPage = (request.getParameter("nowPage")==null
		|| request.getParameter("nowPage").equals(""))
		? 1 : Integer.parseInt(request.getParameter("nowPage"));

		start = (nowPage-1)*pageSize;
		end = pageSize;
	}//페이지계산끝

	//게시물의 범위를 Map컬렉션에 저장하고 DAO로 전달한다.
	param.put("start", start);
	param.put("end", end);
	//조건에 맞는 레코드를 select하여 결과셋을 List컬렉션으로 반환받음
	List<BbsDTO> bbs = dao.selectListPage(param);
	dao.close();
%>

<body>
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
					<img src="<%=img%>" alt="공지사항" class="con_title" />
					<p class="location">
						<img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;<%=boardTitle%>
					<p>
				</div>
				<div>
					<!-- 검색부분 -->
					<div class="row text-right" style="margin-bottom: 20px;">
						<form class="form-inline ml-auto" name="searchFrm" method="get">
							<input type="hidden" name="bname" value="<%=bname%>" />
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
					<!-- 검색부분 끝 -->
					<!-- 자유,공지,자료리스트부분 -->
				<% if(!(bname.equals("schedule") || bname.equals("photo"))){%> 
					<div class="row">
						<table class="table table-bordered table-hover " style=TABLE-layout:fixed>
							<colgroup>
								<col width="80px" />
								<col width="*" />
								<col width="120px" />
								<col width="120px" />
								<col width="80px" />
							<%if(bname.equals("dataroom")) {%>
								<col width="50px" />
							<%} %>
							</colgroup>
							<thead class="thead-light">
								<tr class="success">
									<th class="text-center">번호</th>
									<th class="text-center">제목</th>
									<th class="text-center">작성자</th>
									<th class="text-center">작성일</th>
									<th class="text-center">조회수</th>
								<%if(bname.equals("dataroom")) {%>
									<th class="text-center">첨부</th>
								<% } %>
								</tr>
							</thead>

							<tbody>
							<% if (bbs.isEmpty()) {%>
								<tr>
									<td colspan="8" align="center" height="100">
										등록된 게시물이 없습니다.
									</td>
								</tr>
							<%}else{
								
								int vNum = 0;
								int countNum = 0;

								for (BbsDTO dto : bbs) {
									vNum = totalRecordCount - (((nowPage - 1) * pageSize) + countNum++);
								%>
								<!-- 리스트반복 시작 -->
								<tr>
									<td class="text-center"><%=vNum%></td>
									<td class="text-left" style="text-overflow : ellipsis;overflow : hidden;"><a href="sub01_view.jsp?num=<%=dto.getNum()%>&nowPage=<%=nowPage%>&<%=queryStr%>"><%=dto.getTitle()%></a></td>
									<td class="text-center"><%=dto.getId()%></td>
									<td class="text-center"><%=dto.getPostdate()%></td>
									<td class="text-center"><%=dto.getVisitcount()%></td>
								<%if(bname.equals("dataroom")) {%>
									<td class="text-center">
									<%if(dto.getOfile() != null || dto.getSfile() != null){ %>
									
									<a href="Download2.jsp?oName=<%=URLEncoder.encode(dto.getOfile(),"UTF-8") %>&sName=<%=URLEncoder.encode(dto.getSfile(),"UTF-8") %>">
									<img src="../images/disk.png" width="20" alt="" />
									</a>
									<%} %>
									</td>
								<% } %>
								</tr>
								<!-- 리스트반복 끝 -->
							<%
								}
							}	%>
							</tbody>
						</table>
					</div>
					<!-- 자유,공지, 자료게시판리스트부분 끝 -->
				<% } else if(bname.equals("photo")) {%>
		
					<!-- 사진게시판 리스트부분 -->
					<div class="row">
						<% if (bbs.isEmpty()) {%>
						<table class="table table-bordered table-hover ">
							<colgroup>
								<col width="*" />
							</colgroup>
							<tr>
								<td align="center" height="100">
									등록된 게시물이 없습니다.
								</td>
							</tr>
						</table>
						<%}else{
							int vNum = 0;
							int countNum = 0;

							for (BbsDTO dto : bbs) {
								vNum = totalRecordCount - (((nowPage - 1) * imgpageSize) + countNum++);
							%>
						<!-- 리스트반복 시작 -->
						<table class="table" style="width: 100px;">
							<tr>
								<td><%=vNum %></td>
							</tr>
							<tr>
								<td><img style="width: 200px; height: 200px" src="../Upload/<%=dto.getSfile() %>" /></td>
							</tr>
							<tr>
								<td>
								<a href="sub01_view.jsp?num=<%=dto.getNum() %>&nowPage=<%=nowPage%>&<%=queryStr%>">
								<%=dto.getTitle() %></a>
								</td>
							</tr>
							<tr>
								<td><%=dto.getId() %></td>
							</tr>
							<tr>
								<td><%=dto.getPostdate() %></td>
							</tr>
							<tr>
								<td>조회수 : <%=dto.getVisitcount() %></td>
							</tr>
						</table>
						<%   }
						 }	%><!-- 리스트반복 끝 -->
					</div>
					<%} %>
					<!-- 사진게시판 리스트부분 끝-->					
					<!-- 게시판버튼부분  (공지사항과 스케줄 게시판에서는 글쓰기불가능)-->
				<% if (!(bname.equals("notice")||bname.equals("schedule"))) { %>
					<div class="row">
						<div class="col text-right">
							<button type="button" class="btn btn-primary"
								onclick="location.href='sub01_write.jsp?bname=<%=bname%>';">글쓰기</button>
						</div>
					</div>
				<% }%>
					<!-- 게시판버튼부분 끝  -->
					<!-- 페이지번호 부분  -->
					<div class="row mt-3">
						<div class="col">
						<!-- 페이지번호 부분(사진일때) -->
						<% if(bname.equals("photo")){%>
							<ul class="pagination justify-content-center">
								<%=PagingUtil.pagingBS4(totalRecordCount, imgpageSize, blockPage, nowPage, "sub01_list.jsp?" + queryStr)%>
							</ul>
						<%}else{ %>	
						<!-- 페이지번호 부분(나머지) -->
							<ul class="pagination justify-content-center">
								<%=PagingUtil.pagingBS4(totalRecordCount, pageSize, blockPage, nowPage, "sub01_list.jsp?" + queryStr)%>
							</ul>
						<%} %>
						</div>
					</div>
					<!-- 페이지번호 부분  끝-->
				</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp"%>
	</div>
	<%@ include file="../include/footer.jsp"%>
	</center>
</body>
</html>