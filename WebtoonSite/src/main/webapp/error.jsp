<%@ page  contentType="text/html; charset=UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>오류페이지</h1>
오류 메시지:
<%=exception.getMessage() %><br>
<br>
<%=exception.toString() %><br>
<!-- fdfdf -->
</body>
</html>