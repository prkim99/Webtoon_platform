<%@ page contentType="text/html; charset=UTF-8" 
		import="java.util.*,MyBean.multipart.*"
		import="java.sql.*, java.io.*"
		errorPage="error.jsp"
%>
<%
request.setCharacterEncoding("utf-8");

String id=request.getParameter("id");
String pass=request.getParameter("pass");
String pass_=request.getParameter("pass_");

String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
String DB_USER = "admin";
String DB_PASSWORD= "1234";

Connection con = DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD);
String sql = "select id, pass from member where id=?";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1,id);
ResultSet rs = pstmt.executeQuery();

if(rs.next()){
	out.println("<script>alert('중복된 아이디가 존재합니다. 다른 아이디를 입력해주세요'); history.back();</script>");
}else if(!(pass_.equals(pass))){
	out.println("<script>alert('비밀번호가 올바르지 않습니다'); history.back();</script>");
}else{
	sql = "insert into member(id, pass) values(?,?)"; 
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1,id);
	pstmt.setString(2,pass);
	pstmt.executeUpdate();
	
	session.setAttribute("id",id);
	response.sendRedirect("Home.jsp");
	
}
%>