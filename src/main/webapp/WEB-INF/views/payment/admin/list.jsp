<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title>관리자 결제내역 목록</title>
<style>
table {
	border-collapse: collapse;
	width: 90%;
	margin: 30px auto;
}

th, td {
	border: 1px solid #999;
	padding: 8px 12px;
	text-align: center;
}

th {
	background: #f4f4f4;
}
</style>
</head>
<body>
	<h2 style="text-align: center;">관리자 결제내역 목록</h2>
	<form method="get" action="">
		<input type="text" name="userName" placeholder="회원 이름"
			value="${param.userName}" /> 
		<input type="text" name="userId" placeholder="회원 아이디" value="${param.userId}" /> 
		<input type="text" name="bookTitle" placeholder="도서명" value="${param.bookTitle}" /> 
		<input type="text" name="publisher" placeholder="출판사" value="${param.publisher}" /> 
		<input type="date" name="fromDate" value="${param.fromDate}" /> ~ 
		<input type="date" name="toDate" value="${param.toDate}" /> 
		<input type="number" name="minPrice" placeholder="최소가격" value="${param.minPrice}" /> 
		<input type="number" name="maxPrice" placeholder="최대가격" value="${param.maxPrice}" />
		<button type="submit">검색</button>
		<a href="list">초기화</a>
	</form>

	<table>
		<thead>
			<tr>
				<th>결제 ID</th>
				<th>결제일</th>
				<th>회원 이름</th>
				<th>회원 아이디</th>
				<th>도서명</th>
				<th>저자</th>
				<th>출판사</th>
				<th>가격</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="payment" items="${paymentList}">
				<tr>
					<td>${payment.id}</td>
					<td><fmt:formatDate value="${payment.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
					<td>${payment.userName}</td>
					<td>${payment.userId}</td>
					<td>${payment.bookTitle}</td>
					<td>${payment.bookAuthor}</td>
					<td>${payment.bookPublisher}</td>
					<td><fmt:formatNumber value="${payment.bookPrice}" type="number" groupingUsed="true" /></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
</html>
