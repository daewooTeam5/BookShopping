<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 상세 정보</title>
<!-- Bootstrap 5 CDN -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	background: #f8fafc;
}

.card {
	border-radius: 0.7rem;
	box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
}

.book-img-detail {
	max-width: 200px;
	height: auto;
	border-radius: 6px;
	box-shadow: 0 1px 4px rgba(0, 0, 0, 0.07);
}

.dashboard-header {
	font-weight: 700;
	letter-spacing: -0.5px;
}

.rating-bar-container {
	display: flex;
	align-items: center;
	margin-bottom: 5px;
}

.rating-label {
	width: 30px;
	text-align: right;
	margin-right: 10px;
	font-weight: bold;
}

.rating-bar {
	flex-grow: 1;
	height: 15px;
	background-color: #e9ecef;
	border-radius: 5px;
	overflow: hidden;
}

.rating-fill {
	height: 100%;
	background-color: #0d6efd;
	border-radius: 5px;
}

.rating-count {
	margin-left: 10px;
	min-width: 40px;
}
</style>
</head>
<body>
	<div class="container py-4">
		<div class="d-flex justify-content-between align-items-center mb-4">
			<h2 class="dashboard-header fs-3 mb-0">도서 상세 정보</h2>
			<a href="${pageContext.request.contextPath}/book/admin/list"
				class="btn btn-secondary">목록으로 돌아가기</a>
		</div>

		<c:if test="${empty bookDetail.book}">
			<div class="alert alert-warning" role="alert">
				도서 정보를 찾을 수 없습니다.
			</div>
		</c:if>
		<c:if test="${not empty bookDetail.book}">
			<div class="card mb-4">
				<div class="card-header bg-primary text-white">
					<h5 class="mb-0">도서 기본 정보</h5>
				</div>
				<div class="card-body">
					<div class="row">
						<div class="col-md-4 text-center">
							<img src="${bookDetail.book.image}" alt="표지"
								class="book-img-detail mb-3" />
						</div>
						<div class="col-md-8">
							<p>
								<strong>제목:</strong> ${bookDetail.book.title}
							</p>
							<p>
								<strong>저자:</strong> ${bookDetail.book.author}
							</p>
							<p>
								<strong>출판사:</strong> ${bookDetail.book.publisher}
							</p>
							<p>
								<strong>가격:</strong> <fmt:formatNumber
									value="${bookDetail.book.price}" type="number"
									groupingUsed="true" /> 원
							</p>
							<p>
								<strong>출간일:</strong> <fmt:formatDate
									value="${bookDetail.book.publishedAt}" pattern="yyyy-MM-dd" />
							</p>
							<p>
								<strong>장르:</strong> ${bookDetail.book.genre}
							</p>
							<p>
								<strong>페이지 수:</strong> ${bookDetail.book.page} 페이지
							</p>
							<p>
								<strong>삭제 여부:</strong>
								<c:choose>
									<c:when test="${bookDetail.book.isDeleted == 'Y'}">
										<span class="text-danger fw-bold">삭제됨</span>
									</c:when>
									<c:otherwise>
										<span class="text-success">정상</span>
									</c:otherwise>
								</c:choose>
							</p>
						</div>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col-md-6">
					<div class="card mb-4">
						<div class="card-header bg-info text-white">
							<h5 class="mb-0">판매 통계</h5>
						</div>
						<div class="card-body">
							<p>
								<strong>총 구매 수:</strong>
								<fmt:formatNumber value="${bookDetail.sales.totalPurchaseCount}"
									type="number" groupingUsed="true" /> 권
							</p>
							<p>
								<strong>총 판매 금액:</strong>
								<fmt:formatNumber value="${bookDetail.sales.totalSalesAmount}"
									type="number" groupingUsed="true" /> 원
							</p>
						</div>
					</div>
				</div>

			</div>
		</c:if>
	</div>
</body>
</html>
