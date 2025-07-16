<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 등록</title>
    <style>
        form {
            max-width: 600px;
            margin: 0 auto;
        }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input, textarea {
            width: 100%;
            padding: 6px;
            margin-top: 4px;
            box-sizing: border-box;
        }
        button {
            margin-top: 20px;
            padding: 10px 20px;
        }
    </style>
</head>
<body>

<h2 style="text-align: center;">📖 새로운 책 등록</h2>

<form method="post" action="${pageContext.request.contextPath}/book/admin/write" enctype="multipart/form-data">
    <label for="title">제목</label>
    <input type="text" name="title" required />

    <label for="author">저자</label>
    <input type="text" name="author" required />

    <label for="publisher">출판사</label>
    <input type="text" name="publisher" required />

    <label for="imageFile">이미지 업로드</label>
    <input type="file" name="imageFile" accept="img/*"/>

    <label for="price">가격</label>
    <input type="number" name="price" required />

    <label for="publishedAt">출간일</label>
    <input type="date" name="publishedAt" required />

    <label for="genre">장르</label>
    <input type="text" name="genre"/>

    <label for="page">페이지 수</label>
    <input type="number" name="page"/>

    <label for="introduction">책 소개</label>
    <textarea name="introduction" rows="4"></textarea>

    <button type="submit">등록하기</button>
    <a href="${pageContext.request.contextPath}/book/admin/list">
        <button type="button">목록으로</button>
    </a>
</form>

</body>
</html>
