<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 목록</title>
<!-- Bootstrap 5 CDN -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	background: #f8fafc;
}

.table th, .table td {
	vertical-align: middle;
}

.book-img {
	width: 60px;
	height: auto;
	border-radius: 6px;
	box-shadow: 0 1px 4px rgba(0, 0, 0, 0.07);
}

.search-form .form-select, .search-form .form-control {
	border-radius: 0.7rem;
}

.search-form .btn {
	border-radius: 0.7rem;
}

.dashboard-header {
	font-weight: 700;
	letter-spacing: -0.5px;
}

.btn-action {
	min-width: 60px;
}
</style>
</head>
<body>
	<div class="container py-4">
		<!-- 상단 제목과 등록 버튼 -->
		<div class="d-flex justify-content-between align-items-center mb-4">
			<h2 class="dashboard-header fs-3 mb-0">
				<a href="/book/list"> <img src="/img/book.png" height="65px"
					alt="로고" />
				</a>
			</h2>
			<div class="d-flex gap-3">
				<!-- gap을 사용하여 버튼 간 간격을 자연스럽게 조정 -->
				<a href="${pageContext.request.contextPath}/payment/admin/list"
					class="btn btn-outline-dark btn-lg px-4 shadow-sm">💳 결제 내역</a>
				<!-- ✅ 리뷰 관리 버튼 추가 -->
				<a href="${pageContext.request.contextPath}/review/admin/list"
					class="btn btn-outline-primary btn-lg px-4 shadow-sm">📝 리뷰 관리</a>

				<a href="${pageContext.request.contextPath}/book/admin/writeform"
					class="btn btn-success btn-lg px-4 shadow-sm">➕ 새로운 책 등록</a>
				<!-- 로그아웃 버튼 -->
				<form method="post" action="/logout">
					<sec:csrfInput />
					<sec:authorize access="isAuthenticated()">
						<input type="submit" value="🚪 로그아웃"
							class="btn btn-outline-danger btn-lg px-4 shadow-sm">
					</sec:authorize>
				</form>
			</div>
		</div>
		<form method="get"
			action="${pageContext.request.contextPath}/book/admin/list"
			class="row search-form g-2 mb-3">
			<div class="col-md-2 col-sm-4">
				<select name="searchField" class="form-select">
					<option value="title" ${searchField == 'title' ? 'selected' : ''}>제목</option>
					<option value="author" ${searchField == 'author' ? 'selected' : ''}>저자</option>
					<option value="publisher"
						${searchField == 'publisher' ? 'selected' : ''}>출판사</option>
				</select>
			</div>
			<div class="col-md-6 col-sm-5">
				<input type="text" name="keyword" placeholder="검색어 입력"
					value="${keyword}" class="form-control" autocomplete="off" />
			</div>
			<div class="col-auto">
				<button type="submit" class="btn btn-primary px-4">검색</button>
			</div>
			<div class="col-auto d-flex align-items-center">
				<input type="checkbox" id="showDeleted" name="showDeleted" value="Y"
					<c:if test="${showDeleted == 'Y'}">checked</c:if>
					onchange="this.form.submit();" /> <label
					for="showDeleted" class="ms-1">삭제된 책 보기</label>
			</div>
			<c:if test="${not empty keyword}">
				<div class="col-auto">
					<button type="button" class="btn btn-outline-secondary"
						onclick="history.back();">🔙 뒤로가기</button>
				</div>
			</c:if>
		</form>
		<!-- 도서 테이블 -->
		<div class="table-responsive shadow-sm rounded-4 bg-white">
			<table class="table table-hover align-middle mb-0">
				<thead class="table-light">
					<tr>
						<th>ID</th>
						<th>제목</th>
						<th>저자</th>
						<th>출판사</th>
						<th>가격</th>
						<th>출간일</th>
						<th>장르</th>
						<th>페이지 수</th>
						<th>이미지</th>
						<th>삭제 여부</th>
						<th class="text-center">관리</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="book" items="${list}">
						<tr>
							<td>${book.id}</td>
							<td>${book.title}</td>
							<td>${book.author}</td>
							<td>${book.publisher}</td>
							<td><fmt:formatNumber value="${book.price}" type="number"
									groupingUsed="true" /> 원</td>
							<td><fmt:formatDate value="${book.publishedAt}"
									pattern="yyyy-MM-dd" /></td>
							<td>${book.genre}</td>
							<td>${book.page}</td>
							<td><img src="${book.image}" alt="표지" class="book-img" /></td>
							<td><c:choose>
									<c:when test="${book.isDeleted == 'Y'}">
										<span class="text-danger fw-bold">삭제됨</span>
									</c:when>
									<c:otherwise>
										<span class="text-success">정상</span>
									</c:otherwise>
								</c:choose></td>
							<td class="text-center">
								<a href="${pageContext.request.contextPath}/book/admin/detail/${book.id}"
									class="btn btn-sm btn-outline-info btn-action mb-1">상세보기</a>
								<a href="${pageContext.request.contextPath}/book/admin/updateform?id=${book.id}"
									class="btn btn-sm btn-outline-primary btn-action mb-1">수정</a>
								<form method="post"
									action="${pageContext.request.contextPath}/book/admin/delete"
									style="display: inline;"
									onsubmit="return confirm('정말 삭제하시겠습니까?');">
									<sec:csrfInput />
									<input type="hidden" name="id" value="${book.id}" />
									<button type="submit"
										class="btn btn-sm btn-outline-danger btn-action mb-1"
										<c:if test="${book.isDeleted == 'Y'}">disabled</c:if>>삭제</button>
								</form></td>
						</tr>
					</c:forEach>
					<c:if test="${empty list}">
						<tr>
							<td colspan="10" class="text-center text-secondary py-4">등록된
								도서가 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			<!-- 페이지 정보 표시 (선택) -->
			<div class="d-flex justify-content-between align-items-center my-2">
				<div class="text-secondary">총 ${total}건 ·
					${page}/${totalPages} 페이지</div>
			</div>

			<!-- 페이징 -->
			<nav aria-label="페이지 네비게이션">
				<ul class="pagination justify-content-center">

					<!-- 이전 -->
					<li class="page-item ${page == 1 ? 'disabled' : ''}"><a
						class="page-link" href="?page=${page - 1}">이전</a></li>

					<!-- 숫자 버튼(현재 페이지 기준 좌우 2칸) -->
					<c:set var="start" value="${page - 2}" />
					<c:set var="end" value="${page + 2}" />
					<c:if test="${start < 1}">
						<c:set var="end" value="${end + (1 - start)}" />
						<c:set var="start" value="1" />
					</c:if>
					<c:if test="${end > totalPages}">
						<c:set var="start" value="${start - (end - totalPages)}" />
						<c:set var="end" value="${totalPages}" />
					</c:if>
					<c:if test="${start < 1}">
						<c:set var="start" value="1" />
					</c:if>

					<c:forEach var="p" begin="${start}" end="${end}">
						<li class="page-item ${p == page ? 'active' : ''}"><a
							class="page-link" href="?page=${p}">${p}</a></li>
					</c:forEach>

					<!-- 다음 -->
					<li class="page-item ${page == totalPages ? 'disabled' : ''}">
						<a class="page-link" href="?page=${page + 1}">다음</a>
					</li>

				</ul>
			</nav>
		</div>
	</div>
</body>
</html>
