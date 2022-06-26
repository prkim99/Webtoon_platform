<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="MyBean.Ep" import="java.sql.*" import="java.text.*" errorPage="01_error.jsp"%>
     
<% Date date=new Date(System.currentTimeMillis());
  SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
  String ndate = formatter.format(date);
%>
<%
String sid=(String)session.getAttribute("id");
if (sid==null){
	out.println("<script>alert('먼저 로그인을 해주세요');history.back();</script>");
}

String wtid;
int epid;
wtid = request.getParameter("wtid"); 
if(request.getParameter("epid")!=null){
	   epid= Integer.parseInt(request.getParameter("epid")); 
	   //permission = Integer.parseInt(request.getParameter("permission")); 
}else{
	epid=0;
}

request.setCharacterEncoding("utf-8");

Class.forName("org.mariadb.jdbc.Driver");
String url = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";

Connection con = DriverManager.getConnection(url, "admin", "1234");

String sql = "select * from eplist_"+wtid+" where epid=?";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setInt(1,epid);


ResultSet rs = pstmt.executeQuery();



%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>웹툰 신규회차 등록/ 수정 페이지</title>
<link rel="stylesheet" type="text/css" href="commonStyle.css">
<style>

nav {
	background-color: #D6EAF8;
	padding: 1px;
	text-align: center;
}

section {
	display: table-cell;
	padding: 10px;
}

#prev {
	display: table-cell;
	background-color: LightGray;
	padding: 10px;
	border: 2px solid #2E86C1;
}

table {
	width: 900px;
}

th, td {
	padding: 15px;
}

.preView {
	width: 300px;
	height: 200px;
}
.preView2 {
	width: 300px;
	height: 600px;
}

</style>
<script>
function showAlert(){
	
	var obj=document.getElementById("EP");
	var str=""; /* 초기화 잊지말기 */
	str+="회차: "+obj.value+"\n";

	obj=document.getElementById("epTitle");
	str+="제목: "+obj.value+"\n";
	
	obj=document.getElementById("thumImg");
	str+="썸네일: "+obj.value+"\n";
	
	obj=document.getElementById("date");
	str+="날짜: "+obj.value+"\n";
	
	str+="회차 이미지: ";
	obj=document.getElementsByName("webtImg");
	for(var i=0;i<obj.length;i++) {
		str += obj[i].value+", ";
		}


	alert(str);
}


	
	function preview(input) {
		var name=input.name;
		  if (input.files && input.files[0]) {
		    var reader = new FileReader();
		    reader.onload = function(e) {
		    	if(name=="thumImg"){
		     		 document.getElementById('preview1').src = e.target.result;}
		    	else{
		    		document.getElementById('preview2').src = e.target.result;
		    	}
		    };
		    reader.readAsDataURL(input.files[0]);
		  } else {
		    document.getElementById('preview1').src = "";
		    document.getElementById('preview2').src = "";
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
	<% if(rs.next()){

int idx1=rs.getInt("epNum");
String title=rs.getString("eptitle");
String thumnail=rs.getString("epthumnail");
String content=rs.getString("contentimg");

Ep ep1 = new Ep();
ep1.setIdx(idx1);
ep1.setTitle(title);
ep1.setThumnail(thumnail);
ep1.setContent(content);


%>
	<nav>
		<h1>회차 수정</h1>
	</nav>
	<form method="post" action="Ep_modify.jsp?wtid=<%=wtid %>&epid=<%=epid %>" enctype="multipart/form-data">
	<div align="center" style="margin:10px;">
		<section >
<!-- 			<form action="#" method="post"> -->
				<table border="1" style="border-collapse: collapse">
					<tr>
						<th>회차</th>
						<td><input type="number" name="Ep" id="Ep" value="<%=ep1.getIdx() %>" readonly></td>
					</tr>
					<tr>
						<th>썸네일</th>
						<td>
							<input type="file" class="btn_sky" name="thumImg" id="thumImg" onchange="preview(this)">이미지 등록
						</td>
					</tr>

					<tr>
						<th>제목</th>
						<td><input type="text" name="epTitle" id="epTitle" value="<%=ep1.getTitle()%>"></td>
					</tr>
					<tr>
						<th>등록일</th>
						<td><input type="date" name="date" id="date"  value="<%=ndate%>" readonly></td>
					</tr>
					<tr height=300px>
						<th>그림파일</th>
						<td>
							<input type="file" class="btn_sky" name="contentImg" id="contentImg" onchange="preview(this)">이미지 등록</button>
						</td>
					</tr>
				</table>
<!-- 			</form> -->
		</section>
		<section id="prev">
			<img class="preView" id="preview1" title="썸네일 미리보기">
			<br>
			<img class="preView2" id="preview2" title="업로드 미리보기">
		</section>

	</div>			
	<footer style="text-align: center; padding:15px;">
		<button class="btn_navy" type="submit" onclick="showAlert()" >변경 완료</button>
		<input class="btn_navy" type="button" onclick="location.href='Home.jsp'" value="변경취소">
	</footer>
	</form>
	<% } else { 
		sql = "select count(*) from eplist_"+wtid+"";
		pstmt = con.prepareStatement(sql);
		rs = pstmt.executeQuery();
		rs.next();
%>
<form method="post" action="Ep_add.jsp?wtid=<%=wtid %>" enctype="multipart/form-data">
	
	<nav>
		<h1>회차 등록</h1>
	</nav>
	<div align="center" style="margin:10px;">
		<section >
<!-- 			<form action="#" method="post"> -->
				<table border="1" style="border-collapse: collapse">
					<tr>
						<th>회차</th>
						<td><input type="number" name="Ep" id="Ep" value="<%=rs.getInt(1)+1%>" readonly></td>
					</tr>
					<tr>
						<th>썸네일</th>
						<td>
							<input type="file" class="btn_sky" name="thumImg" id="thumImg" onchange="preview(this)">
						</td>
					</tr>

					<tr>
						<th>제목</th>
						<td><input type="text" name="epTitle" id="epTitle" placeholder="제목"></td>
					</tr>
					<tr>
						<th>등록일</th>
						<td><input type="date" name="date" id="date"  value="<%=ndate%>" readonly></td>
					</tr>
					<tr height=300px>
						<th>그림파일</th>
						<td>
							<input type="file" class="btn_sky" name="contentImg" id="contentImg" onchange="preview(this)">
						</td>
					</tr>
				</table>
		</section>
		<section id="prev">
			<img class="preView" display="block" id="preview1" title="썸네일 미리보기">
			<br>
			<img class="preView2" display="block" id="preview2" title="업로드 미리보기">
		</section>
	</div>
		

	<footer style="text-align: center; padding:15px;">
		<button class="btn_navy" type="submit" onclick="showAlert()" >등록 완료</button>
		<input class="btn_navy" type="button" onclick="location.href='Home.jsp'" value="등록취소">
	</footer></form>
	<%} %>
</body>
</html>