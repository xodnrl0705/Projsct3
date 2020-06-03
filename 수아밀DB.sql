#회원테이블
CREATE TABLE membership(
	name VARCHAR(30) NOT NULL,  #이름
	id VARCHAR(30) NOT NULL,    #아이디
	pass VARCHAR(30) NOT NULL,  #비밀번호
	tel VARCHAR(20) NOT NULL,	 #전화번호
	phone VARCHAR(20) NOT NULL, #핸드폰번호
	email VARCHAR(30) NOT NULL, #이메일
	addr VARCHAR(30) NOT NULL,	 #주소
	regidate DATETIME DEFAULT CURRENT_TIMESTAMP(), #가입날짜
	grade VARCHAR(5) DEFAULT 1   		 #권한등급
);
ALTER TABLE membership ADD CONSTRAINT pk_member
	PRIMARY KEY(id);
SELECT * FROM membership;

#게시판테이블
create table multi_board (
    num int NOT NULL AUTO_INCREMENT,
    title VARCHAR(30) NOT NULL,
    content TEXT NOT NULL,
    id VARCHAR(30) NOT NULL,
    visitcount MEDIUMINT NOT NULL DEFAULT 0,
    bname VARCHAR(10) NOT NULL DEFAULT 'freeboard',
    postdate DATETIME DEFAULT CURRENT_TIMESTAMP,
    attachedfile VARCHAR(100),
    downcount MEDIUMINT NOT NULL default 0 ,
	 PRIMARY KEY (num)
);
SELECT * from multi_board; 

ALTER TABLE multi_board ADD CONSTRAINT fk_multi_board_member
	FOREIGN KEY(id) REFERENCES membership(id);
# 더미데이터
INSERT INTO membership (name,id,pass,tel,phone,email,addr,grade)
	VALUES('김태욱','kosmo','1234','111111','222222','asdf','1234asdf',10);
INSERT INTO membership (name,id,pass,tel,phone,email,addr,grade)
	VALUES('김태식','test1','1234','111111','222222','asdf','1234asdf',1);
	
INSERT INTO multi_board (title,content,id)
	VALUES('테스트글쓰기입니다1','테스트글쓰기입니다1','kosmo');
INSERT INTO multi_board (title,content,id)
	VALUES('테스트글쓰기입니다2','테스트글쓰기입니다2','kosmo');
INSERT INTO multi_board (title,content,id)
	VALUES('테스트글쓰기입니다3','테스트글쓰기입니다3','test1');
INSERT INTO multi_board (title,content,id)
	VALUES('테스트글쓰기입니다4','테스트글쓰기입니다4','kosmo');
INSERT INTO multi_board (title,content,id)
	VALUES('테스트글쓰기입니다5','테스트글쓰기입니다5','test1');
INSERT INTO multi_board (title,content,id)
	VALUES('테스트글쓰기입니다6','테스트글쓰기입니다6','kosmo');
INSERT INTO multi_board (title,content,id)
	VALUES('테스트글쓰기입니다7','테스트글쓰기입니다7','kosmo');
INSERT INTO multi_board (title,content,id,bname)
	VALUES('공지사항테스트1 ','테스트글쓰기입니다1','kosmo','notice');
	
SELECT * FROM membership
ORDER BY id DESC limit 0, 2;
