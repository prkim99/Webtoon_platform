<%@ page contentType="text/html; charset=UTF-8" 
		import="java.util.*,MyBean.multipart.*"
		import="java.sql.*, java.io.* " errorPage="01_error.jsp"
		
%>
<%
request.setCharacterEncoding("utf-8");

int wtid = Integer.parseInt(request.getParameter("wtid"));
String snWebTitle=request.getParameter("nWebTitle");
String snWebAuthor=request.getParameter("nWebAuthor");
String snWebAuthor_s=request.getParameter("nWebAuthor_s");
String sgenre=request.getParameter("genre");
String snWebSummary=request.getParameter("nWebSummary");

ServletContext context = getServletContext();
String realFolder = context.getRealPath("upload");

//[문1]. Part API를 사용하여 클라이언트로부터 multipart/form-data 유형의 전송 받은 파일 저장
Collection<Part> parts = request.getParts();
MyMultiPart multiPart = new MyMultiPart(parts, realFolder);


Class.forName("org.mariadb.jdbc.Driver");
String url = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
Connection con = DriverManager.getConnection(url, "admin", "1234");
PreparedStatement pstmt = null;
ResultSet rs = null;
String sql = null;

if(multiPart.getMyPart("ThumUP") != null) { //사용자가 새로운 파일을 지정한 경우
	//[문2] member 테이블에 저장된 idx 레코드의 파일명을 알아내어, 물리적 파일을 삭제함.
	sql = "select thumnail from wtlist where wtid=?";
	pstmt=con.prepareStatement(sql);
	pstmt.setInt(1,wtid);
	rs=pstmt.executeQuery();
	rs.next();
	String oldFileName=rs.getString("thumnail");
	File oldFile = new File(realFolder+File.separator+oldFileName);
	oldFile.delete();
	//[문3] 새로운 파일명(original file name, UUID 적용 file name)과 데이터로 member 테이블 수정
	sql = "update wtlist set title=?, writer=?, genre=?, thumnail=?, summary=?, wnote=? where wtid=?";
	pstmt=con.prepareStatement(sql);
	
	pstmt.setString(1,snWebTitle);
	pstmt.setString(2,snWebAuthor);
	pstmt.setString(3,sgenre);
	pstmt.setString(4,multiPart.getOriginalFileName("ThumUP"));
	pstmt.setString(5,snWebSummary);
	pstmt.setString(6,snWebAuthor_s);
	pstmt.setInt(7,wtid);
	
} else { //fileName에 해당되는 Part 객체가 null이라면, 새로운 파일을 선택하지 않을 경우임
	//[문4]. 파일명을 제외한 id, name, pwd 정보 수정
	sql = "update wtlist set title=?, writer=?, genre=?, summary=?, wnote=? where wtid=?";
	pstmt=con.prepareStatement(sql);
	

	pstmt.setString(1,snWebTitle);
	pstmt.setString(2,snWebAuthor);
	pstmt.setString(3,sgenre);
	pstmt.setString(4,snWebSummary);
	pstmt.setString(5,snWebAuthor_s);
	pstmt.setInt(6,wtid);
	
	
}

pstmt.executeUpdate(); // 쿼리 실행

if(pstmt != null) pstmt.close();
if(rs != null) rs.close();
if(con != null) con.close();

response.sendRedirect("Home.jsp");
%>