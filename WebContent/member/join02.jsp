<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<%
request.setCharacterEncoding("UTF-8");
%>

<script>
function isValidate(f){
	var reg1 = /^[a-z0-9]{4,12}$/;    // a-z 0-9 중에 7자리 부터 14자리만 허용 한다는 뜻이구요
	var reg2 = /[a-z]/g;    
	var reg3 = /[0-9]/g;
	
	if(f.name.value==''){
		alert('이름을 입력하세요');
		f.name.focus();
		return false;
	}
	if(f.id.value==''){
		alert('아이디를 입력하세요');
		f.id.focus();
		return false;
	}
	var idCheck = reg1.test(f.id.value) && reg2.test(f.id.value) && reg3.test(f.id.value);
	console.log("아이디검사:" + idCheck);
	if(idCheck == false){ 
        alert('아이디는 숫자와 영문자 조합으로 4~12자리를 사용해야 합니다.'); 
        f.id.focus();
        return false;
	}
	
	if(f.pass.value==''){
		alert('비밀번호를 입력하세요');
		f.pass.focus();
		return false;
	}
	
	var passCheck = reg1.test(f.pass.value) && reg2.test(f.pass.value) && reg3.test(f.pass.value);
	console.log("비밀번호검사:" + passCheck);
	if(passCheck == false){
        alert('비밀번호는 숫자와 영문자 조합으로 4~12자리를 사용해야 합니다.'); 
		f.pass.focus();
        return false;
	}
	if(f.pass2.value==''){
		alert('비밀번호를 확인해주세요');
		f.pass2.focus();
		return false;
	}
	
	if(f.tel1.value==''||f.tel2.value==''||f.tel3.value==''){
		alert('전화번호를 확인해주세요.');
		f.tel1.focus();
		return false;
	}
	if(f.mobile1.value==''||f.mobile2.value==''||f.mobile3.value==''){
		alert('핸드폰번호를 확인해주세요.');
		f.mobile1.focus();
		return false;
	} 
	if(f.email_1.value==''){
		alert('이메일을 입력해주세요');
		f.email_1.focus();
		return false;
	}
	if(f.last_email_check2.selectedIndex == 0||f.email_2.value==''){
        alert("이메일주소를 선택하거나 직접입력해주세요.");
        f.last_email_check2.focus();
        return false;
    }
	if(f.zip1.value ==''){
        alert("우편번호를 입력해주세요.");
        execDaumPostcode();
        /* f.zip1.focus(); */
        return false;
    }
	if(f.addr2.value ==''){
        alert("상세주소를 입력해주세요.");
		f.addr2.focus();
        /* f.zip1.focus(); */
        return false;
    }
	if(f.pass.value != f.pass2.value){
		alert('비밀번호가 일치하지 않습니다.');
		f.pass2.value='';
		f.pass2.focus();
		return false;
	}
	if(f.idcheck.value !=f.id.value){
		alert('중복확인을 확인해주세요');
		return false;
	}
}

$(function() {//이메일 select에서 선택할시 발생되는 change
	$('#last_email_check2').change(function() {
		
		var text = $('#last_email_check2 option:selected').text(); //선택한이메일의 text값
		var value = $('#last_email_check2 option:selected').val(); //선택한이메일의 value값을 읽어온다.
		//alert("선택한 항목의 text:"+text+", value:"+value);
		
		if(value == ''){//선택해주세요일 경우
			$('#email_2').val('');//이메일입력 2번째부분에 값을 빈칸을 넣고,
			$('#email_2').attr('readonly',true);//읽기전용으로 바꾼다.
		}
		else if(value == 'direct'){//직접입력일 경우
			$('#email_2').val('');//이메일입력 2번째부분에 값을 빈칸을 넣고,
			$('#email_2').attr('readonly',false);//쓸수있게 바꾼다.
		}
		else{ //그 외 경우
			$('#email_2').val(value);//이메일입력 2번째부분에 선택한 이메일 값을 넣고,
			$('#email_2').attr('readonly',true);//읽기전용으로 바꾼다
		}
	});

	$('#pass').keyup(function(){
		
		$('#pass2').val('');
		$('#msg').html('');
		
	});
	
	$('#pass2').keyup(function() {
		var comparePass1 = $('#pass').val();
		var comparePass2 = $('#pass2').val();
		
		if(comparePass1 == comparePass2){
			//암호가 일치하면 파란색 텍스트
			$('#msg').html('<b>암호가일치합니다.</b>').css('color','blue');
		}
		else{
			//일치하지 않으면 붉은색 텍스트
			$('#msg').html('<b>*암호가일치하지않습니다.*</b>').css('color','red');
		}
	});
});

function idCheck(){
	var f = document.loginfrm.id;
    if(f.value==""||f.value==null){//중복체크시 입력된 아이디가 없다면...
        alert("아이디를 입력후 중복확인을 눌러주세요");
        f.focus();
    }
    else{
        //f.readOnly = true;//아이디를 입력한 경우라면 입력필드를 readonly로 변경하고 팝업창을 띄운다.
    	//중복확인창을 띄울때 입력한 아이디를 파라미터로 전달한다.
        window.open("./overappingProc.jsp?id="+f.value,
                "idover","width=300,height=200");
    }
}

