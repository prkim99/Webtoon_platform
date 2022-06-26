<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" type="text/css" href="commonStyle.css">
</head>
<body>
		<header>
			<h1>
				<div onclick="location.href='Home.jsp'"><img class="homeImg" src="images/home-button.png" title="nature1" >PARANG
			WEBTOON</div>
				<div style="text-align: right">
				<form action="Search.jsp">
					<input  name="query" type="text"   title="검색어를 입력하시오">
					<button type="submit" class="btn_navy" >검색</button>
					<input type="button" class="btn_navy" value="웹툰 등록" onclick="location.href='WebtoonSet.jsp?'">
				</form>
				</div>
			</h1>
		</header>
		<%if(request.getParameter("p")==null){ %>
<div align="center" align-items="center">
<form action="memberConfirm.jsp" method="post" >
	<label for="id">&nbsp;아이디&nbsp;</label>
	<input type="text" name="id" id="id" placeholder="아이디" required />
	<br>
	<br>
	<label for="pass">비밀번호</label>
	<input type="password" name="pass" id="pass" placeholder="비밀번호" required />
	<br>
	<br><br>
	<input class="btn_sky" type="submit" value="로그인" />
</form>
</div>
<%} else{ %>
<div align="center" align-items="center">
<form action="Register.jsp" method="post" >
	<label for="id">&nbsp;아이디&nbsp;</label>
	<input type="text" name="id" id="id" placeholder="아이디" title="영숫자 5자리 이내" pattern="[a-zA-Z0-9]{1,5}" required />
	<br>
	<br>
	<label for="pass">비밀번호</label>
	
	<input type="password" name="pass" id="pass" placeholder="비밀번호" title="영숫자 6~20자리" pattern="[a-zA-Z0-9]{6,20}" required />
	<br>
	
	<br>
		<label for="pass">비밀번호 확인</label>
	<input type="password" name="pass_" id="pass_" placeholder="비밀번호 확인" required />
	<br><br><br>
	<input class="btn_sky" type="submit" value="회원가입" />
</form>
</div>
<%} %>
</body>
</html>