<%@ page contentType="text/html; charset=UTF-8" 
		import="java.util.*,MyBean.multipart.*"
		import="java.sql.*, java.io.*"
		errorPage="error.jsp"
%>
<%
request.setCharacterEncoding("utf-8");

int epid = Integer.parseInt(request.getParameter("epid"));
String wtid = request.getParameter("wtid");
String eptitle = request.getParameter("epTitle");
String date = request.getParameter("date");

ServletContext context = getServletContext();
String realFolder = context.getRealPath("upload/content");

//[문1]. Part API를 사용하여 클라이언트로부터 multipart/form-data 유형의 전송 받은 파일 저장
Collection<Part> parts = request.getParts();
MyMultiPart multiPart = new MyMultiPart(parts, realFolder);


Class.forName("org.mariadb.jdbc.Driver");
String url = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
Connection con = DriverManager.getConnection(url, "admin", "1234");
PreparedStatement pstmt = null;
ResultSet rs = null;
String sql = null;
sql = "select epthumnail, contentimg from eplist_"+wtid+" where epid=?";

pstmt=con.prepareStatement(sql);
pstmt.setInt(1,epid);
rs=pstmt.executeQuery();
rs.next();

if(multiPart.getMyPart("thumImg") != null & multiPart.getMyPart("contentImg") != null) { //사용자가 새로운 파일을 지정한 경우
	//[문2] member 테이블에 저장된 idx 레코드의 파일명을 알아내어, 물리적 파일을 삭제함.

	
	String filename1 = rs.getString("epthumnail");
	String filename2= rs.getString("contentimg");

	File file1 = new File(realFolder+File.separator+filename1);
	File file2 = new File(realFolder+File.separator+filename2);
	
	file1.delete();
	file2.delete();
	
	//[문3] 새로운 파일명(original file name, UUID 적용 file name)과 데이터로 member 테이블 수정
	sql = "update eplist_"+wtid+" set eptitle=?, epthumnail=?, date=?, contentimg=? where epid=?";
	pstmt=con.prepareStatement(sql);
	pstmt.setInt(5,epid);

	pstmt.setString(1,eptitle);
	pstmt.setString(2,multiPart.getSavedFileName("thumImg"));
	pstmt.setString(4,multiPart.getSavedFileName("contentImg"));
	pstmt.setString(3,date);
	
	
	
} else if(multiPart.getMyPart("thumImg") != null & multiPart.getMyPart("contentImg") == null){
	
	String filename1 = rs.getString("epthumnail");


	File file1 = new File(realFolder+File.separator+filename1);

	
	file1.delete();

	
	//[문3] 새로운 파일명(original file name, UUID 적용 file name)과 데이터로 member 테이블 수정
	sql = "update eplist_"+wtid+" set eptitle=?, epthumnail=?, date=? where epid=?";
	pstmt=con.prepareStatement(sql);
	pstmt.setInt(4,epid);

	pstmt.setString(1,eptitle);
	pstmt.setString(2,multiPart.getSavedFileName("thumImg"));
	pstmt.setString(3,date);
	
}else if(multiPart.getMyPart("thumImg") == null & multiPart.getMyPart("contentImg") != null){
	

	String filename2= rs.getString("contentimg");


	File file2 = new File(realFolder+File.separator+filename2);
	

	file2.delete();
	
	//[문3] 새로운 파일명(original file name, UUID 적용 file name)과 데이터로 member 테이블 수정
	sql = "update eplist_"+wtid+" set eptitle=?, date=?, contentimg=? where epid=?";
	pstmt=con.prepareStatement(sql);
	pstmt.setInt(4,epid);

	pstmt.setString(1,eptitle);
	pstmt.setString(3,multiPart.getSavedFileName("contentImg"));
	pstmt.setString(2,date);
}else  { 
	
	sql = "update eplist_"+wtid+" set eptitle=?, date=? where epid=?";
	pstmt=con.prepareStatement(sql);
	pstmt.setInt(3,epid);

	pstmt.setString(1,eptitle);
	pstmt.setString(2,date);
	
}

pstmt.executeUpdate(); // 쿼리 실행

if(pstmt != null) pstmt.close();
if(rs != null) rs.close();
if(con != null) con.close();

response.sendRedirect("WebtoonDetail.jsp?wtid="+wtid);
%>