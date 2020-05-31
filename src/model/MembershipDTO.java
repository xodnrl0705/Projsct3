package model;

import java.sql.Date;

public class MembershipDTO {
	
	//멤버변수 : 정보은닉을 위해 private으로 선언함.
	private String name;
	private String id; 
	private String pass;
	private String tel;
	private String phone;
	private String email;
	private String zip;
	private String addr;
	private java.sql.Date regidate;
	private String grade;
	private String emailcheck;
	
	//기본생성자
	public MembershipDTO() {}
	
	//인자생성자
	public MembershipDTO(String name, String id, String pass, String tel, String phone, String email, String addr,
			String zip, Date regidate, String grade, String emailcheck) {
		super();
		this.name = name;
		this.id = id;
		this.pass = pass;
		this.tel = tel;
		this.phone = phone;
		this.email = email;
		this.addr = addr;
		this.zip = zip;
		this.regidate = regidate;
		this.grade = grade;
		this.emailcheck = emailcheck; 
	}
	
	//getter/setter
	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPass() {
		return pass;
	}

	public void setPass(String pass) {
		this.pass = pass;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public String getPhone() {
		return phone;
	}

	public String getZip() {
		return zip;
	}

	public void setZip(String zip) {
		this.zip = zip;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public java.sql.Date getRegidate() {
		return regidate;
	}

	public void setRegidate(java.sql.Date regidate) {
		this.regidate = regidate;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getEmailcheck() {
		return emailcheck;
	}

	public void setEmailcheck(String emailcheck) {
		this.emailcheck = emailcheck;
	}
}
