<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setLocale value="ko_KR"/>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>관리자 결제내역 목록</title>

  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body { background: #f8fafc; }
    .dashboard-header { font-weight: 700; letter-spacing: -0.5px; }
    .summary-card { box-shadow: 0 2px 12px rgba(0,0,0,0.04); border: none; border-radius: 1.2rem; }
    .summary-card .card-header { background:#fff; font-size:1rem; font-weight:500; border-bottom:none; color:#2d3748; }
    .summary-card .card-title { font-size:2rem; font-weight:700; color:#007bff; }
    .list-group-item { font-size:1rem; }
    .form-control, .btn { border-radius:0.7rem; }
    .table { border-radius: 1rem; overflow: hidden; background: #fff; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
    .table th { background:#f2f5f9; color:#333; font-size:1rem; }
    .table td { font-size:0.96rem; }
    .search-box { background:#fff; border-radius:1.2rem; box-shadow:0 2px 12px rgba(0,0,0,0.05); padding:1.5rem 2rem; }
    .search-box .form-label { font-size:0.92rem; color:#555; }
    @media (max-width: 767px) {
      .summary-card .card-title { font-size:1.2rem; }
      .search-box { padding:1rem; }
      .dashboard-header { font-size:1.3rem; }
    }
  </style>
</head>
<body>
  <div class="container py-4">
    <!-- 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div><span class="dashboard-header fs-2">📊 관리자 결제내역 대시보드</span></div>
      <div class="mb-3">
        <button class="btn btn-outline-secondary" onclick="history.back()">← 뒤로 가기</button>
      </div>
    </div>

    <!-- 통계 요약 카드 -->
    <div class="row g-4 mb-4">
      <div class="col-sm-6 col-md-3">
        <div class="card summary-card text-center h-100">
          <div class="card-header">총 결제 건수</div>
          <div class="card-body">
            <span class="card-title mb-0">${totalCount}건</span>
          </div>
        </div>
      </div>

      <div class="col-sm-6 col-md-3">
        <div class="card summary-card text-center h-100">
          <div class="card-header">총 결제 금액</div>
          <div class="card-body">
            <span class="card-title mb-0">
              <fmt:formatNumber value="${totalAmount}" type="number" groupingUsed="true" /> 원
            </span>
          </div>
        </div>
      </div>

      <div class="col-sm-6 col-md-3">
        <div class="card summary-card h-100">
          <div class="card-header">도서별 결제 TOP5</div>
          <ul class="list-group list-group-flush">
            <c:forEach var="b" items="${topBooks}">
              <li class="list-group-item d-flex justify-content-between align-items-center px-2">
                <span class="text-truncate">${b.name}</span>
                <span class="ms-1 small text-secondary">
                  <fmt:formatNumber value="${b.totalPrice}" type="number" groupingUsed="true" />원 / ${b.count}건
                </span>
              </li>
            </c:forEach>
          </ul>
        </div>
      </div>

      <div class="col-sm-6 col-md-3">
        <div class="card summary-card h-100">
          <div class="card-header">회원별 결제 TOP5</div>
          <ul class="list-group list-group-flush">
            <c:forEach var="u" items="${topUsers}">
              <li class="list-group-item d-flex justify-content-between align-items-center px-2">
                <span class="text-truncate">${u.name}</span>
                <span class="ms-1 small text-secondary">
                  <fmt:formatNumber value="${u.totalPrice}" type="number" groupingUsed="true" />원 / ${u.count}건
                </span>
              </li>
            </c:forEach>
          </ul>
        </div>
      </div>
    </div>
	
	<!-- 통계 그래프 -->
    <div class="card summary-card mb-4">
      <div class="card-header d-flex justify-content-between align-items-center">
        <span>월 별 매출액</span>
        <small class="text-secondary">최근 데이터 기준 자동 집계</small>
      </div>
      <div class="card-body">
        <canvas id="monthlySalesChart" height="110"></canvas>
      </div>
    </div>

    <!-- Chart.js (v4) -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>
    
    <!-- 검색 폼 -->
    <form class="search-box row gy-2 gx-3 align-items-center justify-content-center mb-5" method="get" action="">
      <div class="col-md-2 col-sm-4">
        <input type="text" class="form-control" name="userName" placeholder="회원 이름" value="${param.userName}" autocomplete="off" />
      </div>
      <div class="col-md-2 col-sm-4">
        <input type="text" class="form-control" name="userId" placeholder="회원 아이디" value="${param.userId}" autocomplete="off" />
      </div>
      <div class="col-md-2 col-sm-4">
        <input type="text" class="form-control" name="bookTitle" placeholder="도서명" value="${param.bookTitle}" autocomplete="off" />
      </div>
      <div class="col-md-2 col-sm-4">
        <input type="text" class="form-control" name="publisher" placeholder="출판사" value="${param.publisher}" autocomplete="off" />
      </div>
      <div class="col-md-4 col-sm-8">
        <div class="input-group">
          <input type="date" class="form-control" name="fromDate" value="${param.fromDate}" />
          <span class="input-group-text">~</span>
          <input type="date" class="form-control" name="toDate" value="${param.toDate}" />
        </div>
      </div>
      <div class="col-md-2 col-sm-4">
        <input type="number" class="form-control" name="minPrice" placeholder="최소가격" value="${param.minPrice}" min="0" />
      </div>
      <div class="col-md-2 col-sm-4">
        <input type="number" class="form-control" name="maxPrice" placeholder="최대가격" value="${param.maxPrice}" min="0" />
      </div>
      <div class="col-auto">
        <button type="submit" class="btn btn-primary px-4">검색</button>
        <a href="list" class="btn btn-outline-secondary px-4 ms-2">초기화</a>
      </div>
    </form>

    <!-- 결제내역 테이블 -->
    <div class="table-responsive">
      <table class="table table-hover align-middle mb-0">
        <thead>
          <tr>
            <th>결제 ID</th>
            <th>결제일</th>
            <th>회원 이름</th>
            <th>회원 아이디</th>
            <th>도서명</th>
            <th>저자</th>
            <th>출판사</th>
            <th>가격</th>
            <th>수량</th>
            <th>총액</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="payment" items="${paymentList}">
            <tr>
              <td>${payment.id}</td>
              <td><fmt:formatDate value="${payment.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
              <td>${payment.userName}</td>
              <td>${payment.userId}</td>
              <td>${payment.bookTitle}</td>
              <td>${payment.bookAuthor}</td>
              <td>${payment.bookPublisher}</td>
              <td><fmt:formatNumber value="${payment.bookPrice}" type="number" groupingUsed="true" />원</td>
              <td>${payment.quantity}</td>
              <td><fmt:formatNumber value="${payment.bookPrice * payment.quantity}" type="number" groupingUsed="true" />원</td>
            </tr>
          </c:forEach>

          <c:if test="${empty paymentList}">
            <tr>
              <td colspan="10" class="text-center text-secondary py-4">결제내역이 없습니다.</td>
            </tr>
          </c:if>
        </tbody>
      </table>
    </div>
  </div>

<script>
  // JSP -> JS: 결제일(ISO)과 총액 직렬화
  const payments = [
    <c:forEach var="p" items="${paymentList}" varStatus="s">
      {
        date: '<fmt:formatDate value="${p.createdAt}" pattern="yyyy-MM-dd\'T\'HH:mm:ss" />',
        total: ${p.bookPrice * p.quantity}
      }<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];

  // 월(YYYY-MM) 단위 합계 집계
  const monthlyMap = new Map();
  payments.forEach(function(p) {
    if (!p || !p.date) return;
    var d = new Date(p.date);                // 로컬타임으로 파싱
    if (isNaN(d.getTime())) return;          // 날짜 파싱 실패 방어
    var key = d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0');
    var prev = monthlyMap.get(key) || 0;
    monthlyMap.set(key, prev + Number(p.total || 0));
  });

  // 정렬된 라벨/데이터
  var labels = Array.from(monthlyMap.keys()).sort();
  var data = labels.map(function(k) { return monthlyMap.get(k); });

  // 천단위 포맷 (원화)
  function krw(v) { return (v == null ? 0 : v).toLocaleString('ko-KR'); }

  // 차트 렌더링
  var ctx = document.getElementById('monthlySalesChart');
  if (ctx) {
    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: '매출액 (원)',
          data: data,
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              // y축 천단위 표시
              callback: function(v) { return krw(v); }
            }
          }
        },
        plugins: {
          tooltip: {
            callbacks: {
              // 백틱/템플릿리터럴 사용 금지 (JSP EL 충돌 방지)
              label: function(item) { return ' ' + krw(item.raw) + ' 원'; }
            }
          },
          legend: { display: false }
        }
      }
    });
  }
</script>

</body>
</html>
