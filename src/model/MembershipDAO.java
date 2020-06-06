package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletContext;

public class MembershipDAO {
	
	//멤버변수 (클래스 전체 멤버메소드에서 접근가능)
	Connection con;
	PreparedStatement psmt;
	ResultSet rs;
	
	//기본생성자
   public MembershipDAO() {
	   System.out.println("MemberDAO 생성자 호출");
   }   
   
   public MembershipDAO(String driver, String url) {
	   try {
		   Class.forName(driver);
		   String id = "suamil_user";
		   String pw = "1234";
		   con =DriverManager.getConnection(url, id, pw);
		   System.out.println("DB연결성공");
	   }
	   catch (Exception e) {
		e.printStackTrace();
	   }
   }
   public MembershipDAO(ServletContext ctx) {
		try {
			Class.forName(ctx.getInitParameter("MariaJDBCDriver"));
			String id = "suamil_user";
			String pw = "1234";
			con =DriverManager.getConnection(ctx.getInitParameter("MariaConnectURL"),id,pw);
			System.out.println("DB연결성공");
		}
		catch (Exception e) {
			System.out.println("DB연결실패ㅜㅜ;");
			e.printStackTrace();
		}
	}
   	//DB자원해제
 	public void close() {
 		try {
 			if(rs!=null) rs.close();
 			if(psmt!=null) psmt.close();
 			if(con!=null) con.close();
 		}
 		catch (Exception e) {
 			System.out.println("자원반납시 예외발생");
 		}
 	}
 	//<관리자모드:회원관리 > 회원테이블에 있는 정보의 갯수를 반환
 	public int getTotalRecordCount(Map<String, Object> map) {
		
		int totalCount = 0;//게시물의 수는 0으로 초기화
		//기본쿼리문(전체레코드를 대상으로 함)
		String query = "SELECT COUNT(*) FROM membership" ;
		
		//JSP페이지에서 검색어를 입력한 경우 where절이 동적으로 추가됨.
		if(map.get("Word")!=null) {
			query += " WHERE "+map.get("Column") + " "
					+ " LIKE '%"+ map.get("Word") +"%'";
		}
		System.out.println("query="+query);
		
		try {
			psmt = con.prepareStatement(query);
			rs = psmt.executeQuery();
			rs.next();
			//반환한 결과값(레코드수)을 저장
			totalCount = rs.getInt(1);
		}
		catch (Exception e) {}
		
		return totalCount;
	}
 	
 	//<관리자모드:회원관리>리스트 페이지 처리
	public List<MembershipDTO> selectListPage(Map<String, Object> map){
		List<MembershipDTO> bbs = new Vector<MembershipDTO>();
		String grade="";
		
		String query = "SELECT * FROM membership" ;
		if(map.get("Word")!=null) {
			query += " WHERE " + map.get("Column") +" "
					+" LIKE '%" + map.get("Word") +"%' ";
		}
		query += "	ORDER BY id DESC LIMIT ?, ? ";
		System.out.println("쿼리문:"+query);
		try {
			psmt = con.prepareStatement(query);
			
			//JSP에서 계산한 페이지 범위값을 이용해 인파라미터를 설정함.
			/*
				setString()으로 인파라미터를 설정하면 문자형이 되므로
				여기서는 setInt()를 통해 정수 형태로 설정해야 한다.
			 */
			psmt.setInt(1, Integer.parseInt(map.get("start").toString()));
			psmt.setInt(2, Integer.parseInt(map.get("end").toString()));
			
			rs = psmt.executeQuery();
			//오라클이 반환해준 ResultSet의 갯수만큼 반복한다.
			while(rs.next()) {
				//하나의 레코드를 DTO객체에 저장하기 위해 새로운 객체생성
				MembershipDTO dto = new MembershipDTO();
				
				dto.setName(rs.getString("name"));
				dto.setId(rs.getString("id"));
				dto.setPhone(rs.getString("phone"));
				dto.setEmail(rs.getString("email"));
				
				dto.setGrade(rs.getString("grade"));
				
				bbs.add(dto);
			}
		}
		catch(Exception e) {
			System.out.println("Select시 예외발생");
			e.printStackTrace();
		}
		return bbs;
	}
	
