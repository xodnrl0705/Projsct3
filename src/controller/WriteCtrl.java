package controller;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;

import model.BbsDAO;
import model.BbsDTO;
import util.FileUtil;

public class WriteCtrl extends HttpServlet{
	
	/*
	글쓰기 페이지의 경우
		doGet() 메소드는 글쓰기 폼으로 이동(location)할때의 요청을 처리하고
		doPost() 메소드는 글쓰기를 완료(submit)할때의 요청을 처리한다.
	*/
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		req.getRequestDispatcher("/community/sub01_write.jsp").forward(req, resp);
	}
	//게시물 내용 작성후 submit했을때의 요청을 처리함
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException ,IOException {
		//글쓰기 관련 폼값에 대한 한글처리
		req.setCharacterEncoding("UTF-8");
		
		//해당 메소드는 MultipartRequest객체를 생성하면서 파일업로드를 처리한다.
		/*
			매개변수로는 request객체, Upload의 서버의 물리적경로를 전달한다.
		*/
		MultipartRequest mr = FileUtil.upload(req,
				req.getServletContext().getRealPath("/Upload"));
		
		int sucOrFail;
		
			String title = mr.getParameter("title");
			String content = mr.getParameter("content");
			String bname = mr.getParameter("bname");
		if(mr != null) {
			
			//서버에 저장된 실제파일명을 가져온다.
			String ofile = 
					mr.getFilesystemName("chumFile1");
			HttpSession session = req.getSession();
			//DTO객체에 폼값을 저장한다.
			BbsDTO dto = new BbsDTO();
			dto.setOfile(ofile);
			dto.setContent(content);
			dto.setTitle(title);
			dto.setBname(bname);
			dto.setId(session.getAttribute("USER_ID").toString());
			ServletContext application = this.getServletContext();//java에서는 applicat

			//DAO객체생성 및 DB연결..insert처리
			BbsDAO dao = new BbsDAO(application);
			sucOrFail = dao.insert(dto);
			dao.close();
		}
		else {
			//mr객체가 생성되지 않았을때(업로드 실패시)
			sucOrFail = -1;
		}
		//파일업로드 성공 및 글쓰기처리 성공일때 ....
		if(sucOrFail == 1) {
			resp.sendRedirect("../Community/List?bname="+bname);
		}
		else {
			//나머지는 실패로 처리한다. 실패시 글쓰기페이지로 돌아간다.
			req.getRequestDispatcher("/community/sub01_write.jsp?bname="+bname).forward(req, resp);
		}
	};
}
