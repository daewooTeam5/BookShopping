<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>관리자 결제내역 목록</title>
    <style>
        table { border-collapse: collapse; width: 90%; margin: 30px auto; }
        th, td { border: 1px solid #999; padding: 8px 12px; text-align: center; }
        th { background: #f4f4f4; }
    </style>
</head>
<body>
    <h2 style="text-align: center;">관리자 결제내역 목록</h2>
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
                    <td>
                        <fmt:formatDate value="${payment.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </td>
                    <td>${payment.userName}</td>
                    <td>${payment.userId}</td>
                    <td>${payment.bookTitle}</td>
                    <td>${payment.bookAuthor}</td>
                    <td>${payment.bookPublisher}</td>
                    <td>
                        <fmt:formatNumber value="${payment.bookPrice}" type="number" groupingUsed="true"/>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
