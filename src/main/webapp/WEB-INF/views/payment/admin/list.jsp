<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
    .chart-container { height: 320px; }
    @media (max-width: 767px) {
      .summary-card .card-title { font-size:1.2rem; }
      .search-box { padding:1rem; }
      .dashboard-header { font-size:1.3rem; }
      .chart-container { height: 240px; }
    }

    /* 슬라이더 */
    .chart-slider { position: relative; overflow: hidden; }
    .chart-track  { display: flex; transition: transform .3s ease; }
    .chart-pane   { min-width: 100%; padding: 1rem 0.25rem; }
    .slide-nav-btn{
      position:absolute; top:50%; transform:translateY(-50%);
      border:none; background:rgba(0,0,0,.05); width:44px; height:44px;
      border-radius:50%; box-shadow:0 2px 8px rgba(0,0,0,.08);
    }
    .slide-prev { left: 8px; }
    .slide-next { right: 8px; }
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

    <!-- ===== 메인 차트: 드롭다운 선택 ===== -->
    <div class="row justify-content-center mb-4">
      <div class="col-lg-10 col-xl-8">
        <div class="card summary-card">
          <div class="card-header d-flex flex-wrap gap-2 align-items-center justify-content-between">
            <div>
              <strong>구매 현황 차트</strong>
              <small class="text-secondary ms-2">유형을 선택하세요</small>
            </div>
            <div class="d-flex gap-2">
              <select id="chartTypeSelect" class="form-select">
                <option value="daily7">일별 구매수 (최근 7일)</option>
                <option value="monthlyThisYear">월별 구매수 (올해)</option>
                <option value="yearly">년도별 구매수</option>
                <option value="categoryPie">카테고리별 구매수 (파이)</option>
              </select>
            </div>
          </div>
          <div class="card-body">
            <div class="chart-container">
              <canvas id="mainChart"></canvas>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ===== 인사이트 슬라이드(4종) ===== -->
    <div class="card summary-card mb-5">
      <div class="card-header d-flex justify-content-between align-items-center">
        <span>인사이트(슬라이드): ①일별 매출&건수 ②AOV ③시간대 분포 ④Top5</span>
        <small class="text-secondary">좌/우 화살표로 넘겨보세요</small>
      </div>
      <div class="card-body position-relative">
        <button type="button" class="slide-nav-btn slide-prev" id="insightPrev">←</button>
        <button type="button" class="slide-nav-btn slide-next" id="insightNext">→</button>

        <div class="chart-slider">
          <div class="chart-track" id="insightTrack">
            <div class="chart-pane">
              <canvas id="insightRevenueOrders" height="110"></canvas>
            </div>
            <div class="chart-pane">
              <canvas id="insightAov" height="110"></canvas>
            </div>
            <div class="chart-pane">
              <canvas id="insightHourly" height="110"></canvas>
            </div>
            <div class="chart-pane">
              <canvas id="insightTop5" height="110"></canvas>
            </div>
          </div>
        </div>
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

