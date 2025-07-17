<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<style>
body {
	background: #f0f2f5;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
	margin: 0;
}

.login-container {
	background: #fff;
	padding: 40px;
	border-radius: 12px;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
	width: 300px;
}

h1 {
	text-align: center;
	margin-bottom: 24px;
	color: #333;
}

label {
	display: block;
	margin: 12px 0 6px;
	font-weight: bold;
	color: #555;
}

input[type="text"], input[type="password"] {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 6px;
	font-size: 14px;
	transition: border-color 0.3s;
}

input:focus {
	border-color: #007bff;
	outline: none;
}

button {
	margin-top: 20px;
	width: 100%;
	padding: 10px;
	background-color: #007bff;
	color: white;
	font-size: 16px;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	transition: background-color 0.3s;
}

button:hover {
	background-color: #0056b3;
}
</style>
</head>
<body>

	<div class="login-container">
		<h1>로그인</h1>
		<form action="/login" method="post">

			<sec:csrfInput />
			<label>아이디</label> <input type="text" name="username"
				placeholder="아이디를 입력하세요."> <label>비밀번호</label> <input
				type="password" name="password" placeholder="비밀번호를 입력하세요.">

			<button type="submit">로그인</button>
		</form>
	 <button onclick="location.href='/register'">회원가입</button>
	</div>

</body>
</html>