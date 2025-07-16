<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>도서 상세 보기</title>
<!-- Bootstrap CDN -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
.container-narrow {
	max-width: 800px;
}

.book-image {
	width: 220px;
	height: 320px;
	object-fit: cover;
}
</style>
</head>
<body>
	<div class="container container-narrow mt-5">
		<h2 class="text-center mb-4">OLDDEMERONA</h2>

		<div class="row g-4">
			<div class="col-md-4 text-center">
				<img src="/img/${book.image}" alt="도서 이미지"
					class="img-thumbnail book-image">
			</div>

			<div class="col-md-8">
				<h4 class="mb-2 fw-bold">${book.title}</h4>
				<p class="text-muted mb-1">${book.author}·${book.publisher} ·
					${book.published_at}</p>
				<p class="fw-bold fs-5 text-danger mb-2">${book.price}원</p>
				<table class="table table-bordered mt-3">
					<tr>
						<th class="bg-light">장르</th>
						<td>${book.genre}</td>
					</tr>
					<tr>
						<th class="bg-light">쪽수</th>
						<td>${book.page}</td>
					</tr>
					<tr>
						<th class="bg-light">발행일</th>
						<td>${book.published_at}</td>
					</tr>
				</table>
				<p class="mt-4">${book.introduction}</p>

				<div class="ms-2 button-area" style="display: flex">
					  <form action="/payment/buyNow" method="POST" class="d-inline">
                    <input type="hidden" name="bookId" value="${book.id}">
                    <sec:csrfInput /> 
                    <button type="submit" class="btn btn-primary">바로 구매</button>
                </form>

                <form action="/cart" method="POST" class="d-inline" onsubmit="return confirm('장바구니에 추가하시겠습니까?');">
                    <input type="hidden" name="bookId" value="${book.id}">
                    <input type="hidden" name="quantity" value="1">
                    <sec:csrfInput /> 
                    <button type="submit" class="btn btn-secondary">장바구니</button>
                </form>
				</div>
			</div>
		</div>

		<div class="mt-4 text-end">
			<a href="/book/list" class="btn btn-outline-secondary btn-sm">←
				목록으로</a>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>