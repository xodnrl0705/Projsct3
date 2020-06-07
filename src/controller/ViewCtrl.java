package controller;

import java.io.IOException;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.BbsDAO;
import model.BbsDTO;

public class ViewCtrl extends HttpServlet {
	
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		ServletContext application = this.getServletContext();//java에서는 applicat

		String bname = req.getParameter("bname");
		/*
		검색후 파라미터 처리를 위한 추가부분
			: 리스트에서 검색후 상세보기 , 그리고 다시 리스트보기를 
			눌렀을때 검색이 유지되도록 처리하기위한 코드삽입
		*/
		String queryStr = "bname="+bname+"&";
		String searchColumn  = req.getParameter("searchColumn");
		String searchWord  = req.getParameter("searchWord");
		if(searchWord!=null){
			queryStr += "searchColumn=" + searchColumn+"&searchWord="+searchWord+"&";
		}
		//3페이지에서 상세보기했다면 리스트로 돌아갈때도 3페이지로 가야한다.
		String nowPage = req.getParameter("nowPage");
		if(nowPage == null || nowPage.equals(""))
			nowPage = "1";
		queryStr += "nowPage=" + nowPage;

		//폼값 받기 - 파라미터로 전달된 게시물의 일련번호
		String num = req.getParameter("num");
		BbsDAO dao = new BbsDAO(application);

		//게시물을 가져와서 DTO객체로 반환
		BbsDTO dto = dao.selectView(num);  
		//게시물의 조회수 +1증가
		dao.updateVisitCount(num); 
		
		//게시물의 줄바꿈 처리를 위해 replace()메소드를 사용한다.
		dto.setContent(dto.getContent().replaceAll("\r\n", "<br/>"));
		
		HttpSession session = req.getSession();

		String USER_ID = (String) session.getAttribute("USER_ID");
		
		req.setAttribute("queryStr", queryStr);
		req.setAttribute("USER_ID", USER_ID);//세션아이디 설정
		req.setAttribute("dto", dto);//request영역에 DTO객체 저장
		
		req.getRequestDispatcher("/community/sub01_view.jsp").forward(req, resp);

		
		dao.close();
	
	}
	
	
}
