<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>���� �� ����</title>
</head>
<body>

<h2>���� �� ����</h2>

<table border="1">
  <tr><th>����</th><td>${book.title}</td></tr>
  <tr><th>����</th><td>${book.author}</td></tr>
  <tr><th>���ǻ�</th><td>${book.publisher}</td></tr>
  <tr><th>����</th><td>${book.price}</td></tr>
  <tr><th>�帣</th><td>${book.genre}</td></tr>
  <tr><th>������</th><td>${book.published_at}</td></tr>
  <tr><th>�ʼ�</th><td>${book.page}</td></tr>
  <tr><th>�Ұ�</th><td>${book.introduction}</td></tr>
</table>

<a href="/book/list">�� �������</a>

</body>
</html>
