<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 창</title>
<style>
body {
	background-color: #f0f2f5;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
	margin: 0;
}

.signup-container {
	background-color: #fff;
	padding: 40px;
	border-radius: 12px;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
	width: 350px;
}

h2 {
	text-align: center;
	color: #333;
	margin-bottom: 20px;
}

input[type="text"], input[type="password"] {
	width: 100%;
	padding: 10px;
	margin-top: 8px;
	margin-bottom: 16px;
	border: 1px solid #ccc;
	border-radius: 6px;
	font-size: 14px;
}

label {
	font-weight: bold;
	color: #555;
}

.checkbox-group {
	margin-bottom: 16px;
}

.checkbox-group input {
	margin-right: 6px;
}

button {
	width: 100%;
	padding: 12px;
	background-color: #007bff;
	color: white;
	border: none;
	border-radius: 6px;
	font-size: 16px;
	cursor: pointer;
	transition: background-color 0.3s ease;
}

button:hover {
	background-color: #0056b3;
}

.back-button {
	margin-top: 12px;
	background-color: #6c757d;
}

.back-button:hover {
	background-color: #5a6268;
}
</style>
</head>
<body>

	<div class="signup-container">
		<h2>회원가입</h2>
		<form action="/register" method="post">
			<sec:csrfInput />
			
			<input type="text" name="userId" id="userId" placeholder="아이디를 입력해 주세요.">
			<input type="password" name="password" id="password" placeholder="비밀번호를 입력해 주세요.">
			<input type="text" name="name" id="name" placeholder="이름을 입력해 주세요.">

			<div class="checkbox-group">
				<p style="margin: 0 0 6px;">권한을 선택하세요:</p>
				<input type="radio" name="userRole" id="admin" value="ROLE_ADMIN">
				<label for="admin">관리자</label><br> 
				<input type="radio" name="userRole" id="user" value="ROLE_USER">
				<label for="user">일반 사용자</label>
			</div>

			<button type="submit">회원가입 완료</button>
		</form>

		<form action="/login">
			<button type="submit" class="back-button">뒤로가기</button>
		</form>
	</div>

	<script>
		// 랜덤 영문+숫자
		function generateRandomString(length) {
			const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
			let result = '';
			for (let i = 0; i < length; i++) {
				result += chars.charAt(Math.floor(Math.random() * chars.length));
			}
			return result;
		}

		// 랜덤 한글 이름 (가~힣) 2~4글자
		function generateRandomKoreanName(length) {
			const startCode = '가'.charCodeAt(0);
			const endCode = '힣'.charCodeAt(0);
			let result = '';
			for (let i = 0; i < length; i++) {
				const randCode = Math.floor(Math.random() * (endCode - startCode + 1)) + startCode;
				result += String.fromCharCode(randCode);
			}
			return result;
		}

		// 전체 폼 채우기
		function fillForm() {
			const randomLength = () => Math.floor(Math.random() * 5) + 8; // 8~12
			const koreanNameLength = () => Math.floor(Math.random() * 3) + 2; // 2~4

			document.getElementById('userId').value = generateRandomString(randomLength());
			document.getElementById('password').value = generateRandomString(randomLength());
			document.getElementById('name').value = generateRandomKoreanName(koreanNameLength());
		}

		// Ctrl + 1 누르면 자동입력
		document.addEventListener('keydown', function(event) {
			if (event.ctrlKey && event.key === '1') {
				event.preventDefault();
				fillForm();
			}
		});
	</script>
</body>
</html>
