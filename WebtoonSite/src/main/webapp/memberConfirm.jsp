<%@ page contentType="text/html; charset=UTF-8" 
		import="java.util.*,MyBean.multipart.*"
		import="java.sql.*, java.io.*"
		errorPage="error.jsp"
%>
<%
request.setCharacterEncoding("utf-8");

String id=request.getParameter("id");
String pass=request.getParameter("pass");

String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
String DB_USER = "admin";
String DB_PASSWORD= "1234";

Connection con = DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD);
String sql = "select id, pass from member where id=?";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1,id);
ResultSet rs = pstmt.executeQuery();

if(!rs.next()){
	out.println("<script>alert('아이디가 틀려씀'); history.back();</script>");
}else if(pass.equals(rs.getString("pass"))){
	session.setAttribute("id",id);
	response.sendRedirect("Home.jsp");
}else{
	out.println("<script>alert('비밀번호 틀려씀');history.back();</script>");
}
%>