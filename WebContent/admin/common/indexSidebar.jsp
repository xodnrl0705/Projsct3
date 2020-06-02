<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<ul class="sidebar navbar-nav"><!-- 사이드바 -->
      <li class="nav-item active">
        <a class="nav-link" href="memberInfo.jsp">
          <i class="fas fa-fw fa-tachometer-alt"></i>
          <span>회원관리</span>
        </a>
      </li>
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="" id="pagesDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <i class="fas fa-fw fa-folder"></i>
          <span>게시판관리</span>
        </a>
        <div class="dropdown-menu" aria-labelledby="pagesDropdown">
          <h6 class="dropdown-header">열린공간:</h6>
          <a class="dropdown-item" href="boardList.jsp?bname=notice">공지사항</a>
          <a class="dropdown-item" href="boardList.jsp?bname=schedule">프로그램일정</a>
          <a class="dropdown-item" href="boardList.jsp?bname=freeboard">자유게시판</a>
          <a class="dropdown-item" href="boardList.jsp?bname=photo">사진게시판</a>
          <a class="dropdown-item" href="boardList.jsp?bname=info">정보자료실</a>
          <div class="dropdown-divider"></div>
          <h6 class="dropdown-header">커뮤니티:</h6>
          <a class="dropdown-item" href="404.html">직원자료실</a>
          <a class="dropdown-item" href="blank.html">보호자게시판</a>
        </div>
      </li>
      <!-- <li class="nav-item">
        <a class="nav-link" href="charts.html">
          <i class="fas fa-fw fa-chart-area"></i>
          <span>Charts</span></a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="tables.html">
          <i class="fas fa-fw fa-table"></i>
          <span>Tables</span></a>
      </li> -->
    </ul><!--사이드바 끝  -->