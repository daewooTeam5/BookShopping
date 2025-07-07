<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 목록</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: left;
        }
        th {
            background-color: #f3f3f3;
        }
    </style>
</head>
<body>

<h2>📚 도서 목록</h2>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>제목</th>
            <th>저자</th>
            <th>출판사</th>
            <th>가격</th>
            <th>출간일</th>
            <th>장르</th>
            <th>페이지 수</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="book" items="${list}">
            <tr>
                <td>${book.id}</td>
                <td>${book.title}</td>
                <td>${book.author}</td>
                <td>${book.publisher}</td>
                <td>${book.price}</td>
                <td><fmt:formatDate value="${book.publishedAt}" pattern="MM/dd/yyyy" /></td>
                <td>${book.genre}</td>
                <td>${book.page}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>

</body>
</html>
