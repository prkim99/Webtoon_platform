<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" errorPage="01_error.jsp"%>
  <%
  String sid=(String)session.getAttribute("id");
  if (sid==null){
  	out.println("<script>alert('먼저 로그인을 해주세요');history.back();</script>");
  }
  int wtid= 0;
  int permission=0;
  if(request.getParameter("wtid")!=null){
	  wtid = Integer.parseInt(request.getParameter("wtid")); 
	   //permission = Integer.parseInt(request.getParameter("permission")); 
  }
 

	request.setCharacterEncoding("utf-8");
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";

	Connection con = DriverManager.getConnection(url, "admin", "1234");

	String sql = "select * from wtlist where wtid=?;";
	PreparedStatement pstmt = con.prepareStatement(sql);
	
	pstmt.setInt(1,wtid);

	 ResultSet rs = pstmt.executeQuery();

	//[문4] 레코드 오프셋 커서 이동
	//rs.next();
   %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>웹툰 등록/ 수정 페이지 </title>
<link rel="stylesheet" type="text/css" href="commonStyle.css">
<style>
nav {
	background-color: #D6EAF8;
	padding: 1px;
	text-align: center;
}
</style>
<script>
function showAlert(){
	var obj=document.getElementById("nWebTitle");
	var str=""; /* 초기화 잊지말기 */
	str+="제목: "+obj.value+"\n";

	obj=document.getElementById("nWebAuthor");
	str+="작가: "+obj.value+"\n";
	
	obj=document.getElementById("nWebAuthor_s");
	str+="작가의 말: "+obj.value+"\n";
	
	str+="장르: "
	obj = document.getElementsByName("genre");
	for(var i in obj) {
	if(obj[i].checked) 
	str += obj[i].value+"\n";
	}
	
	obj=document.getElementById("nWebSummary");
	str+="줄거리: "+obj.value+"\n";

	alert(str);
}

<% if (rs.next()){%>
window.onload=function(){
	var obj =document.getElementsByName("genre");
	var val ="<%=rs.getString("genre")%>";
	for(var i=0;i<obj.length;i++){
		if(val==obj[i].value){
			obj[i].checked=true;
		}
	}
}
<%}%>

function preview(input) {
	  if (input.files && input.files[0]) {
	    var reader = new FileReader();
	    reader.onload = function(e) {
	      document.getElementById('nWebThum').src = e.target.result;
	    };
	    reader.readAsDataURL(input.files[0]);
	  } else {
	    document.getElementById('nWebThum').src = "";
	  }
	}
</script>
</head>
<body>
	<header>
		<h1>
			<div onclick="location.href='Home.jsp'"><img class="homeImg" src="images/home-button.png" title="nature1" >PARANG
			WEBTOON</div>
				<div style="text-align: right; font-size: 15px; text-shadow:none">
				<form action="Search.jsp">
					<input  name="query" type="text"   title="검색어를 입력하시오">
					<button type="submit" class="btn_navy" >검색</button>
					<input type="button" class="btn_navy" value="웹툰 등록" onclick="location.href='WebtoonSet.jsp?'">
					<br>
					<br>
					<%if(session.getAttribute("id")==null){%>	
					<input type="button" class="btn_sky" value="로그인" onclick="location.href='Login.jsp'">
					<input type="button" class="btn_sky" value="회원가입" onclick="location.href='Login.jsp?p=1'">			<%
		}else{%><br><%=(String)session.getAttribute("id")%>님 환영합니다!&nbsp;&nbsp;&nbsp;<input type="button" class="btn_sky" value="로그아웃" onclick="location.href='Logout.jsp'"><%} %>
				</form>
				</div>
		</h1>
	</header>
	<% if(wtid!=0){
	%>
<form action="Wt_modify.jsp?wtid=<%=wtid %>" method="post" enctype="multipart/form-data">
	
		<nav>
			<h1>웹툰 수정</h1>
	</nav>
	<table>
	<tr>
		<td> <img class="thumnail" id="nWebThum" src="./upload/<%=rs.getString("thumnail")%>" title="thumnailPreview" style="width: 300px; height: 200px"><br>
			<input type="file" class="btn_sky" name="ThumUP" value="이미지 업로드" onchange="preview(this)"></td>
			<td></td>
		<td>
		<p><input type="text" name="nWebTitle" id="nWebTitle" value="<%=rs.getString("title")%>"></p>	
		<p><input type="text" name="nWebAuthor" id="nWebAuthor" value="<%=rs.getString("writer")%>">     <input type="text" name="nWebAuthor_s" id="nWebAuthor_s" value="<%=rs.getString("wnote")%>"></p>
		<p>
<input type="radio"  name="genre" value="education" >교육
<input type="radio"  name="genre" value="action">액션
<input type="radio"  name="genre" value="daily">일상
<input type="radio"  name="genre" value="thriller">스릴러
<input type="radio"  name="genre" value="fantasy">판타지
<input type="radio"  name="genre" value="romance">로맨스
</p>
		<p><input type="text" name="nWebSummary" id="nWebSummary" value="<%=rs.getString("summary")%>"></p>
		</td>
		<td align="start">
		<button class="btn_navy" type="submit" onclick="showAlert()" >수정 완료</button>
		<br>
		<br>
		<input class="btn_navy" type="button" onclick="location.href='Home.jsp'" value="수정 취소">
		</td>
		</tr>
		</table>
</form>

<%} else { 
%>
<form action="Wt_add.jsp?wtid=<%=wtid %>" method="post" enctype="multipart/form-data">

		<nav>
			<h1>신규 웹툰 등록</h1>
	</nav>
	<table>
	<tr>
		<td> <img class="thumnail" id="nWebThum"  title="thumnailPreview" style="width: 300px; height: 200px"><br>
			<input type="file" class="btn_sky" name="ThumUP" value="이미지 업로드"onchange="preview(this)"></td>
			<td></td>
		<td>
		<p><input type="text" name="nWebTitle" id="nWebTitle" placeholder="제목"></p>	
		<p><input type="text" name="nWebAuthor" id="nWebAuthor" placeholder="작가">     <input type="text" name="nWebAuthor_s" id="nWebAuthor_s" placeholder="작가의 말"></p>
		<p>
<input type="radio"  name="genre" value="education" >교육
<input type="radio"  name="genre" value="action">액션
<input type="radio"  name="genre" value="daily">일상
<input type="radio"  name="genre" value="thriller">스릴러
<input type="radio"  name="genre" value="fantasy">판타지
<input type="radio"  name="genre" value="romance">로맨스
</p>
		<p><input type="text" name="nWebSummary" id="nWebSummary" placeholder="줄거리"></p>
		</td>
		<td style="vertical-align: top; padding: 50px;">
		<button class="btn_navy" type="submit" onclick="showAlert()" >등록 완료</button>
		<br>
		<br>
		<br>
		<br>
		<input class="btn_navy" type="button" onclick="location.href='Home.jsp'" value="등록취소">
		</td>
		</tr>
		</table>
</form>
<%} %>
</body>
</html>