<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 관리</title>
<!-- Bootstrap 5 -->
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

.content-cell {
	max-width: 420px;
}
</style>
</head>
<body>
	<div class="container py-4">
		<!-- 상단 제목과 버튼 -->
		<div class="d-flex justify-content-between align-items-center mb-4">
			<h2 class="dashboard-header fs-3 mb-0">📝 리뷰 관리</h2>
			<div class="d-flex gap-3">
				<a href="${pageContext.request.contextPath}/book/admin/list"
					class="btn btn-outline-dark btn-lg px-4 shadow-sm">📚 도서 관리</a>
				<form method="post" action="/logout" class="m-0">
					<sec:csrfInput />
					<sec:authorize access="isAuthenticated()">
						<input type="submit" value="🚪 로그아웃"
							class="btn btn-outline-danger btn-lg px-4 shadow-sm">
					</sec:authorize>
				</form>
			</div>
		</div>

		<!-- Tab Navigation -->
		<ul class="nav nav-tabs mb-3" id="adminTab" role="tablist">
			<li class="nav-item" role="presentation">
				<button class="nav-link active" id="dashboard-tab" data-bs-toggle="tab" data-bs-target="#dashboard" type="button" role="tab" aria-controls="dashboard" aria-selected="true">대시보드</button>
			</li>
			<li class="nav-item" role="presentation">
				<button class="nav-link" id="details-tab" data-bs-toggle="tab" data-bs-target="#details" type="button" role="tab" aria-controls="details" aria-selected="false">상세 정보</button>
			</li>
		</ul>

		<!-- Tab Content -->
		<div class="tab-content" id="adminTabContent">
			<!-- Dashboard Tab -->
			<div class="tab-pane fade show active" id="dashboard" role="tabpanel" aria-labelledby="dashboard-tab">
				<div class="d-flex flex-column flex-lg-row">
					<%-- <div class="card shadow-sm mb-4 w-100 me-0 me-lg-0">
						<div class="card-body">
							<h5 class="card-title mb-3">⭐ 별점 분포</h5>
							<c:choose>
								<c:when test="${not empty ratingCount}">
									<canvas id="ratingChart"></canvas>
								</c:when>
								<c:otherwise>
									<div class="text-secondary">표시할 데이터가 없습니다.</div>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
					<div class="card shadow-sm mb-4 w-100 ms-0 ms-lg-2">
						<div class="card-body">
							<h5 class="card-title mb-3">📊 요일별 리뷰 수</h5>
							<c:choose>
								<c:when test="${not empty reviewForWeekdays}">
									<canvas id="weekdayChart"></canvas>
								</c:when>
								<c:otherwise>
									<div class="text-secondary">표시할 데이터가 없습니다.</div>
								</c:otherwise>
							</c:choose>
						</div>
					</div> --%>
				</div>
				<div class="d-flex flex-column flex-lg-row">
					<div class="card shadow-sm mb-4 w-100 ms-0 ms-lg-2">
						<div class="card-body">
							<h5 class="card-title mb-3">⭐ 평점 상위 Top 5 도서</h5>
							<c:choose>
								<c:when test="${not empty top5}">
									<canvas id="top5Chart"></canvas>
								</c:when>
								<c:otherwise>
									<div class="text-secondary">표시할 데이터가 없습니다.</div>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
					<div class="card shadow-sm mb-4 w-100 ms-0 ms-lg-2">
						<div class="card-body">
							<h5 class="card-title mb-3">⭐ 리뷰 상위 Top 5 유저</h5>
							<c:choose>
								<c:when test="${not empty top5Review}">
									<canvas id="top5Review"></canvas>
								</c:when>
								<c:otherwise>
									<div class="text-secondary">표시할 데이터가 없습니다.</div>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>
				<div class="card shadow-sm mb-4">
					<div class="card-body">
						<div class="d-flex justify-content-between align-items-center mb-3">
							<h5 class="card-title mb-0">📈 리뷰 통계</h5>
							<select id="statsPeriodSelector" class="form-select w-auto">
								<option value="daily" selected>일별 (7일)</option>
								<option value="monthly">월별 (올해)</option>
								<option value="yearly">연도별</option>
							</select>
						</div>
						<canvas id="reviewStatsChart"></canvas>
					</div>
				</div>
			</div>

			<!-- Detailed Info Tab -->
			<div class="tab-pane fade" id="details" role="tabpanel" aria-labelledby="details-tab">
				<!-- 검색 폼 -->
				<form method="get" action="${pageContext.request.contextPath}/review/admin/list" class="row search-form g-2 mb-3">
					<div class="col-md-2 col-sm-4">
						<select name="searchField" class="form-select">
							<option value="content" ${searchField == 'content' ? 'selected' : ''}>내용</option>
							<option value="account_id" ${searchField == 'account_id' ? 'selected' : ''}>회원 ID</option>
							<option value="book_id" ${searchField == 'book_id' ? 'selected' : ''}>도서 ID</option>
							<option value="rating" ${searchField == 'rating' ? 'selected' : ''}>평점</option>
						</select>
					</div>
					<div class="col-md-6 col-sm-5">
						<input type="text" name="keyword" placeholder="검색어 입력" value="${keyword}" class="form-control" autocomplete="off" />
					</div>
					<div class="col-auto">
						<button type="submit" class="btn btn-primary px-4">검색</button>
					</div>
					<c:if test="${not empty keyword}">
						<div class="col-auto">
							<button type="button" class="btn btn-outline-secondary" onclick="location.href='${pageContext.request.contextPath}/review/admin/list'">🔙 초기화</button>
						</div>
					</c:if>
				</form>
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
								<th class="text-center">내용</th>
								<th class="text-center"></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="review" items="${list}">
								<tr>
									<td>${review.id}</td>
									<td>${review.accountId}</td>
									<td>${review.bookId}</td>
									<td>${review.bookTitle}</td>
									<td>${review.ratings}</td>
									<td class="text-break content-cell"><span title="${fn:escapeXml(review.contents)}"> ${review.contents} </span></td>
									<td class="text-center">
										<form method="post" action="${pageContext.request.contextPath}/review/admin/delete" style="display: inline" onsubmit="return confirm('정말 삭제하시겠습니까?');">
											<sec:csrfInput />
											<input type="hidden" name="id" value="${review.id}" />
											<button type="submit" class="btn btn-sm btn-outline-danger">삭제</button>
										</form>
									</td>
								</tr>
							</c:forEach>
							<c:if test="${empty list}">
								<tr>
									<td colspan="7" class="text-center text-secondary py-4">등록된 리뷰가 없습니다.</td>
								</tr>
							</c:if>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- Chart.js -->
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.min.js"></script>

	<c:if test="${not empty top5}">
		<script>
  // JSTL -> JS 직렬화
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

  (function() {
    const ctx = document.getElementById('top5Chart');
    if (!ctx) return;

    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: top5Labels,
        datasets: [
            {
                label: '평균 평점',
                data: top5Avg,
                type: 'line', // 라인으로 변경
                fill: false,
                borderColor: 'rgba(255, 159, 64, 1)', // 파랑
                borderWidth: 2,
                yAxisID: 'y-axis-2',
                tension: 0.2,
                pointRadius: 3
            },
            {
                label: '리뷰 수',
                data: top5Cnt,
                backgroundColor: 'rgba(54, 162, 235, 0.5)', // 오렌지
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1,
                yAxisID: 'y-axis-1' // y축 맞춤
            }
        ]

      },
      options: {
        responsive: true,
        scales: {
          yAxes: [{
            id: 'y-axis-1',
            position: 'right',
            ticks: { beginAtZero: true, suggestedMax: 5 },
            scaleLabel: { display: true, labelString: '평균 평점' }
          }, {
            id: 'y-axis-2',
            position: 'left',
            ticks: { beginAtZero: true, precision: 0 },
            gridLines: { drawOnChartArea: false },
            scaleLabel: { display: true, labelString: '리뷰 수' }
          }],
          xAxes: [{
              ticks: {
                callback: function(value) {
                  // 길이 제한: 10글자 이상이면 자르고 ... 붙이기
                  return value.length > 10 ? value.substr(0, 10) + '...' : value;
                },
                maxRotation: 0,        // 0 = 수평
                minRotation: 0  
              }
            }],
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
	</c:if>
	<c:if test="${not empty reviewForWeekdays}">
		<script>
  // 요일 배열
  const weekdays = ['일','월','화','수','목','금','토'];

  // JSTL -> JS 직렬화
  const weekdayData = [
    <c:forEach var="w" items="${reviewForWeekdays}" varStatus="s">
      ${w.reviewCount}<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];

  (function() {
    const ctx = document.getElementById('weekdayChart');
    if (!ctx) return;

    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: weekdays,
        datasets: [{
          label: '리뷰 수',
          data: weekdayData,
          backgroundColor: 'rgba(75, 192, 192, 0.6)',
          borderColor: 'rgba(75, 192, 192, 1)',
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        scales: {
          yAxes: [{
            ticks: { beginAtZero: true, precision:0 },
            scaleLabel: { display: true, labelString: '리뷰 수' }
          }]
        },
        plugins: {
          legend: { display: false }
        }
      }
    });
  })();
</script>
	</c:if>
	<c:if test="${not empty ratingCount}">
		<script>
  // 라벨 (별점 1~5)
  const ratingLabels = [
    <c:forEach var="r" items="${ratingCount}" varStatus="s">
      "${r.ratings}점"<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];

  // 데이터 (각 별점별 카운트)
  const ratingData = [
    <c:forEach var="r" items="${ratingCount}" varStatus="s">
      ${r.reviewCount}<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];

  (function() {
    const ctx = document.getElementById('ratingChart');
    if (!ctx) return;

    new Chart(ctx, {
      type: 'pie',
      data: {
        labels: ratingLabels,
        datasets: [{
          label: '별점 분포',
          data: ratingData,
          backgroundColor: [
            'rgba(255, 99, 132, 0.6)',
            'rgba(255, 159, 64, 0.6)',
            'rgba(255, 205, 86, 0.6)',
            'rgba(75, 192, 192, 0.6)',
            'rgba(54, 162, 235, 0.6)'
          ],
          borderColor: [
            'rgba(255, 99, 132, 1)',
            'rgba(255, 159, 64, 1)',
            'rgba(255, 205, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(54, 162, 235, 1)'
          ],
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        legend: {
          position: 'bottom'
        }
      }
    });
  })();
</script>
	</c:if>
<c:if test="${not empty top5Review}">
<script>
  const usernames = [
    <c:forEach var="r" items="${top5Review}" varStatus="s">
      "${r.name}"<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];

  const reviewCounts = [
    <c:forEach var="r" items="${top5Review}" varStatus="s">
      ${r.reviewCount}<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];

  const avgRatings = [
    <c:forEach var="r" items="${top5Review}" varStatus="s">
      ${r.avgRating}<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];
  (function() {
	    const ctx = document.getElementById('top5Review');
	    if (!ctx) return;

	    new Chart(ctx, {
	        type: 'bar', // 기본 차트 타입은 바 (리뷰 수 기준)
	        data: {
	            labels: usernames,
	            datasets: [
	                {
	                    label: '리뷰 수',
	                    data: reviewCounts.map(Number),
	                    backgroundColor: 'rgba(54, 162, 235, 0.5)',
	                    borderColor: 'rgba(54, 162, 235, 1)',
	                    borderWidth: 1,
	                    yAxisID: 'y-axis-2'
	                },
	                {
	                    label: '평균 평점',
	                    data: avgRatings.map(Number),
	                    type: 'line', // 라인 차트로 덮어쓰기
	                    fill: false,
	                    borderColor: 'rgba(255, 159, 64, 1)',
	                    borderWidth: 2,
	                    yAxisID: 'y-axis-1',
	                    tension: 0.2,
	                    pointRadius: 3
	                }
	            ]
	        },
	        options: {
	            responsive: true,
	            scales: {
	                yAxes: [
	                    {
	                        id: 'y-axis-1',
	                        position: 'right',
	                        ticks: { beginAtZero: true, suggestedMax: 5 },
	                        scaleLabel: { display: true, labelString: '평균 평점' }
	                    },
	                    {
	                        id: 'y-axis-2',
	                        position: 'left',
	                        ticks: { beginAtZero: true, precision: 0 },
	                        gridLines: { drawOnChartArea: false },
	                        scaleLabel: { display: true, labelString: '리뷰 수' }
	                    }
	                ],
	                xAxes: [
	                    {
	                        ticks: {
	                            callback: function(value) {
	                                return value.length > 10 ? value.substr(0, 10) + '...' : value;
	                            },
	                            maxRotation: 0,
	                            minRotation: 0
	                        }
	                    }
	                ]
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
</c:if>

<script>
// 통계 데이터 JSTL -> JS 직렬화
const dailyStats = {
    labels: [<c:forEach var="s" items="${dailyStats}" varStatus="st">"${s.date}"<c:if test="${!st.last}">,</c:if></c:forEach>],
    avgRatings: [<c:forEach var="s" items="${dailyStats}" varStatus="st">${s.avgRating}<c:if test="${!st.last}">,</c:if></c:forEach>],
    reviewCounts: [<c:forEach var="s" items="${dailyStats}" varStatus="st">${s.reviewCount}<c:if test="${!st.last}">,</c:if></c:forEach>]
};

const monthlyStats = {
    labels: [<c:forEach var="s" items="${monthlyStats}" varStatus="st">"${s.month}"<c:if test="${!st.last}">,</c:if></c:forEach>],
    avgRatings: [<c:forEach var="s" items="${monthlyStats}" varStatus="st">${s.avgRating}<c:if test="${!st.last}">,</c:if></c:forEach>],
    reviewCounts: [<c:forEach var="s" items="${monthlyStats}" varStatus="st">${s.reviewCount}<c:if test="${!st.last}">,</c:if></c:forEach>]
};

const yearlyStats = {
    labels: [<c:forEach var="s" items="${yearlyStats}" varStatus="st">"${s.year}"<c:if test="${!st.last}">,</c:if></c:forEach>],
    avgRatings: [<c:forEach var="s" items="${yearlyStats}" varStatus="st">${s.avgRating}<c:if test="${!st.last}">,</c:if></c:forEach>],
    reviewCounts: [<c:forEach var="s" items="${yearlyStats}" varStatus="st">${s.reviewCount}<c:if test="${!st.last}">,</c:if></c:forEach>]
};

(function() {
    const ctx = document.getElementById('reviewStatsChart');
    if (!ctx) return;

    let chart;

    const renderChart = (period) => {
        let data;
        if (period === 'daily') {
            data = dailyStats;
        } else if (period === 'monthly') {
            data = monthlyStats;
        } else {
            data = yearlyStats;
        }

        if (chart) {
            chart.destroy();
        }

        chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: data.labels,
                datasets: [{
                    label: '총 리뷰 수',
                    type: 'bar',
                    data: data.reviewCounts,
                    backgroundColor: 'rgba(54, 162, 235, 0.6)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    yAxisID: 'y-axis-count'
                }, {
                    label: '평균 평점',
                    type: 'line',
                    data: data.avgRatings,
                    borderColor: 'rgba(255, 99, 132, 1)',
                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
                    fill: true,
                    tension: 0.2,
                    yAxisID: 'y-axis-rating'
                }]
            },
            options: {
                responsive: true,
                scales: {
                    yAxes: [{
                        id: 'y-axis-count',
                        position: 'left',
                        ticks: {
                            beginAtZero: true,
                            precision: 0
                        },
                        scaleLabel: {
                            display: true,
                            labelString: '리뷰 수'
                        }
                    }, {
                        id: 'y-axis-rating',
                        position: 'right',
                        ticks: {
                            beginAtZero: true,
                            suggestedMax: 5,
                            stepSize: 1
                        },
                        gridLines: {
                            drawOnChartArea: false
                        },
                        scaleLabel: {
                            display: true,
                            labelString: '평균 평점'
                        }
                    }]
                }
            }
        });
    };

    // 초기 차트 렌더링
    renderChart('daily');

    // 이벤트 리스너
    document.getElementById('statsPeriodSelector').addEventListener('change', function() {
        renderChart(this.value);
    });
})();
</script>

<!-- Bootstrap JS Bundle (for tab functionality) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
