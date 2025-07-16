<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %> <%-- CSRF 토큰 사용을 위해 태그 라이브러리 추가 --%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>도서 목록</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
/* ... (스타일은 이전과 동일) ... */
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

		<form action="/book/list" method="get" class="d-flex mb-4 justify-content-center">
			
			<select name="searchField" class="form-select w-auto me-2">
				<option value="title" ${searchField == 'title' ? 'selected' : ''}>제목</option>
				<option value="author" ${searchField == 'author' ? 'selected' : ''}>저자</option>
				<option value="publisher" ${searchField == 'publisher' ? 'selected' : ''}>출판사</option>
			</select>
			<input type="text" name="keyword" class="form-control w-50 me-2" placeholder="검색어를 입력하세요"
				value="${keyword}" />
			<button type="submit" class="btn btn-primary">검색</button>
		</form>

		<div class="row row-cols-1 g-0">
			<c:forEach var="book" items="${books}">
				<div class="col">
					<div class="d-flex align-items-start py-3 border-bottom">
						<a href="/book/view?id=${book.id}">
							<img src="/img/${book.image}" class="img-thumbnail border-0" style="width: 120px; height: 160px;">
						</a>
						<div class="ms-3 book-text">
							<h5 class="mb-1">
								<a href="/book/view?id=${book.id}" class="book-title-link">${book.title}</a>
							</h5>
							<p class="text-muted mb-1">${book.author} · ${book.publisher} · ${book.published_at}</p>
							<p class="fw-bold mb-1">
								<fmt:formatNumber value="${book.price}" type="number" groupingUsed="true" />원
							</p>
							<p class="mb-0">${book.introduction}</p>
						</div>
						<div class="ms-2 button-area">
							<form action="/payment/buyNow" method="POST" class="mb-1">
								<input type="hidden" name="bookId" value="${book.id}">
								<sec:csrfInput /> 
								<button type="submit" class="btn btn-primary btn-sm w-100 fs-8">구매하기</button>
							</form>
							
							<form action="/cart" method="POST" onsubmit="return confirm('장바구니에 추가하시겠습니까?');">
								<input type="hidden" name="bookId" value="${book.id}">
								<input type="hidden" name="quantity" value="1">
								<sec:csrfInput /> 
								<button type="submit" class="btn btn-secondary btn-sm w-100 fs-8">장바구니</button>
							</form>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>

		<nav class="mt-5" aria-label="Page navigation">
			<ul class="pagination justify-content-center">
				<li class="page-item ${pageList.pre ? '' : 'disabled'}">
					<a class="page-link"
						href="/book/list?requestPage=${pageList.startPage - 5}&searchField=${searchField}&keyword=${keyword}">
						이전
					</a>
				</li>
				<c:forEach begin="${pageList.startPage}" end="${pageList.endPage}" var="i">
					<li class="page-item ${pageList.currentPage eq i ? 'active' : ''}">
						<a class="page-link"
							href="/book/list?requestPage=${i}&searchField=${searchField}&keyword=${keyword}">
							${i}
						</a>
					</li>
				</c:forEach>
				<li class="page-item ${pageList.next ? '' : 'disabled'}">
					<a class="page-link"
						href="/book/list?requestPage=${pageList.startPage + 5}&searchField=${searchField}&keyword=${keyword}">
						다음
					</a>
				</li>
			</ul>
		</nav>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>