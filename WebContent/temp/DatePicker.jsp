<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>


<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="./jquery-ui-1.12.1/datepicker-ko.js"></script>


<script>
  $( function() {
    $( "#datepicker" ).datepicker();
  } );
  
  
</script>
</head>
<body>
<p>Date: <input type="text" id="datepicker" size="30"></p>
 
<form action="test.jsp" method="get">
	<table>
		<tr>
			<th class="text-center" style="vertical-align:middle;">일정날짜</th>
			<td>
				<input type="date" name="date" id="date" size="30"/>
			</td>
		</tr>
		<tr>
			<th class="text-center" style="vertical-align:middle;">문자</th>
			<td>
				<input type="text" name="tet" id="tet" size="30"/>
			</td>
		</tr>
		<tr>
			<td>
				<input type="submit" name = "send" id = "send"/>
			</td>
		</tr>
	</table>
</form>


</body>
</html>