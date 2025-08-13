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
			class="d-flex justify-content-between align-items-center  mb-4 position-relative"
			style="line-height: 65px">

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
				<div class="mb-3">
					<span class="badge bg-light text-dark">평균 <fmt:formatNumber value="${reviewStatistic.ratingAvg}" maxFractionDigits="1" /></span>
					<span class="badge bg-light text-dark">(${reviewStatistic.totalRatings}명 평가)</span>
				</div>
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
                    <form action="/payment/addressForm" method="POST" class="mb-2">
                        <input type="hidden" name="bookId" value="${book.id}">
                        <input type="hidden" name="quantity" value="1">
						<sec:csrfInput />
						<button type="submit"
							class="btn btn-primary btn-sm w-100 fs-8 mb-1">
							<i class="fa-solid fa-credit-card me-1"></i>구매하기
						</button>
					</form>
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


		<div class="mt-5">
			<c:if test="${reviewStatistic.totalRatings > 0}">
				<div class="row align-items-center mb-4">
					<div class="col-auto">
						<span class="fs-1 fw-bold"><fmt:formatNumber value="${reviewStatistic.ratingAvg}" maxFractionDigits="1" /></span>
					</div>
					<div class="col">
						<div>
							<c:set var="rating" value="${reviewStatistic.ratingAvg}" />
							<c:forEach begin="1" end="5" var="i">
								<c:choose>
									<c:when test="${rating >= i}">
										<i class="fas fa-star text-warning"></i>
									</c:when>
									<c:when test="${rating >= i - 0.5}">
										<i class="fas fa-star-half-alt text-warning"></i>
									</c:when>
									<c:otherwise>
										<i class="far fa-star text-warning"></i>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</div>
						<div class="text-muted">
							${reviewStatistic.totalRatings}명 참여
						</div>
					</div>
				</div>
			</c:if>
			<h5 class="mb-3">리뷰 작성</h5>
			<form action="/review" method="post">
				<input type="hidden" name="bookId" value="${book.id}">
				<sec:csrfInput />
				<div class="mb-3">
					<label for="ratings" class="form-label">별점</label>
					<div>
						<div class="form-check form-check-inline">
							<input class="form-check-input" type="radio" name="ratings"
								id="rating1" value="1"> <label class="form-check-label"
								for="rating1">1</label>
						</div>
						<div class="form-check form-check-inline">
							<input class="form-check-input" type="radio" name="ratings"
								id="rating2" value="2"> <label class="form-check-label"
								for="rating2">2</label>
						</div>
						<div class="form-check form-check-inline">
							<input class="form-check-input" type="radio" name="ratings"
								id="rating3" value="3"> <label class="form-check-label"
								for="rating3">3</label>
						</div>
						<div class="form-check form-check-inline">
							<input class="form-check-input" type="radio" name="ratings"
								id="rating4" value="4"> <label class="form-check-label"
								for="rating4">4</label>
						</div>
						<div class="form-check form-check-inline">
							<input class="form-check-input" type="radio" name="ratings"
								id="rating5" value="5" checked> <label
								class="form-check-label" for="rating5">5</label>
						</div>
					</div>
				</div>
				<div class="mb-3">
					<label for="content" class="form-label">코멘트</label>
					<textarea class="form-control" id="content" name="content" rows="3"></textarea>
				</div>
				<button type="submit" class="btn btn-primary">리뷰 남기기</button>
			</form>
		</div>
		<div class="mt-5">
			<h5 class="mb-3">리뷰</h5>
			<c:if test="${empty reviews}">
				<p>작성된 리뷰가 없습니다.</p>
			</c:if>
			<c:forEach var="review" items="${reviews}">
				<div class="card mb-3">
					<div class="card-body">
						<h6 class="card-title">${review.writerName}</h6>
						<p class="card-text">${review.contents}</p>
						<p class="card-text">
							<small class="text-muted">별점: 
								<c:forEach begin="1" end="5" var="i">
									<c:choose>
										<c:when test="${review.ratings >= i}">
											<i class="fas fa-star text-warning"></i>
										</c:when>
										<c:otherwise>
											<i class="far fa-star text-warning"></i>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								|
작성일: <fmt:formatDate
									value="${review.createdAt}" pattern="yyyy-MM-dd" /></small>
						</p>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>