//우편번호검색 API
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                // 조합된 참고항목을 해당 필드에 넣는다.
                document.getElementById("sample6_extraAddress").value = extraAddr;
            
            } else {
                document.getElementById("sample6_extraAddress").value = '';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('zip1').value = data.zonecode;
            document.getElementById("addr1").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("addr2").focus();
        }
    }).open();
}
</script>
<body>
	<!-- <center>-->
	<div id="wrap" class="mx-auto">
		<%@ include file="../include/top.jsp" %>

		<img src="../images/member/sub_image.jpg" id="main_visual" />
		
		<div class="contents_box">
			<div class="left_contents">
				<%@ include file = "../include/member_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<img src="../images/join_tit.gif" alt="회원가입" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;멤버쉽&nbsp;>&nbsp;회원가입<p>
				</div>
				<p class="join_title"><img src="../images/join_tit03.gif" alt="회원정보입력" /></p>
				
				<form name="loginfrm" method="post" action="joinProc.jsp" onsubmit="return isValidate(this);">
				<!-- 회원가입 정보 입력 부분 -->
				<table cellpadding="0" cellspacing="0" border="0" class="join_box">
					<colgroup>
						<col width="80px;" />
						<col width="*" />
					</colgroup>
					<tr>
						<th><img src="../images/join_tit001.gif" /></th>
						<td><input type="text" name="name" value="" class="join_input" /></td>
					</tr>
					<tr>
						<th><img src="../images/join_tit002.gif" /></th>
						<td><input type="text" name="id" id="id" value="" class="join_input" />&nbsp;<a href = "#" onclick = "idCheck(); return false;" style="cursor:hand;"><img src="../images/btn_idcheck.gif" alt="중복확인"/></a>&nbsp;&nbsp;<span id = "id_check">* 4자 이상 12자 이내의 영문/숫자 조합하여 공백 없이 기입</span></td>
						<input type ="hidden" name = "idcheck" id = "idcheck" value = "f">
					</tr>
					<tr>
						<th><img src="../images/join_tit003.gif" /></th>
						<td><input type="password" name="pass" id="pass" value="" class="join_input" />&nbsp;&nbsp;<span>* 4자 이상 12자 이내의 영문/숫자 조합</span></td>
					</tr>
					<tr>
						<th><img src="../images/join_tit04.gif" /></th>
						<td><input type="password" name="pass2" id="pass2" value="" class="join_input" />&nbsp;&nbsp;<span id="msg"></span></td>
					</tr>
					<tr>
						<th><img src="../images/join_tit06.gif" /></th>
						<td>
							<input type="text" name="tel1" value="" maxlength="3" class="join_input" style="width:50px;" />&nbsp;-&nbsp;
							<input type="text" name="tel2" value="" maxlength="4" class="join_input" style="width:50px;" />&nbsp;-&nbsp;
							<input type="text" name="tel3" value="" maxlength="4" class="join_input" style="width:50px;" />
						</td> 
					</tr>
					<tr>
						<th><img src="../images/join_tit07.gif" /></th>
						<td>
							<input type="text" name="mobile1" value="" maxlength="3" class="join_input" style="width:50px;" />&nbsp;-&nbsp;
							<input type="text" name="mobile2" value="" maxlength="4" class="join_input" style="width:50px;" />&nbsp;-&nbsp;
							<input type="text" name="mobile3" value="" maxlength="4" class="join_input" style="width:50px;" /></td>
					</tr>
					<tr>
						<th><img src="../images/join_tit08.gif" /></th>
						<td>
 
	<input type="text" name="email_1" id="email_1" style="width:100px;height:20px;border:solid 1px #dadada;" value="" /> @ 
	<input type="text" name="email_2" id="email_2" style="width:150px;height:20px;border:solid 1px #dadada;" value="" readonly />
	<select name="last_email_check2"  class="pass" id="last_email_check2" >
		<option selected="" value="">선택해주세요</option>
		<option value="direct" >직접입력</option>
		<option value="hanmail.net" >hanmail.net</option>
		<option value="hotmail.com" >hotmail.com</option>
		<option value="msn.co.kr" >msn.co.kr</option>
		<option value="nate.com" >nate.com</option>
		<option value="naver.com" >naver.com</option>
		<option value="google.com" >google.com</option>
	</select>
	 
						<input type="checkbox" name="open_email" value="yes">
						<span>이메일 수신동의</span></td>
					</tr>
					<tr>
						<th><img src="../images/join_tit09.gif" /></th>
						<td>
						<input type="text" name="zip1" id="zip1" placeholder="우편번호" class="join_input" style="width:70px;" readonly="readonly"/>
						<a href="javascript:;" title="새 창으로 열림" onclick="execDaumPostcode();">[우편번호검색]</a>
						<br/>
						
						<input type="text" name="addr1" id="addr1" placeholder="주소" class="join_input" style="width:550px; margin-top:5px;" readonly="readonly"/><br>
						<input type="text" name="addr2" id="addr2" placeholder="상세주소" class="join_input" style="width:550px; margin-top:5px;" />
						<input type="hidden" name="sample6_extraAddress" id="sample6_extraAddress" placeholder="참고항목" class="join_input" style="width:550px; margin-top:5px;" />
						
						</td>
					</tr>
				</table>
				<p style="text-align:center; margin-bottom:20px"><input style="border: 0;" type="image" src="../images/btn01.gif" />&nbsp;&nbsp;<a href="../main/main.jsp"><img src="../images/btn02.gif" /></a></p>
			</form>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	<!-- </center> -->
 </body>
 
</html>
