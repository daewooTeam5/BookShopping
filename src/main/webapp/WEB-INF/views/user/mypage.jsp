<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<html>
<head>
<title>mypage</title>
<style>
body {
	font-family: '맑은 고딕', sans-serif;
	background-color: #f4f6f9;
	margin: 30px;
}

h2 {
	color: #333;
}

table {
	width: 100%;
	border-collapse: collapse;
	background-color: #fff;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

th, td {
	padding: 12px;
	text-align: center;
	border-bottom: 1px solid #ddd;
}

th {
	background-color: #3f51b5;
	color: white;
}

tr:hover {
	background-color: #f1f1f1;
}

form {
	display: inline;
}

button {
	background-color: #3f51b5;
	border: none;
	color: white;
	padding: 6px 12px;
	border-radius: 4px;
	cursor: pointer;
	font-size: 13px;
}

button:hover {
	background-color: #303f9f;
}

.top-button {
	margin-bottom: 15px;
}

.search-bar {
	margin-top: 20px;
}

.search-bar input[type="text"] {
	padding: 6px;
	font-size: 14px;
	width: 200px;
}

.search-bar button {
	background-color: #4caf50;
	margin-left: 5px;
}

.search-bar button:hover {
	background-color: #388e3c;
}

li {
	margin: 2px;
}
</style>
</head>
<body>
	<h2>마이페이지</h2>

	<div>
		<h3>내 정보</h3>
		<p><strong>아이디:</strong> ${user.userId}</p>
		<p><strong>이름:</strong> ${user.name}</p>
		<p><strong>권한:</strong> ${user.userRole}</p>
		<p><strong>가입일:</strong> ${user.createdAt}</p>
	</div>

	<table>
		나의 계정 
		<ul>
			<li>주문 조회</li>
			<li>반품 및 교환 내역</li>
			<li>취소 주문 조회</li>
			<li>선물 내역</li>
		</ul>
	</table>

</body>
</html>