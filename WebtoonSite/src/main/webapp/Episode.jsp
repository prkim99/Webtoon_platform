<%@ page contentType="text/html; charset=UTF-8"
    import="MyBean.Ep" import="java.sql.*" errorPage="01_error.jsp"%>
<%
String wtid;
int epid=0;
	 
wtid = request.getParameter("wtid"); 
epid =Integer.parseInt(request.getParameter("epid"));
request.setCharacterEncoding("utf-8");

Class.forName("org.mariadb.jdbc.Driver");
String url = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";

Connection con = DriverManager.getConnection(url, "admin", "1234");

String sql = "select * from eplist_"+wtid+" where epid=?";
PreparedStatement pstmt = con.prepareStatement(sql);

pstmt.setInt(1,epid);

ResultSet rs = pstmt.executeQuery();

rs.next();


request.setCharacterEncoding("utf-8");

int idx1=rs.getInt("epNum");
String title=rs.getString("eptitle");
String date=rs.getString("date");
String thumnail=rs.getString("epthumnail");
String content=rs.getString("contentimg");

Ep ep1 = new Ep();
ep1.setIdx(idx1);
ep1.setTitle(title);
ep1.setDate(date);
ep1.setThumnail(thumnail);
ep1.setContent(content);

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>웹툰 회차 열람</title>
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

table {
	width: 900px;
}


</style>
<script>
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
	<div align="center" style="margin:10px;">
		<section >
				<table border="1" style="border-collapse: collapse">
					<tr>
						<th width="100"><%=ep1.getIdx() %>화</th>
						<th width="500"><%=ep1.getTitle() %></th>
						<th width="150"><%=ep1.getDate() %></th>
					</tr>
					</table>
					
					<table>
					<tr height="20"></tr>
					<tr>
					<td align="center"><img class="content" id="content" src="./upload/content/<%=ep1.getContent()%>"  style="width: 750px;"></td>
					</tr>
				</table>
		</section>
	</div>
</body>
</html>