	//<관리자모드:회원관리>클릭한id의 정보를 가져와서 DTO객체에 저장후 반환
	public MembershipDTO selectView(String id) {
		MembershipDTO dto = new MembershipDTO();
		String grade="";
		
		String query = "SELECT * FROM membership WHERE id = ? ";
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, id);
			rs = psmt.executeQuery();
			if(rs.next()) {
				dto.setName(rs.getString("name"));
				dto.setId(rs.getString("id"));
				dto.setPass(rs.getString("pass"));
				dto.setTel(rs.getString("tel"));
				dto.setPhone(rs.getString("phone"));
				dto.setEmail(rs.getString("email"));
				dto.setZip(rs.getString("zip"));
				dto.setAddr(rs.getString("addr"));
				dto.setRegidate(rs.getDate("regidate"));
				dto.setGrade(rs.getString("grade"));
				dto.setEmailcheck(rs.getString("emailcheck"));
				System.out.println("상세보기 성공");
			}
		}
		catch (Exception e) {
			System.out.println("상세보기시 예외발생");
			e.printStackTrace();
		}
		return dto;
	}
	//<관리자모드:회원관리>회원정보수정
	public int updateEdit(MembershipDTO dto) {
		int affected = 0;
		try {
			String query = "UPDATE membership SET "
					+ " name = ?, pass = ?, tel = ?, phone = ?, email = ?, grade = ?, zip=?, addr=? "
					+ " WHERE id=?";
			
			psmt = con.prepareStatement(query);
			psmt.setString(1, dto.getName());
			psmt.setString(2, dto.getPass());
			psmt.setString(3, dto.getTel());
			psmt.setString(4, dto.getPhone());
			psmt.setString(5, dto.getEmail());
			psmt.setString(6, dto.getGrade());
			psmt.setString(7, dto.getZip());
			psmt.setString(8, dto.getAddr());
			psmt.setString(9, dto.getId());
			
			affected = psmt.executeUpdate();
			System.out.println("수정완료" + dto.getGrade());
		}
		catch (Exception e) {
			System.out.println("update중 예외발생");
			System.out.println("수정완료" + dto.getEmail());
			e.printStackTrace();
		}
		
		return affected;
	}
	
	//<관리자모드:회원관리>회원 삭제 처리
	public int delete(MembershipDTO dto) {
		int affected = 0;
		try {
			String query = "DELETE FROM membership WHERE id=? ";
			
			psmt = con.prepareStatement(query);
			psmt.setString(1,dto.getId());
			
			affected = psmt.executeUpdate();
			
		}
		catch (Exception e) {
			System.out.println("delete중 예외발생");
			e.printStackTrace();
		}
		return affected;
	}
	
   	//회원가입 하는 메소드(완료)
    public int memberJoin(MembershipDTO dto) {
    	
    	int affected=0;
		try {
			String query = "INSERT INTO MEMBERSHIP ( "
					+ " name, id, pass, tel, phone, email, zip, addr, emailcheck) "
					+ " VALUES ( "
					+ " ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			psmt = con.prepareStatement(query);
			psmt.setString(1, dto.getName());
			psmt.setString(2, dto.getId());
			psmt.setString(3, dto.getPass());
			psmt.setString(4, dto.getTel());
			psmt.setString(5, dto.getPhone());
			psmt.setString(6, dto.getEmail());
			psmt.setString(7, dto.getZip());
			psmt.setString(8, dto.getAddr());
			psmt.setString(9, dto.getEmailcheck());
			
			affected = psmt.executeUpdate();
			System.out.println("회원가입 성공 ! 아이디 : "+ dto.getId());
		}
		catch (Exception e) {
			System.out.println("insert(회원가입)중 예외발생");
			e.printStackTrace();
		}
		return affected;
    }
   
   
   //아이디찾기 
   public String isMemberid(String name, String email) {
	   //입력받은 이름과 이메일에 해당하는 아이디가 있는지 찾는 쿼리문
	   String sql = "SELECT id FROM membership "
	            + " WHERE name=? AND email=?";
	   String id="";//id를 받기위한 변수	   
	   try {
		   //prepare객체로 쿼리문 전송
		   psmt = con.prepareStatement(sql);
		   //인파라미터 설정
		   psmt.setString(1, name);
		   psmt.setString(2, email);
		   //쿼리실행
		   rs = psmt.executeQuery();
		   if(rs.next()) {
			   //true를 반환했다면 해당아이디를 저장
			   id = rs.getString("id");
			   System.out.println("찾은id: " + id);
		   }
		   else {
			   //false를 반환했다면 결과셋 없음.
			   System.out.println("결과셋이 없습니다.");
		   }
	   }
	   catch (Exception e) {
		   System.out.println("select(아이디찾기)중 예외발생");
		   e.printStackTrace();
	   }
	   return id;//id출력
   	}
   	//패스워드찾기(이메일로 보내기)
   	public String isMemberpass(String id, String name, String email) {
	   //입력받은 아이디, 이름, 이메일에 해당하는 아이디가 있는지 찾는 쿼리문
	   String sql = "SELECT pass FROM membership "
	            + " WHERE id = ? AND name=? AND email=?";
	   String pass="";//pass를 받기위한 변수	   
	   try {
		   //prepare객체로 쿼리문 전송
		   psmt = con.prepareStatement(sql);
		   //인파라미터 설정
		   psmt.setString(1, id);
		   psmt.setString(2, name);
		   psmt.setString(3, email);
		   //쿼리실행
		   rs = psmt.executeQuery();
		   if(rs.next()) {
			   //true를 반환했다면 해당아이디를 저장
			   pass = rs.getString("pass");
			   System.out.println("찾은pass: " + pass);
		   }
		   else {
			   //false를 반환했다면 결과셋 없음.
			   System.out.println("결과셋이 없습니다.");
		   }
	   }
	   catch (Exception e) {
		   System.out.println("select(비밀번호찾기)중 예외발생");
		   e.printStackTrace();
	   }
	   return pass;//pass출력
   }
		   
		   
   
   //방법2 : 회원인증후 MemberDTO객체로 회원정보를 반환한다.
   public MembershipDTO getMemberDTO(String uid, String upass) {
	   //DTO객체를 생성한다.
	   MembershipDTO dto = new MembershipDTO();
	   //쿼리문을 작성
	   String query = "SELECT id, pass, name FROM membership "
			   + " WHERE id=? AND pass=?";
	   try {
		   //prepared 객체 생성
		   psmt = con.prepareStatement(query);
		   //쿼리문의 인파라미터 설정
		   psmt.setString(1, uid);
		   psmt.setString(2, upass);
		   //오라클로 쿼리문 전송 및 결과셋(ResultSet) 반환받음
		   rs = psmt.executeQuery();
		   //오라클이 반환해준 ResultSet이 있는지 확인
		   if(rs.next()) {
			   //true를 반환했다면 결과셋 있음
			   //DTO객체에 화원레코드의 값을 저장한다.
			   dto.setId(rs.getString("id"));
			   dto.setPass(rs.getString("pass"));
			   dto.setName(rs.getString(3));
		   }
		   else {
			   //false를 반환했다면 결과셋 없음.
			   System.out.println("결과셋이 없습니다.");
		   }
	   }
	   catch (SQLException e) {
		   System.out.println("getMembershipDTO오류");
		   e.printStackTrace();
	   }
	   
	   //DTO객체를 반환한다.
	   return dto; 
   }
   //로그인 기능 완료(관리자는 등급이 10)
   public Map<String, String> getMemberMap(String id, String pwd){
	   Map<String, String> maps = new HashMap<String, String>();
	   

	   String query = "SELECT id, pass, name, grade FROM "
			   +" membership WHERE id=? AND pass=?";

	   try {
		   psmt = con.prepareStatement(query);
		   	psmt.setString(1, id);
			psmt.setString(2, pwd);
	
		   rs = psmt.executeQuery();

		   if(rs.next()) {
			   maps.put("id",rs.getString("id"));
			   maps.put("pass",rs.getString("pass"));
			   maps.put("name",rs.getString("name"));
			   maps.put("grade",rs.getString("grade"));
			   System.out.println("찾음! 등급:"+ maps.get("grade"));
		   }
		   else {
			   System.out.println("결과셋이 없습니다.");
		   }
	   }
	   catch (SQLException e) {
		   System.out.println("getMemberDTO오류");
		   e.printStackTrace();
	   }
	   
	   return maps; //DTO객체를 반환한다.
   	}
   
public boolean idCheck(String id) {
	   
	String sql = "SELECT COUNT(*) FROM membership WHERE id=?" ;
	int isMember = 0;
	boolean isFlag = false;

	try {
		//prepare객체로 쿼리문 전송
		psmt = con.prepareStatement(sql);
		//인파라미터 설정
		psmt.setString(1, id);
		//쿼리실행
		rs = psmt.executeQuery();
		//실행결과를 가져오기 위해 next()호출
		rs.next();

		isMember = rs.getInt(1);
		System.out.println("affected : " + isMember);
		if(isMember == 0) {
			isFlag = false; // 같은거 없음.
			System.out.println("아이디 중복 없음. 사용가능한 아이디");
		}		   
		else {
			isFlag = true;
			System.out.println("아이디 중복 있음. 사용 불가능 아이디");
		}
	}
	catch (Exception e) {
		isFlag = false;
		System.out.println("sql오류");
		e.printStackTrace();
	}
	return isFlag;
}
   	
  
}
