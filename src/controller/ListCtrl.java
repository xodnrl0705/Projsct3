package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.BbsDAO;
import model.BbsDTO;
import util.PagingUtil;

public class ListCtrl extends HttpServlet{

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		ServletContext application = this.getServletContext();//java에서는 applicat

		String drv = application.getInitParameter("MariaJDBCDriver");
		String url = application.getInitParameter("MariaConnectURL");
		
		BbsDAO dao = new BbsDAO(drv, url);//DB연결 끝
		
		Map<String, Object> param = new HashMap();//폼값을 받아서 파라미터를 저장할변수 생성
		String bname = req.getParameter("bname");
		param.put("bname", bname);

		String queryStr = ""; //필수파라미터에 대한 쿼리스트링 처리

		String searchColumn = req.getParameter("searchColumn");
		String searchWord = req.getParameter("searchWord");
		
		if (!(searchWord==null || searchWord.equals(""))) {
			//검색어를 입력한 경우 Map에 값을 입력함.
			queryStr += "searchColumn=" + searchColumn + "&searchWord=" + searchWord + "&";
			param.put("Column", searchColumn);
			param.put("Word", searchWord);
			param.put("queryStr", queryStr);
		}
		//board테이블에 입력된 전체 레코드 갯수를 카운트하여 반환받음
		int totalRecordCount = dao.getTotalRecordCount(param);

		/*****페이지처리 start******/
		//web.xml의 초기화 파라미터 가져와서 정수로 변경후 저장
		int pageSize = 
		Integer.parseInt(application.getInitParameter("PAGE_SIZE"));
		int blockPage = 
		Integer.parseInt(application.getInitParameter("BLOCK_PAGE"));

		int	totalPage = (int)Math.ceil((double)totalRecordCount/pageSize);

		int	nowPage = (req.getParameter("nowPage")==null
			|| req.getParameter("nowPage").equals(""))
			? 1 : Integer.parseInt(req.getParameter("nowPage"));

		int	start = (nowPage-1)*pageSize;
		int	end = pageSize;

		//게시물의 범위를 Map컬렉션에 저장하고 DAO로 전달한다.
		param.put("start", start);
		param.put("end", end);
		param.put("totalPage", totalPage);
		param.put("nowPage", nowPage);
		param.put("totalCount", totalRecordCount);
		param.put("pageSize", pageSize);
		
		String pagingImg = PagingUtil.pagingBS4(totalRecordCount, pageSize, blockPage, nowPage, "../Community/List?"+ queryStr);
		param.put("pagingImg", pagingImg);
		//조건에 맞는 레코드를 select하여 결과셋을 List컬렉션으로 반환받음
		
		List<BbsDTO> bbs = dao.selectListPage(param);
		dao.close();
		
		req.setAttribute("lists", bbs);
		req.setAttribute("map", param);
		req.getRequestDispatcher("/community/sub01_list.jsp").forward(req, resp);
		
	}
	
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		/*
		만약 게시판 리스트쪽에서 POST방식으로 요청이 들어오더라도
		처리는 doGet()메소드에서 처리할 수 있도록 모든 요청을 토스한다.
		 */
		doGet(req, resp);
	}
	
}
