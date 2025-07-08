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
<form method="get" action="${pageContext.request.contextPath}/book/admin/list" style="margin-bottom: 20px;">
    <select name="searchField">
        <option value="title" ${searchField == 'title' ? 'selected' : ''}>제목</option>
        <option value="author" ${searchField == 'author' ? 'selected' : ''}>저자</option>
        <option value="publisher" ${searchField == 'publisher' ? 'selected' : ''}>출판사</option>
    </select>
    <input type="text" name="keyword" placeholder="검색어 입력" value="${keyword}" />
    <button type="submit">검색</button>
</form>
<a href="${pageContext.request.contextPath}/book/admin/writeform">
    <button type="button" style="margin-bottom: 20px;">➕ 새로운 책 등록</button>
</a>
<c:if test="${not empty keyword}">
    <button onclick="history.back()" style="margin-top: 20px;">🔙 뒤로가기</button>
</c:if>
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
            <th>이미지</th>
            <th>관리</th>
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
                <td><fmt:formatDate value="${book.publishedAt}" pattern="yyyy-MM-dd" /></td>
                <td>${book.genre}</td>
                <td>${book.page}</td>
                <td>
                    <img src="${pageContext.request.contextPath}/img/${book.image}" alt="표지" style="width: 60px; height: auto;" />
                </td>
                <td>
                <a href="${pageContext.request.contextPath}/book/admin/updateform?id=${book.id}">
                    <button type="button">수정</button>
                </a>
                
                <form method="post" action="${pageContext.request.contextPath}/book/admin/delete" style="display:inline;" 
                      onsubmit="return confirm('정말 삭제하시겠습니까?');">
                    <input type="hidden" name="id" value="${book.id}" />
                    <button type="submit">삭제</button>
                </form>
            	</td>
            </tr>
        </c:forEach>
    </tbody>
</table>

</body>
</html>
