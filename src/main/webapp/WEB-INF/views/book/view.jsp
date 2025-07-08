<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>도서 상세 보기</title>
</head>
<body>

<h2>도서 상세 정보</h2>

<table border="1">
  <tr><th>제목</th><td>${book.title}</td></tr>
  <tr><th>저자</th><td>${book.author}</td></tr>
  <tr><th>출판사</th><td>${book.publisher}</td></tr>
  <tr><th>가격</th><td>${book.price}</td></tr>
  <tr><th>장르</th><td>${book.genre}</td></tr>
  <tr><th>발행일</th><td>${book.published_at}</td></tr>
  <tr><th>쪽수</th><td>${book.page}</td></tr>
  <tr><th>소개</th><td>${book.introduction}</td></tr>
</table>

<a href="/book/list">← 목록으로</a>

</body>
</html>