<!-- ===== 데이터 직렬화 & 차트 스크립트 ===== -->
<script>
  // JSP -> JS 직렬화
  const payments = [
    <c:forEach var="p" items="${paymentList}" varStatus="s">
      {
        date: '<fmt:formatDate value="${p.createdAt}" pattern="yyyy-MM-dd\'T\'HH:mm:ss" />',
        quantity: ${p.quantity},
        bookPrice: ${p.bookPrice},
        total: ${p.bookPrice * p.quantity},
        bookTitle: '${fn:escapeXml(p.bookTitle)}',
        // 장르가 없으면 공백 -> JS에서 '미지정' 처리
        bookGenre: '${p.bookGenre}'
      }<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];

  // (선택) 서버 집계가 내려온 경우: categorySummary = [{name, count, totalPrice}, ...]
  const categorySummary = [
    <c:forEach var="c" items="${categorySummary}" varStatus="s">
      { name: '${fn:escapeXml(c.name)}', count: ${c.count}, totalPrice: ${c.totalPrice} }<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];

  // 공통 유틸
  function ymd(d){var yy=d.getFullYear(),mm=String(d.getMonth()+1).padStart(2,'0'),dd=String(d.getDate()).padStart(2,'0');return yy+'-'+mm+'-'+dd;}
  function krw(v){return (v==null?0:v).toLocaleString('ko-KR');}

  // 정규화
  const norm = payments.filter(p=>p && p.date).map(p=>{
    const d = new Date(p.date);
    return {
      date: d, ymd: isNaN(d.getTime())? null : ymd(d), hour: isNaN(d.getTime())? null : d.getHours(),
      qty: Number(p.quantity||1), price: Number(p.bookPrice||0),
      total: Number(p.total!=null?p.total:(p.bookPrice||0)*(p.quantity||1)),
      bookTitle: p.bookTitle || '',
      category: (p.bookGenre && p.bookGenre.trim()) ? p.bookGenre.trim() : '미지정'
    };
  }).filter(x=>x.ymd);

  // 날짜 경계
  const today = new Date(); today.setHours(0,0,0,0);
  const start7 = new Date(today); start7.setDate(start7.getDate()-6);

  // 최근 7일 라벨
  const labels7 = Array.from({length:7}, (_,i)=>{ const d=new Date(start7); d.setDate(start7.getDate()+i); return ymd(d); });

  // 올해 월 라벨
  const yearNow = today.getFullYear();
  const labelsMonth = ['01','02','03','04','05','06','07','08','09','10','11','12'].map(m=>yearNow+'-'+m);

  // === 메인 차트 집계 ===
  function aggDailyCount7d(){
    const map = new Map(labels7.map(k=>[k,0]));
    norm.forEach(p=>{ if(p.date>=start7 && p.date<=today) map.set(p.ymd,(map.get(p.ymd)||0)+1); });
    return labels7.map(k=>map.get(k)||0);
  }

  function aggMonthlyCountThisYear(){
    const map = new Map(labelsMonth.map(k=>[k,0]));
    norm.forEach(p=>{
      if(p.date.getFullYear()===yearNow){
        const key = p.date.getFullYear()+'-'+String(p.date.getMonth()+1).padStart(2,'0');
        map.set(key,(map.get(key)||0)+1);
      }
    });
    return labelsMonth.map(k=>map.get(k)||0);
  }

  function aggYearlyCount(){
    const years = new Set(norm.map(p=>p.date.getFullYear()));
    const ys = Array.from(years).sort((a,b)=>a-b);
    const map = new Map(ys.map(y=>[y,0]));
    norm.forEach(p=>map.set(p.date.getFullYear(),(map.get(p.date.getFullYear())||0)+1));
    return { labels: ys.map(String), data: ys.map(y=>map.get(y)||0) };
  }

  function aggCategoryCount(){
    // 서버 집계가 있으면 우선 사용
    if (categorySummary && categorySummary.length){
      return { labels: categorySummary.map(x=>x.name||'미지정'), data: categorySummary.map(x=>x.count||0) };
    }
    // 클라이언트 집계
    const map = new Map();
    norm.forEach(p=>map.set(p.category,(map.get(p.category)||0)+1));
    const arr = Array.from(map.entries()).sort((a,b)=>b[1]-a[1]);
    return { labels: arr.map(e=>e[0]), data: arr.map(e=>e[1]) };
  }

  // === 인사이트용 집계 ===
  function aggDailyRevenueAndOrders7d(){
    const rev = new Map(labels7.map(k=>[k,0]));
    const cnt = new Map(labels7.map(k=>[k,0]));
    norm.forEach(p=>{
      if(p.date>=start7 && p.date<=today){
        rev.set(p.ymd,(rev.get(p.ymd)||0)+p.total);
        cnt.set(p.ymd,(cnt.get(p.ymd)||0)+1);
      }
    });
    return { labels: labels7, revenue: labels7.map(k=>rev.get(k)||0), orders: labels7.map(k=>cnt.get(k)||0) };
  }
  function aggDailyAov7d(){
    const d = aggDailyRevenueAndOrders7d();
    return { labels: d.labels, data: d.labels.map((_,i)=> d.orders[i]===0 ? 0 : Math.round(d.revenue[i]/d.orders[i])) };
  }
  function aggHourlyOrders7d(){
    const arr = new Array(24).fill(0);
    norm.forEach(p=>{ if(p.date>=start7 && p.date<=today && p.hour!=null) arr[p.hour]+=1; });
    return { labels: Array.from({length:24}, (_,h)=>(h<10?'0':'')+h+':00'), data: arr };
  }
  function aggTop5Books7d(){
    const map = new Map();
    norm.forEach(p=>{ if(p.date>=start7 && p.date<=today){ map.set(p.bookTitle,(map.get(p.bookTitle)||0)+p.total); }});
    const sorted = Array.from(map.entries()).sort((a,b)=>b[1]-a[1]).slice(0,5);
    return { labels: sorted.map(e=>e[0]), data: sorted.map(e=>e[1]) };
  }

  // 메인 차트 렌더링
  let mainChart;
  function renderMainChart(type){
    const el = document.getElementById('mainChart');
    if(!el) return;
    if(mainChart) mainChart.destroy();

    let cfg = null;
    if(type==='daily7'){
      const data = aggDailyCount7d();
      cfg = { type:'bar', data:{ labels:labels7, datasets:[{label:'구매수(건)', data, borderWidth:1}] },
        options:{ responsive:true, maintainAspectRatio:false, scales:{ y:{ beginAtZero:true } }, plugins:{ legend:{display:false} } } };
    } else if(type==='monthlyThisYear'){
      const data = aggMonthlyCountThisYear();
      cfg = { type:'bar', data:{ labels:labelsMonth, datasets:[{label:'구매수(건)', data, borderWidth:1}] },
        options:{ responsive:true, maintainAspectRatio:false, scales:{ y:{ beginAtZero:true } }, plugins:{ legend:{display:false} } } };
    } else if(type==='yearly'){
      const yr = aggYearlyCount();
      cfg = { type:'bar', data:{ labels:yr.labels, datasets:[{label:'구매수(건)', data:yr.data, borderWidth:1}] },
        options:{ responsive:true, maintainAspectRatio:false, scales:{ y:{ beginAtZero:true } }, plugins:{ legend:{display:false} } } };
    } else if(type==='categoryPie'){
      const cat = aggCategoryCount();
      cfg = { type:'pie', data:{ labels:cat.labels, datasets:[{label:'구매수(건)', data:cat.data}] },
        options:{ responsive:true, maintainAspectRatio:false } };
    }
    if(cfg) mainChart = new Chart(el, cfg);
  }
  const selectEl = document.getElementById('chartTypeSelect');
  if(selectEl){
    selectEl.addEventListener('change', e=>renderMainChart(e.target.value));
    renderMainChart(selectEl.value); // 초기
  }

  // 인사이트 4종 렌더링
  const insights = { charts: [], idx: 0 };
  function renderInsightCharts(){
    // 1) 일별 매출 & 주문건수(이중축)
    const d1 = aggDailyRevenueAndOrders7d();
    const el1 = document.getElementById('insightRevenueOrders');
    if(el1){
      insights.charts[0] = new Chart(el1,{
        type:'bar',
        data:{ labels:d1.labels, datasets:[
          { label:'매출(원)', data:d1.revenue, yAxisID:'y1', borderWidth:1 },
          { type:'line', label:'주문수(건)', data:d1.orders, yAxisID:'y2', borderWidth:2, tension:.3, pointRadius:3 }
        ]},
        options:{
          responsive:true,
          scales:{
            y1:{ type:'linear', position:'left', ticks:{ callback:v=>krw(v) } },
            y2:{ type:'linear', position:'right', grid:{ drawOnChartArea:false } }
          },
          plugins:{ legend:{display:false},
            tooltip:{ callbacks:{ label:ctx=> (ctx.dataset.yAxisID==='y1'?' 매출 '+krw(ctx.raw)+' 원':' 주문 '+ctx.raw+' 건') } }
          }
        }
      });
    }
    // 2) AOV
    const d2 = aggDailyAov7d();
    const el2 = document.getElementById('insightAov');
    if(el2){
      insights.charts[1] = new Chart(el2,{
        type:'line',
        data:{ labels:d2.labels, datasets:[{ label:'AOV(원)', data:d2.data, borderWidth:2, pointRadius:3, tension:.3 }]},
        options:{ responsive:true, scales:{ y:{ beginAtZero:true, ticks:{ callback:v=>krw(v) } } }, plugins:{ legend:{display:false}, tooltip:{ callbacks:{ label:i=>' '+krw(i.raw)+' 원' } } } }
      });
    }
    // 3) 시간대별
    const d3 = aggHourlyOrders7d();
    const el3 = document.getElementById('insightHourly');
    if(el3){
      insights.charts[2] = new Chart(el3,{
        type:'bar',
        data:{ labels:d3.labels, datasets:[{ label:'주문수(건)', data:d3.data, borderWidth:1 }]},
        options:{ responsive:true, scales:{ y:{ beginAtZero:true } }, plugins:{ legend:{display:false} } }
      });
    }
    // 4) Top5
    const d4 = aggTop5Books7d();
    const el4 = document.getElementById('insightTop5');
    if(el4){
      insights.charts[3] = new Chart(el4,{
        type:'bar',
        data:{ labels:d4.labels, datasets:[{ label:'매출(원)', data:d4.data, borderWidth:1 }]},
        options:{ indexAxis:'y', responsive:true, scales:{ x:{ ticks:{ callback:v=>krw(v) } } }, plugins:{ legend:{display:false}, tooltip:{ callbacks:{ label:i=>' '+krw(i.raw)+' 원' } } } }
      });
    }
  }
  function updateInsightSlide(){
    const track = document.getElementById('insightTrack');
    if(!track) return;
    track.style.transform = 'translateX(-'+(insights.idx*100)+'%)';
  }
  document.getElementById('insightPrev')?.addEventListener('click', ()=>{ insights.idx=(insights.idx-1+4)%4; updateInsightSlide(); });
  document.getElementById('insightNext')?.addEventListener('click', ()=>{ insights.idx=(insights.idx+1)%4; updateInsightSlide(); });

  renderInsightCharts();
  updateInsightSlide();
  window.addEventListener('resize', updateInsightSlide);
</script>
</body>
</html>
