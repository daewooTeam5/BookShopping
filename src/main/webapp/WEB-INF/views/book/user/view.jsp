<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>도서 상세 보기</title>
<!-- Bootstrap CDN -->
<script src="https://kit.fontawesome.com/6cbdf73c90.js"
	crossorigin="anonymous"></script>
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
	<header class="container narrow-container mt-3 border-bottom">
		<div
			class="d-flex justify-content-between align-items-center  mb-4 position-relative" style="line-height:65px">

			<!-- 가운데 이미지 정중앙 고정 -->
			<div class="position-absolute top-0 start-50 translate-middle-x">
				<a href="/book/list"> <img src="/img/book.png" height="65px" />
				</a>
			</div>

			<c:choose>
				<c:when test="${not empty pageContext.request.userPrincipal}">
					<sec:authorize access="hasRole('ROLE_ADMIN')">
						<a href="/book/admin/list"
							class="btn btn-outline-danger btn-sm me-3">관리자 페이지</a>
					</sec:authorize>
					<sec:authorize access="hasRole('ROLE_USER')">
					<div></div>
					</sec:authorize>
					<div class="me-3">
						<a href="/user/my-page"
							class="btn btn-outline-success btn-sm me-2">내 정보</a>
						<form action="/logout" method="post" style="display: inline-block">
							<sec:csrfInput />
							<button type='submit' class="btn btn-secondary btn-sm">로그아웃</button>
						</form>
					</div>
				</c:when>
				<c:otherwise>
				<div></div>
					<div class="  me-3">
						<a href="/login" class="btn btn-outline-primary btn-sm me-2">로그인</a>
						<a href="/register" class="btn btn-primary btn-sm">회원가입</a>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</header>
	<div class="container container-narrow mt-5">
		<div class="row g-4">
			<div class="col-md-4 text-center">
				<img src="/img/${book.image}" alt="도서 이미지"
					class="img-thumbnail book-image">
			</div>

			<div class="col-md-8">
				<h4 class="mb-2 fw-bold">${book.title}</h4>
				<p class="text-muted mb-1">${book.author}·${book.publisher}·
					${book.published_at}</p>
				<p class="fw-bold fs-5 text-danger mb-2">
					<fmt:formatNumber value="${book.price}" type="number"
						groupingUsed="true" />
					원
				</p>
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

				<div class="ms-2 button-area">
					<form action="/payment/buyNow" method="POST" class="mb-2"                    onsubmit="return confirm(                        '${book.title} - ' +                        '<fmt:formatNumber value="${book.price}" type="number" groupingUsed="true" />' +                        '원\n결제하시겠습니까?'                    );"                >                    <input type="hidden" name="bookId" value="${book.id}">                    <sec:csrfInput />                    <button type="submit" class="btn btn-primary btn-sm w-100 fs-8 mb-1">                        <i class="fa-solid fa-credit-card me-1"></i>구매하기                    </button>                </form>
					<form action="/cart" method="POST"
						onsubmit="return confirm('장바구니에 추가하시겠습니까?');">
						<input type="hidden" name="bookId" value="${book.id}"> <input
							type="hidden" name="quantity" value="1">
						<sec:csrfInput />
						<button type="submit" class="btn btn-secondary btn-sm w-100 fs-8">
							<i class="fa-solid fa-cart-shopping me-1"></i>장바구니
						</button>
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