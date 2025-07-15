<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 등록</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f8fafc;
        }
        .form-card {
            max-width: 520px;
            margin: 40px auto;
            box-shadow: 0 2px 16px rgba(0,0,0,0.08);
            border-radius: 1.2rem;
            background: #fff;
            padding: 2.5rem 2rem 2rem 2rem;
        }
        .form-label {
            font-weight: 500;
        }
        .form-control, .form-select, textarea {
            border-radius: 0.7rem;
        }
        .form-actions {
            margin-top: 2rem;
            display: flex;
            gap: 0.8rem;
            justify-content: center;
        }
        @media (max-width: 600px) {
            .form-card {
                padding: 1.2rem 0.5rem;
            }
        }
    </style>
</head>
<body>

<div class="form-card">
    <h2 class="text-center mb-4">📖 새로운 책 등록</h2>
    <form method="post" action="${pageContext.request.contextPath}/book/admin/write" enctype="multipart/form-data">
        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" class="form-control" id="title" name="title" required />
        </div>
        <div class="mb-3">
            <label for="author" class="form-label">저자</label>
            <input type="text" class="form-control" id="author" name="author" required />
        </div>
        <div class="mb-3">
            <label for="publisher" class="form-label">출판사</label>
            <input type="text" class="form-control" id="publisher" name="publisher" required />
        </div>
        <div class="mb-3">
            <label for="imageFile" class="form-label">이미지 업로드 <span class="text-secondary small">(선택)</span></label>
            <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*" />
        </div>
        <div class="mb-3">
            <label for="price" class="form-label">가격</label>
            <input type="number" class="form-control" id="price" name="price" required />
        </div>
        <div class="mb-3">
            <label for="publishedAt" class="form-label">출간일</label>
            <input type="date" class="form-control" id="publishedAt" name="publishedAt" required />
        </div>
        <div class="mb-3">
            <label for="genre" class="form-label">장르</label>
            <input type="text" class="form-control" id="genre" name="genre" />
        </div>
        <div class="mb-3">
            <label for="page" class="form-label">페이지 수</label>
            <input type="number" class="form-control" id="page" name="page" />
        </div>
        <div class="mb-3">
            <label for="introduction" class="form-label">책 소개</label>
            <textarea class="form-control" id="introduction" name="introduction" rows="4"></textarea>
        </div>
        <div class="form-actions">
            <button type="submit" class="btn btn-primary px-4">등록하기</button>
            <a href="${pageContext.request.contextPath}/book/admin/list" class="btn btn-outline-secondary px-4">목록으로</a>
        </div>
    </form>
</div>

</body>
</html>
