<%@ page contentType="text/html;charset=utf-8" import="java.sql.*, java.io.*" errorPage="01_error.jsp"%>
<%
request.setCharacterEncoding("utf-8");

	//[문1]. 사용자가 get방식으로 전달한 idx값 알아내기 
	String wtid = request.getParameter("wtid");
 
	//[문2]. JDBC Driver 로드
	String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD= "1234";
 

	Connection con = DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD);
	

	String sql = "select thumnail from wtlist where wtid=?";
	

	PreparedStatement pstmt = con.prepareStatement(sql);
	

	pstmt.setInt(1,Integer.parseInt(wtid));
	

	ResultSet rs = pstmt.executeQuery();
	

	rs.next();
	
	//[문9].삭제할 savedFileName 필드의 값(UUID 적용된 파일명) 알아내기
	String filename = rs.getString("thumnail");
	 
	//[문10]. upload 이름을 가지는 실제 서버의 경로명 알아내기
	ServletContext context = getServletContext();
	String realFolder = context.getRealPath("upload");
	
	//[문11]. 앞에서 알아낸 서버의 경로명과 파일명으로 파일 객체 생성하기
	File file = new File(realFolder+File.separator+filename);
	
	//[문12]. 파일 삭제
	file.delete();
	
	//[문13]. member 테이블에서 지정한 idx의 레코드를 삭제하기 위한 쿼리 문자열 구성하기
	sql = "delete from wtlist where wtid=?";
	
	//[문14]. PreparedStatement 객체 알아내기
	pstmt = con.prepareStatement(sql);
	
	//[문15]. PreparedStatement 객체의 쿼리 문자열 중 첫번째인  idx 값 설정하기
	pstmt.setInt(1,Integer.parseInt(wtid));
	
	//[문16]. 쿼리 실행
	pstmt.executeUpdate();
	
	sql = "drop table eplist_"+wtid+";";
	pstmt = con.prepareStatement(sql);
	pstmt.executeUpdate();
	
	rs.close();
	pstmt.close();
	con.close();


/* 오류 발생하거나 화면에 아무것도 나타나지 않으면 이곳을  주석 처리하여 오류를 확인할 것 */
response.sendRedirect("Home.jsp");   
%> 