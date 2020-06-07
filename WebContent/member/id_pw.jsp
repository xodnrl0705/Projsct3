<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>
<script>

//id를 찾는 버튼을 클릭했을때 이름과 이메일이 db에 있으면 해당 아이디를 찾아주고 없으면 없다고 알려주는 ajax를이용한 jQuery문
$(function(){
	$('#idfindBtn').click(function(){//버튼을 클릭했을때
		//id속성으로 사용자가 입력한 이름과 이메일값을 저장. 
		var vName = $('#user_name1').val();
		var vEmail = $('#user_email1').val();
		
		//이름과 이메일에 대한 유효성검사
		if(vName == ''){
			alert('이름을 입력해주세요!');
			document.getElementById('user_name1').focus();
			return false;
		}
		if(vEmail == ''){
			alert('이메일을 입력해주세요!');
			document.getElementById('user_email1').focus();
			return false;
		}
			
		//입력한 이름과 이메일을 가지고 id를 찾아주는 idfindProc.jsp로 보내준다.	idfindProc.jspㄱㄱ
		$.ajax({
			url : './idfindProc.jsp',
			type : 'get',
			data : {
				name : vName,
				email : vEmail,
				idORpass : 'id'
			},	
			//요청성공시의 콜백메소드
			success : function(resData){
				alert(resData);
				document.getElementById('user_name1').focus();
			},
			//요청실패시 콜백메소드는 외부 JS함수로 정의됨.
			error : errFunc
		});
	});
	
	//pass워드를 찾는 버튼을 클릭했을때 마찬가지로 찾아주고 있으면 이메일로 비밀번호를 보내주는 jQuery문(json을사용)
	$('#passfindBtn').click(function(){//버튼을 클릭했을때
		//id속성으로 사용자가 입력한 이름과 이메일값을 저장. 
		var vId = $('#user_id').val();
		var vName = $('#user_name2').val();
		var vEmail = $('#user_email2').val();
		
		//이름과 이메일에 대한 유효성검사
		if(vId == ''){
			alert('아이디를 입력해주세요!');
			document.getElementById('user_id').focus();
			return false;
		}
		if(vName == ''){
			alert('이름을 입력해주세요!');
			document.getElementById('user_name2').focus();
			return false;
		}
		if(vEmail == ''){
			alert('이메일을 입력해주세요!');
			document.getElementById('user_email2').focus();
			return false;
		}
			
		//입력한 이름과 이메일을 가지고 id를 찾아주는 idfindProc.jsp로 보내준다.	idfindProc.jspㄱㄱ
		$.ajax({
			url : './idfindProc.jsp',
			type : 'get',
			data : {
				id : vId,
				name : vName,
				email : vEmail,
				idORpass : 'pass'
			},	
			//요청성공시의 콜백메소드
			success : function(resData){
				var d = JSON.parse(resData);//json형태의 받은 데이터를 잘라준다.
				alert(d.msg);
				
				if(d.result == 0){
					document.getElementById('user_id').focus();//다시입력하기 편하도록 커서이동
				}
				/* else{
					var vId = $('#user_id').val('');
					var vName = $('#user_name2').val('');
					var vEmail = $('#user_email2').val('');
				} */
			},
			//요청실패시 콜백메소드는 외부 JS함수로 정의됨.
			error : errFunc
		});
	});
});

function errFunc() {
	alert("에러발생. 디버깅하세욤.");
	return false;
	
}

</script>
<style>
	form{
	display: inline;
	}
</style>
 <body>
	<center>
	<div id="wrap">
		<%@ include file="../include/top.jsp" %>
		<img src="../images/member/sub_image.jpg" id="main_visual" />
		<div class="contents_box">
			<div class="left_contents">
				<%@ include file = "../include/member_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<img src="../images/member/id_pw_title.gif" alt="" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;멤버쉽&nbsp;>&nbsp;아이디/비밀번호찾기<p>
				</div>
				<div class="idpw_box">
					<div class="id_box">
						<ul>
							<li><input type="text" name="user_name1" id="user_name1" value="" class="login_input01" /></li>
							<li><input type="text" name="user_email1" id="user_email1" value="" class="login_input01" /></li>
						</ul>
						<input type="image" id="idfindBtn" src="../images/member/id_btn01.gif" class="id_btn" />
						<a href="join01.jsp"><img src="../images/login_btn03.gif" class="id_btn02" /></a>
					</div>
					<div class="pw_box">
						<ul>
							<li><input type="text" name="user_id" id="user_id" value="" class="login_input01" /></li>
							<li><input type="text" name="user_name2" id="user_name2" class="login_input01" /></li>
							<li><input type="text" name="user_email2" id="user_email2" value="" class="login_input01" /></li>
						</ul>
						<input type="image" id="passfindBtn" src="../images/member/id_btn01.gif" class="pw_btn" />
					</div>
				</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>
