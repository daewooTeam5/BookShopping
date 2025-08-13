<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 관리</title>
<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background: #f8fafc; }
.table th, .table td { vertical-align: middle; }
.search-form .form-select, .search-form .form-control { border-radius: 0.7rem; }
.search-form .btn { border-radius: 0.7rem; }
.dashboard-header { font-weight: 700; letter-spacing: -0.5px; }
</style>
</head>
<body>
<div class="container py-4">
    <!-- 상단 제목과 돌아가기 버튼 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="dashboard-header fs-3 mb-0">📝 리뷰 관리</h2>
        <div class="d-flex gap-3">
            <a href="${pageContext.request.contextPath}/book/admin/list"
               class="btn btn-outline-dark btn-lg px-4 shadow-sm">📚 도서 관리</a>
            <form method="post" action="/logout">
                <sec:csrfInput />
                <sec:authorize access="isAuthenticated()">
                    <input type="submit" value="🚪 로그아웃" class="btn btn-outline-danger btn-lg px-4 shadow-sm">
                </sec:authorize>
            </form>
        </div>
    </div>

    <!-- 검색 폼 -->
		<form method="get"
			action="${pageContext.request.contextPath}/review/admin/list"
			class="row search-form g-2 mb-3">
			<div class="col-md-2 col-sm-4">
				<select name="searchField" class="form-select">
					<option value="content"
						${searchField == 'content' ? 'selected' : ''}>내용</option>
					<option value="account_id"
						${searchField == 'account_id' ? 'selected' : ''}>회원 ID</option>
					<option value="book_id"
						${searchField == 'book_id' ? 'selected' : ''}>도서 ID</option>
					<option value="rating" ${searchField == 'rating' ? 'selected' : ''}>평점</option>
				</select>
			</div>
			<div class="col-md-6 col-sm-5">
				<input type="text" name="keyword" placeholder="검색어 입력"
					value="${keyword}" class="form-control" autocomplete="off" />
			</div>
			<div class="col-auto">
				<button type="submit" class="btn btn-primary px-4">검색</button>
			</div>
			<c:if test="${not empty keyword}">
				<div class="col-auto">
					<button type="button" class="btn btn-outline-secondary"
						onclick="location.href='${pageContext.request.contextPath}/review/admin/list'">🔙
						초기화</button>
				</div>
			</c:if>
		</form>
		<!-- 평점 상위 TOP5 카드 -->
		<div class="card shadow-sm mb-4">
			<div class="card-body">
				<h5 class="card-title mb-3">⭐ 평점 상위 Top 5 도서</h5>
				<canvas id="top5Chart"></canvas>
			</div>
		</div>

		<!-- 리뷰 목록 테이블 -->
    <div class="table-responsive shadow-sm rounded-4 bg-white">
        <table class="table table-hover align-middle mb-0">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>회원 ID</th>
                    <th>도서 ID</th>
                    <th>도서 제목</th>
                    <th>평점</th>
                    <th>내용</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="review" items="${list}">
                    <tr>
                        <td>${review.id}</td>
                        <td>${review.accountId}</td>
                        <td>${review.bookId}</td>
                        <td>${review.bookTitle}</td>
                        <td>${review.rating}</td>
                        <td class="text-break" style="max-width: 400px;">${review.content}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty list}">
                    <tr>
                        <td colspan="5" class="text-center text-secondary py-4">등록된 리뷰가 없습니다.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.min.js"></script>

<script>
  // JSTL로 모델 데이터를 JS 배열로 직렬화
  const top5Labels = [
    <c:forEach var="b" items="${top5}" varStatus="s">
      "${fn:escapeXml(b.bookTitle)}"<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];
  const top5Avg = [
    <c:forEach var="b" items="${top5}" varStatus="s">
      ${b.avgRating}<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];
  const top5Cnt = [
    <c:forEach var="b" items="${top5}" varStatus="s">
      ${b.reviewCount}<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];

  // 차트 렌더
  (function() {
    const ctx = document.getElementById('top5Chart');
    if (!ctx) return;

    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: top5Labels,
        datasets: [{
          label: '평균 평점',
          data: top5Avg,
          backgroundColor: 'rgba(54, 162, 235, 0.5)',
          borderColor: 'rgba(54, 162, 235, 1)',
          borderWidth: 1
        }, {
          label: '리뷰 수',
          data: top5Cnt,
          type: 'line',
          fill: false,
          borderColor: 'rgba(255, 159, 64, 1)',
          borderWidth: 2,
          yAxisID: 'y-axis-2',
          tension: 0.2,
          pointRadius: 3
        }]
      },
      options: {
        responsive: true,
        scales: {
          yAxes: [{
            id: 'y-axis-1',
            position: 'left',
            ticks: { beginAtZero: true, suggestedMax: 5 },
            scaleLabel: { display: true, labelString: '평균 평점' }
          }, {
            id: 'y-axis-2',
            position: 'right',
            ticks: { beginAtZero: true, precision: 0 },
            gridLines: { drawOnChartArea: false },
            scaleLabel: { display: true, labelString: '리뷰 수' }
          }]
        },
        tooltips: {
          callbacks: {
            label: function(tooltipItem, data) {
              const dsLabel = data.datasets[tooltipItem.datasetIndex].label || '';
              return dsLabel + ': ' + tooltipItem.yLabel;
            }
          }
        },
        legend: { display: true }
      }
    });
  })();
</script>
</body>
</html>
