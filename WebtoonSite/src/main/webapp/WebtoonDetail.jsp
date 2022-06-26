<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>
  <%

	int  wtid = 0;
  	 
    wtid = Integer.parseInt(request.getParameter("wtid")); 
	
    request.setCharacterEncoding("utf-8");
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";

	Connection con = DriverManager.getConnection(url, "admin", "1234");

	String sql = "select * from wtlist where wtid=?";
	PreparedStatement pstmt = con.prepareStatement(sql);
	
	pstmt.setInt(1,wtid);

	ResultSet rs = pstmt.executeQuery();

	rs.next();
	
	String sid=(String)session.getAttribute("id");
	int permit=0;
	if (sid!=null){
		if(sid.equals(rs.getString("permission")) || sid.equals("admin") ){
			permit=1;
		}
	}


%>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>웹툰 상세 페이지</title>
<link rel="stylesheet" type="text/css" href="commonStyle.css">
<style>
nav {
	background-color: #D6EAF8;
	padding: 1px;
	text-align: center;
}
</style>
<script>
window.onload=function(){
	var obj =document.getElementsByName("genre");
	var genName =document.getElementById("selGenre");
	var val ="<%=rs.getString("genre")%>";
	var genList=["교육","	액션","일상","스릴러","판타지","로맨스"];
	for(var i=0;i<obj.length;i++){
		if(val==obj[i].value){
			obj[i].checked=true;
			genName.innerHTML=genList[i];
		}
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
					<br> <br>
					<%if(session.getAttribute("id")==null){%>	
					<input type="button" class="btn_sky" value="로그인" onclick="location.href='Login.jsp'">
					<input type="button" class="btn_sky" value="회원가입" onclick="location.href='Login.jsp?p=1'">			<%
		}else{%><br><%=(String)session.getAttribute("id")%>님 환영합니다!&nbsp;&nbsp;&nbsp;<input type="button" class="btn_sky" value="로그아웃" onclick="location.href='Logout.jsp'"><%} %>
				</form>
				</div>
		</h1>
	</header>

	<section >
	<table >
	<tr >
		<td> <img class="thumnail" id="nWebThum" src="./upload/<%=rs.getString("thumnail")%>" title="thumnailPreview" style="width: 300px; height: 200px"></td>
		<td width="10"> </td>
		<td width="340">
		<h1><%=rs.getString("title")%></h1>
		<h3><%=rs.getString("writer")%>  &nbsp;&nbsp; <%=rs.getString("wnote")%></h3>
		<div style="display:none;">
			<input type="radio"  name="genre" value="education">교육
			<input type="radio"  name="genre" value="action">액션
			<input type="radio"  name="genre" value="daily">일상
			<input type="radio"  name="genre" value="thriller">스릴러
			<input type="radio"  name="genre" value="fantasy">판타지
			<input type="radio"  name="genre" value="romance">로맨스 
		</div>
		<p id="selGenre"></p>
		<h4><%=rs.getString("summary")%></h4>
	</td>
	<%if(permit==1){%>
	<td  align="start">
		<button class="btn_navy" type="submit" onclick="location.href='WebtoonSet.jsp?wtid=<%=wtid %>'" >웹툰 수정</button>    
		&nbsp;<button class="btn_navy" type="button" onclick="location.href='Wt_delete.jsp?wtid=<%=wtid %>'">웹툰삭제</button>
		<br>
		<br>
		<br>
		<br>
		<button class="btn_navy" type="button" onclick="location.href='EpisodeSet.jsp?wtid=<%=wtid %>'" >회차등록</button>
	</td>
	<%} %>
</tr>
</table>
		</section>
		
		<table border="1" style="border-collapse:collapse;">
		<tr>
		<th width="150">썸네일</th>
		<th width="100">회차</th>
		<th width="400">제목</th>
		<th width="100">등록일</th>
		<th width="50">관리</th>
		</tr>
		<%
			sql = "SELECT * FROM epList_"+wtid; 
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1,wtid);
			rs = pstmt.executeQuery();
		
		 while(rs.next()) {%>
		<tr style="text-align:center" >
			<td onclick="location.href='Episode.jsp?wtid=<%=wtid%>&epid=<%=rs.getInt("epid")%>'">
			<img class="epthumnail" src="./upload/content/<%=rs.getString("epthumnail")%>" title="<%=rs.getString("eptitle")%>" width= "150px" height="100px"></td>
			<td onclick="location.href='Episode.jsp?wtid=<%=wtid%>&epid=<%=rs.getInt("epid")%>'">
			<%=rs.getString("epNum")%></td>
			<td onclick="location.href='Episode.jsp?wtid=<%=wtid%>&epid=<%=rs.getInt("epid")%>'">
			<%=rs.getString("eptitle")%></td>
			<td onclick="location.href='Episode.jsp?wtid=<%=wtid%>&epid=<%=rs.getInt("epid")%>'">
			<%=rs.getString("date")%></td>
			<%if(permit==1){%>
			<td style="align-items : center"><button type="button" class="btn_sky" onclick="location.href='EpisodeSet.jsp?epid=<%=rs.getInt("epid")%>&wtid=<%=wtid%>'" margin="">회차수정</button> 
			<button type="button" class="btn_sky" onclick="location.href='Ep_delete.jsp?epid=<%=rs.getInt("epid")%>&wtid=<%=wtid%>'">회차 삭제</button>
			<%} %>
			</td>
		</tr>
<%}%>
		</table>
</body>
</html>