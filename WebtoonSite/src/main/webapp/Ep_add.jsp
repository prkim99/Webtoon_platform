<%@ page contentType="text/html;charset=utf-8" 
	import="java.sql.*"
	import="java.util.*,MyBean.multipart.* " errorPage="01_error.jsp"
%>
<%--[문1]. import 속성 완성 --%>

<%
request.setCharacterEncoding("utf-8");

Class.forName("org.mariadb.jdbc.Driver");
String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
String DB_USER = "admin";
String DB_PASSWORD= "1234";

//[문2]. 사용자가 id, name, pwd 파라미터에 전송한 값 알아내기
String date = request.getParameter("date");
int num =Integer.parseInt(request.getParameter("Ep")); 
String wtid = request.getParameter("wtid");
String eptitle = request.getParameter("epTitle");



ServletContext context = getServletContext();
String realFolder = context.getRealPath("upload/content");

Collection<Part> parts = request.getParts();

MyMultiPart multiPart = new MyMultiPart(parts,realFolder);

String FileNamethum="";
String FileNamecon="";

//썸네일
if(multiPart.getMyPart("thumImg") != null) {  //클라이언트에서 업로드한 파일이 없으면 null 임
	//[문6]. 서버에 저장된 파일 이름 알아내기(UUID적용된 파일명)
	FileNamethum =  multiPart.getSavedFileName("thumImg");
}
if(multiPart.getMyPart("contentImg") != null) {  //클라이언트에서 업로드한 파일이 없으면 null 임
	//[문6]. 서버에 저장된 파일 이름 알아내기(UUID적용된 파일명)
	FileNamecon =  multiPart.getSavedFileName("contentImg");
}

//DB 연결자 생성(이곳에 빈즈나 Connection Pool로 대체 가능)
Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	
//[문7]. id, name, pwd, originalFileName, savedFileName을 저장하기 위한 insert 문자열 구성
String sql = "insert into eplist_"+wtid+
"(wtid,epNum, eptitle,epthumnail,date,contentimg)"+" values(?,?,?,?,?,?)";
	
PreparedStatement pstmt = con.prepareStatement(sql);

//[문8]. pstmt의 SQL 쿼리 구성
pstmt.setInt(1,Integer.parseInt(wtid));
pstmt.setInt(2,num);
pstmt.setString(3,eptitle);
pstmt.setString(4,FileNamethum);
pstmt.setString(5,date);
pstmt.setString(6,FileNamecon);
//[문9]. 쿼리 실행
pstmt.executeUpdate();

pstmt.close();
con.close();

response.sendRedirect("WebtoonDetail.jsp?wtid="+request.getParameter("wtid"));
%>