<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 정보 수정</title>
    <style>
        form {
            max-width: 600px;
            margin: 0 auto;
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }
        input, select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
        }
        button {
            margin-top: 20px;
            padding: 10px 20px;
        }
    </style>
</head>
<body>

<h2 style="text-align: center;">📘 도서 정보 수정</h2>

<form method="post" action="${pageContext.request.contextPath}/book/admin/update" enctype="multipart/form-data">
    <input type="hidden" name="id" value="${book.id}" />

    <label for="title">제목</label>
    <input type="text" id="title" name="title" value="${book.title}" required />

    <label for="author">저자</label>
    <input type="text" id="author" name="author" value="${book.author}" required />

    <label for="publisher">출판사</label>
    <input type="text" id="publisher" name="publisher" value="${book.publisher}" required />

    <label for="price">가격</label>
    <input type="number" id="price" name="price" value="${book.price}" required />

    <label for="publishedAt">출간일</label>
    <input type="date" id="publishedAt" name="publishedAt" value="<fmt:formatDate value='${book.publishedAt}' pattern='yyyy-MM-dd'/>" required />

    <label for="genre">장르</label>
    <input type="text" id="genre" name="genre" value="${book.genre}" />

    <label for="page">페이지 수</label>
    <input type="number" id="page" name="page" value="${book.page}" />

    <label for="image">표지 이미지 업로드 (선택)</label>
    <input type="file" id="imageFile" name="imageFile" />
	
	<input type="hidden" name="originalImage" value="${book.image}" />
    <p>현재 이미지: <img src="${pageContext.request.contextPath}/img/${book.image}" alt="표지" style="width: 80px; vertical-align: middle;" /></p>

    <button type="submit">저장</button>
    <a href="${pageContext.request.contextPath}/book/admin/list"><button type="button">목록으로</button></a>
</form>

</body>
</html>
