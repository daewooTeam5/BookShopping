<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<head>
<script src="https://kit.fontawesome.com/6cbdf73c90.js"
	crossorigin="anonymous"></script>
<meta charset="utf-8">
<title>도서 목록</title>

<!-- Bootstrap CDN -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
.book-title-link, .genre-link {
	color: inherit; /* 부모의 글자 색상 상속 */
	text-decoration: none;
}

.book-title-link:hover, .genre-link:hover {
	text-decoration: underline;
	color: #007bff; /* 원하는 hover 색상 */
}

.narrow-container {
	max-width: 900px;
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
	<header class="container narrow-container mt-3">
		<div
			class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4 position-relative">
			<!-- 중앙 제목 -->
			<div class="flex-grow-1 text-center">
				<a href="/book/list"> <img src="/img/book.png" height="65px" /></a>
			</div>

			<c:choose>
				<c:when test="${not empty pageContext.request.userPrincipal}">
					<!-- 로그인 상태 -->
					<div class="position-absolute end-0 me-3">
						<a href="/user/my-page"
							class="btn btn-outline-success btn-sm me-2">내 정보</a> 
							<form action="/logout" method="post" style="display:inline-block">
							<sec:csrfInput/>
							<button type='submit' 
							 class="btn btn-secondary btn-sm">로그아웃</button>
							</form>
					</div>
				</c:when>
				<c:otherwise>
					<!-- 비로그인 상태 -->
					<div class="position-absolute end-0 me-3">
						<a href="/login" class="btn btn-outline-primary btn-sm me-2">로그인</a>
						<a href="/register" class="btn btn-primary btn-sm">회원가입</a>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</header>


	<div class="container narrow-container mt-5">
		<!-- 검색 폼 추가 -->
		<form action="/book/list" method="get"
			class="d-flex mb-4 justify-content-center">

			<select name="searchField" class="form-select w-auto me-2">
				<option value="title" ${searchField == 'title' ? 'selected' : ''}>제목</option>
				<option value="author" ${searchField == 'author' ? 'selected' : ''}>저자</option>
				<option value="publisher"
					${searchField == 'publisher' ? 'selected' : ''}>출판사</option>
			</select> <input type="text" name="keyword" class="form-control w-50 me-2"
				placeholder="검색어를 입력하세요" value="${keyword}" />
			<button type="submit" class="btn btn-primary">검색</button>
		</form>

		<div class="row align-items-start">
			<div class="col-md-3" style="padding-top: 1.1rem;">

				<ul class="list-group">
					<li class="list-group-item"><a class="genre-link"
						href="/book/list">전체</a></li>
					<c:forEach var="genre" items="${genreList}">
						<li
							class="list-group-item d-flex justify-content-between align-items-center">
							<a class="genre-link" href="/book/list?genre=${genre.genre}">${genre.genre}</a>
							<span class="badge bg-primary rounded-pill">${genre.count}</span>
						</li>
					</c:forEach>
				</ul>
			</div>

			<!-- 오른쪽 책 목록 -->
			<div class="col-md-9">
				<!-- 책 목록 영역 -->
				<div class="row row-cols-1 g-0">
					<c:forEach var="book" items="${books}">
						<div class="col">
							<div class="d-flex align-items-start py-3 border-bottom">
								<a href="/book/view?id=${book.id}"> <img
									src="/img/${book.image}" class="img-thumbnail border-0"
									style="width: 120px; height: 160px;">
								</a>
								<div class="ms-3 me-100 book-text">
									<h5 class="mb-1">
										<a href="/book/view?id=${book.id}" class="book-title-link">${book.title}</a>
									</h5>
									<p class="text-muted mb-1">${book.author}·${book.publisher}·${book.published_at}</p>
									<p class="fw-bold mb-1">
										<fmt:formatNumber value="${book.price}" type="number"
											groupingUsed="true" />
										원
									</p>
									<p class="mb-0">${book.introduction}</p>
								</div>
								<div class="ms-2 button-area">
									<form action="/payment/buyNow" method="POST" class="mb-1">
										<input type="hidden" name="bookId" value="${book.id}">
										<sec:csrfInput />
										<button type="submit"
											class="btn btn-primary btn-sm w-100 fs-8">
											<i class="fa-solid fa-credit-card me-1"></i>구매하기
										</button>
									</form>
									<form action="/cart" method="POST"
										onsubmit="return confirm('장바구니에 추가하시겠습니까?');">
										<input type="hidden" name="bookId" value="${book.id}">
										<input type="hidden" name="quantity" value="1">
										<sec:csrfInput />
										<button type="submit"
											class="btn btn-secondary btn-sm w-100 fs-8">
											<i class="fa-solid fa-cart-shopping me-1"></i>장바구니
										</button>
									</form>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>

			</div>
		</div>


		<nav class="mt-5" aria-label="Page navigation">
			<ul class="pagination justify-content-center">
				<li class="page-item ${pageList.pre ? '' : 'disabled'}"><a
					class="page-link"
					href="/book/list?requestPage=${pageList.startPage - 5}&searchField=${searchField}&keyword=${keyword}&genre=${genre}">이전</a>
				</li>

				<c:forEach begin="${pageList.startPage}" end="${pageList.endPage}"
					var="i">
					<li class="page-item ${pageList.currentPage eq i ? 'active' : ''}">
						<a class="page-link"
						href="/book/list?requestPage=${i}&searchField=${searchField}&keyword=${keyword}&genre=${genre}">${i}</a>
					</li>
				</c:forEach>

				<li class="page-item ${pageList.next ? '' : 'disabled'}"><a
					class="page-link"
					href="/book/list?requestPage=${pageList.startPage + 5}&searchField=${searchField}&keyword=${keyword}&genre=${genre}">다음</a>
				</li>
			</ul>
		</nav>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
