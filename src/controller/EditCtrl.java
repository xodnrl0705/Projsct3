package controller;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;

import model.BbsDAO;
import model.BbsDTO;
import util.FileUtil;

public class EditCtrl extends HttpServlet{

	//edit으로 이동할때
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String num = req.getParameter("num");
		String bname = req.getParameter("bname");
		ServletContext app = this.getServletContext();
		BbsDAO dao = new BbsDAO(app);
		
		//게시물을 가져와서 DTO객체로 반환
		BbsDTO dto = dao.selectView(num); 
		req.setAttribute("num", num);
		req.setAttribute("dto", dto);
		
		req.getRequestDispatcher("/community/sub01_edit.jsp?num="+num).forward(req, resp);

		
		dao.close();
		
	}
	
	//edit에서 폼값을 전송할때
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		req.setCharacterEncoding("UTF-8");
		MultipartRequest mr = FileUtil.upload(req, req.getServletContext().getRealPath("/Upload"));
		
		int sucOrFail;
		if(mr!= null) {
			String num = mr.getParameter("num");
			System.out.println(num);
			
			String searchColumn = mr.getParameter("searchColumn");
			String searchWord = mr.getParameter("searchWord");
			String nowPage = mr.getParameter("nowPage");
			String bname = mr.getParameter("bname");
			
			String originalfile = mr.getParameter("originalfile");
			
			req.setAttribute("num", num);
			req.setAttribute("Column", searchColumn);
			req.setAttribute("Word", searchWord);
			req.setAttribute("nowPage", nowPage);
			req.setAttribute("bname",bname);
			
			String title = mr.getParameter("title");
			String content = mr.getParameter("content");
			String fileName = mr.getFilesystemName("chumFile1");
			
			if(fileName==null) {
				fileName = originalfile;
			}
			
			BbsDTO dto = new BbsDTO();
			dto.setTitle(title);
			dto.setContent(content);
			dto.setOfile(fileName);
			dto.setNum(num);
			
			ServletContext app =this.getServletContext();
			BbsDAO dao= new BbsDAO(app);
			sucOrFail = dao.update(dto);
			
			if(sucOrFail==1 && mr.getFilesystemName("fileName")!=null) {
				FileUtil.deleteFile(req, "/Upload", originalfile);
			}
			dao.close();
		}
		else {
			sucOrFail = -1;
		}
		req.setAttribute("SUC_FAIL", sucOrFail);
		req.setAttribute("WHEREIS", "UPDATE");
		req.getRequestDispatcher("/community/Message.jsp").forward(req, resp);
		
	
	
	}
	
}
