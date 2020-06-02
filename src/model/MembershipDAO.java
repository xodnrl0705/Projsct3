package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

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
