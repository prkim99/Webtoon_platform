<%@ page contentType="text/html;charset=utf-8" import="java.sql.*, java.io.*" errorPage="01_error.jsp" %>
<%
request.setCharacterEncoding("utf-8");
 
try {
	//[문1]. 사용자가 get방식으로 전달한 idx값 알아내기 
	String wtid = request.getParameter("wtid");
	int epid = Integer.parseInt(request.getParameter("epid"));
	
  
	String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD= "1234";
 
	//[문3].연결자 정보 획득
	Connection con = DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD);
	
	//[문4]. idx에 해당하는 삭제할 파일명 savedFileName을 member 테이블에서 알아내기 위한 쿼리 문자열 구성
	String sql = "select epthumnail, contentimg from eplist_"+wtid+" where epid=?";
	
	//[문5]. PerparedStatement 객체 알아내기.
	PreparedStatement pstmt = con.prepareStatement(sql);
	
	//[문6]. PreparedStatement 객체의 쿼리 문자열 중 첫번째인  idx 값 설정하기
	pstmt.setInt(1,epid);
	
	
	//[문7]. 쿼리 실행
	ResultSet rs = pstmt.executeQuery();
	
	//[문8]. 레코드 커서 이동시키기
	rs.next();
	
	//[문9].삭제할 savedFileName 필드의 값(UUID 적용된 파일명) 알아내기
	String filename1 = rs.getString("epthumnail");
	String filename2= rs.getString("contentimg");
	 
	//[문10]. upload 이름을 가지는 실제 서버의 경로명 알아내기
	ServletContext context = getServletContext();
	String realFolder = context.getRealPath("upload/content");
	
	//[문11]. 앞에서 알아낸 서버의 경로명과 파일명으로 파일 객체 생성하기
	File file1 = new File(realFolder+File.separator+filename1);
	File file2 = new File(realFolder+File.separator+filename2);
	
	//[문12]. 파일 삭제
	file1.delete();
	file2.delete();
	
	//[문13]. member 테이블에서 지정한 idx의 레코드를 삭제하기 위한 쿼리 문자열 구성하기
	sql = "delete from eplist_"+wtid+" where epid=?";
	
	//[문14]. PreparedStatement 객체 알아내기
	pstmt = con.prepareStatement(sql);
	
	//[문15]. PreparedStatement 객체의 쿼리 문자열 중 첫번째인  idx 값 설정하기
	pstmt.setInt(1,epid);
	
	//[문16]. 쿼리 실행
	pstmt.executeUpdate();
	
	rs.close();
	pstmt.close();
	con.close();
} catch (SQLException e) {
	//SQL에 대한 오류나, DB 연결 오류 등이 발생하면, 그 대처 방안을 코딩해 준다.
	out.println(e.toString());
	return;
} catch (Exception e) { 
	//SQLException 이외의 오류에 대한 대처 방안을 코딩해 준다.
	out.println(e.toString());
	return;
}

/* 오류 발생하거나 화면에 아무것도 나타나지 않으면 이곳을  주석 처리하여 오류를 확인할 것 */
response.sendRedirect("WebtoonDetail.jsp?wtid="+request.getParameter("wtid"));   
%> 