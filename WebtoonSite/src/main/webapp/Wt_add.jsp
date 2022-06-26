<%@ page contentType="text/html; charset=UTF-8" 
		import="java.util.*,MyBean.multipart.*"
		import="java.sql.*, java.io.*" errorPage="01_error.jsp"
		
%>

<%
request.setCharacterEncoding("utf-8");

Class.forName("org.mariadb.jdbc.Driver");
String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
String DB_USER = "admin";
String DB_PASSWORD= "1234";

String sid=(String)session.getAttribute("id");
//upload 이름을 가지는 실제 서버의 경로명 알아내기 
ServletContext context = getServletContext();
String realFolder = context.getRealPath("upload");

//[문4]. multipart/form-data 유형의 클라이언트 요청에 대한 모든 Part 구성요소를 가져옴.
Collection<Part> parts = request.getParts();

MyMultiPart multiPart = new MyMultiPart(parts,realFolder);

String FileName="";

if(multiPart.getMyPart("ThumUP") != null) {  //클라이언트에서 업로드한 파일이 없으면 null 임
	//[문5]. 클라이언트가 전송한 원래 파일명 알아내기	
	//[문6]. 서버에 저장된 파일 이름 알아내기(UUID적용된 파일명)
	FileName =  multiPart.getSavedFileName("ThumUP");
}


//DB 연결자 생성(이곳에 빈즈나 Connection Pool로 대체 가능)
Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	
//[문7]. id, name, pwd, originalFileName, savedFileName을 저장하기 위한 insert 문자열 구성
String sql = "insert into wtlist(title, writer, genre, thumnail, summary, wnote, permission)"+"values(?,?,?,?,?,?,?)";
	
PreparedStatement pstmt = con.prepareStatement(sql);
//사용자가 파라미터에 전송한 값 알아내기

String snWebTitle=request.getParameter("nWebTitle");
String snWebAuthor=request.getParameter("nWebAuthor");
String snWebAuthor_s=request.getParameter("nWebAuthor_s");
String sgenre=request.getParameter("genre");
String snWebSummary=request.getParameter("nWebSummary");

//[문8]. pstmt의 SQL 쿼리 구성
pstmt.setString(1,snWebTitle);
pstmt.setString(2,snWebAuthor);
pstmt.setString(3,sgenre);
pstmt.setString(4,FileName);
pstmt.setString(5,snWebSummary);
pstmt.setString(6,snWebAuthor_s);
pstmt.setString(7,sid);

//[문9]. 쿼리 실행
pstmt.executeUpdate();

sql="select wtid from wtlist where title=?";
pstmt = con.prepareStatement(sql);
pstmt.setString(1,snWebTitle);
ResultSet rs = pstmt.executeQuery();

rs.next();

sql = "create table eplist_"+rs.getInt(1)+"(epid int not null auto_increment, wtid int not null, epNum int not null, eptitle varchar(50) character set utf8, epthumnail text, date date, contentimg text, primary key(epid), foreign key(wtid) references wtlist(wtid) on delete cascade);";
pstmt = con.prepareStatement(sql);
pstmt.executeUpdate();

pstmt.close();
con.close();

response.sendRedirect("WebtoonDetail.jsp?wtid="+rs.getInt(1));
%>