<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>도서 목록</title>
<!-- Bootstrap CDN -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
.narrow-container {
	max-width: 800px;
}

.book-text {
	flex-basis: 70%;
}

.button-area {
	flex-basis: 20%;
}

.book-title-link {
	text-decoration: none;
	color: #000;
}

.book-title-link:hover {
	text-decoration: underline;
}
</style>
</head>
<body>
	<div class="container narrow-container mt-5">
		<h2 class="mb-4 text-center">OLDDEMERONA</h2>

		<div class="row row-cols-1 g-0">
			<c:forEach var="book" items="${books}">
				<div class="col">
					<div class="d-flex align-items-start py-3 border-bottom">
						<a href="/book/view?id=${book.id}"> <img src="${book.image}"
							class="img-thumbnail border-0"
							style="width: 120px; height: 160px;">
						</a>

						<div class="ms-3 book-text">
							<h5 class="mb-1">
								<a href="/book/view?id=${book.id}" class="book-title-link">${book.title}</a>
							</h5>
							<p class="text-muted mb-1">${book.author}·${book.publisher} ·
								${book.published_at}</p>
							<p class="fw-bold mb-1">
								<fmt:formatNumber value="${book.price}" type="number"
									groupingUsed="true" />
								원
							</p>
							<p class="mb-0">${book.introduction}</p>
						</div>

						<div class="ms-2 button-area">
							<button class="btn btn-secondary btn-sm mb-1 w-60 fs-8">장바구니</button>
							<a href="/payment/buyNow?bookId=${book.id}&accountId=5"> <%-- 임시 유저 ID --%>
							<button class="btn btn-primary btn-sm w-60 fs-8">구매하 	기</button></a>
							<form action="/cart" method="post" onsubmit="return confirm('장바구니에 추가하시겠습니까?');">
								<input type="hidden" name="bookId" value="${book.id}">
								<input type="hidden" name="accountId" value="1">
								<input type="hidden" name="quantity" value="1">
								<button type="submit" class="btn btn-secondary btn-sm mb-1 w-60 fs-8">장바구니</button>
							</form>
							<button class="btn btn-primary btn-sm w-60 fs-8">구매하기</button>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>

		<!-- Pagination -->
		<nav class="mt-5" aria-label="Page navigation">
			<ul class="pagination justify-content-center">
				<li class="page-item ${pageList.pre ? '' : 'disabled'}"><a
					class="page-link"
					href="/book/list?requestPage=${pageList.startPage - 5}">이전</a></li>
				<c:forEach begin="${pageList.startPage}" end="${pageList.endPage}"
					var="i">
					<li class="page-item ${pageList.currentPage eq i ? 'active' : ''}">
						<a class="page-link" href="/book/list?requestPage=${i}">${i}</a>
					</li>
				</c:forEach>
				<li class="page-item ${pageList.next ? '' : 'disabled'}"><a
					class="page-link"
					href="/book/list?requestPage=${pageList.startPage + 5}">다음</a></li>
			</ul>
		</nav>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
