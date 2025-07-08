<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>도서 목록</title>
</head>
<body>

<h2>도서 목록</h2>

<table border="1">
  <tr>
    <th>제목</th>
    <th>저자</th>
    <th>출판사</th>
    <th>가격</th>
    <th>발행일</th>
  </tr>

  <c:forEach var="book" items="${book}">
    <tr>
      <td>
        <a href="/book/view?id=${book.id}">${book.title}</a>
      </td>
      <td>${book.author}</td>
      <td>${book.publisher}</td>
      <td>${book.price}</td>
      <td>${book.published_at}</td>
    </tr>
  </c:forEach>
</table>

</body>
</html>
