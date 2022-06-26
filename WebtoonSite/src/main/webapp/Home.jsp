<%@ page language="java" contentType="text/html; charsetㅇ=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>웹툰 만화 콘텐츠 관리 프로그램 홈</title>
<link rel="stylesheet" type="text/css" href="commonStyle.css">
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
		<section>
			<div class="webtoons">
			<% 
			Class.forName("org.mariadb.jdbc.Driver");
			String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
					//★주의 : mydb를 자신이 생성한 DB이름으로 변경하여 테스트 할것~!

			String DB_USER = "admin";
			String DB_PASSWORD= "1234";

			Connection con= null;
			Statement stmt = null;
			ResultSet rs   = null;

			try {
			    
				//3. 연결자를 생성한다.
			    con = DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD);

			    //4. Statement 객체를 생성한다.
			    stmt = con.createStatement();

			    
			    String query = "SELECT wtid, title, writer, genre, thumnail, permission FROM wtList"; 
			    
			    //5.쿼리를 전달하고, ResultSet 객체를 반환 받는다.
			    rs = stmt.executeQuery(query);

			while(rs.next()) {%>
				<article>
					<img class="thumnail" src="./upload/<%=rs.getString("thumnail")%>" title="<%=rs.getString("title")%>" onclick="location.href='WebtoonDetail.jsp?wtid=<%=rs.getInt("wtid")%>'">
					<h1 onclick="location.href='WebtoonDetail.jsp?wtid=<%=rs.getInt("wtid")%>'"><%=rs.getString("title")%> </h1>
					<p><%= rs.getString("writer") %></p>
					<p style="color:blue"><%= rs.getString("genre") %></p>
				</article>
				<%} 
				rs.close();
	stmt.close();
	con.close();
}catch(SQLException e) {
	out.println(e);
}
%>
			</div>
		</section>
</body>
</html>