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
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

  <style>
    body { background:#f7f8fb; }
    .dashboard-header { font-weight:700; letter-spacing:-.3px; }
    .summary-card { border:0; border-radius:1.2rem; box-shadow:0 6px 16px rgba(0,0,0,0.05); overflow:hidden; }
    .summary-card .card-header { background:#fff; font-weight:600; padding:1rem 1.25rem; }
    .table thead th { background:#f1f4f9; font-weight:600; }
    .table td { font-size:0.96rem; }
    .search-box { background:#fff; border-radius:1.2rem; box-shadow:0 2px 12px rgba(0,0,0,0.05); padding:1.5rem 2rem; }
    .search-box .form-label { font-size:0.92rem; color:#555; }

    /* 차트 높이 통일 및 슬라이더 스타일 */
    .chart-container { height: 320px; }
    .chart-container canvas { width: 100% !important; height: 100% !important; }
    .chart-slider { position: relative; overflow: hidden; height: 100%; }
    .chart-track  { display: flex; transition: transform .3s ease; height: 100%; }
    .chart-pane   { min-width: 100%; padding: 1rem 0.25rem; height: 100%; }
    .chart-pane canvas { height: 100%; }

    .slide-nav-btn{
      position:absolute; top:50%; transform:translateY(-50%);
      border:none; background:rgba(0,0,0,.05); width:44px; height:44px;
      border-radius:50%; box-shadow:0 2px 8px rgba(0,0,0,.08);
      cursor: pointer;
      z-index: 10;
    }
    .slide-prev { left: 8px; }
    .slide-next { right: 8px; }

    @media (max-width: 767px) {
      .summary-card .card-title { font-size:1.2rem; }
      .search-box { padding:1rem; }
      .dashboard-header { font-size:1.3rem; }
      .chart-container { height: 240px; }
    }
  </style>
</head>
<body>
  <div class="container py-4">
    <!-- 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div><span class="dashboard-header fs-2">📊 관리자 결제내역 대시보드</span></div>
      <div class="mb-3">
        <a href="/book/admin/list" class="btn btn-outline-secondary btn-sm">관리자 홈</a>
      </div>
    </div>

    <!-- 요약 카드 -->
    <div class="row g-4 mb-4">
      <div class="col-sm-6 col-lg-3">
        <div class="card summary-card">
          <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
              <div>
                <h6 class="text-muted mb-1">총 결제건수</h6>
                <h4 class="mb-0">${totalCount}</h4>
              </div>
              <span class="badge text-bg-light">All</span>
            </div>
          </div>
        </div>
      </div>
      <div class="col-sm-6 col-lg-3">
        <div class="card summary-card">
          <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
              <div>
                <h6 class="text-muted mb-1">총 매출(원)</h6>
                <h4 class="mb-0">
                  <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="₩"/>
                </h4>
              </div>
              <span class="badge text-bg-light">Sum</span>
            </div>
          </div>
        </div>
      </div>
      <div class="col-sm-6 col-lg-3">
        <div class="card summary-card">
          <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
              <div>
                <h6 class="text-muted mb-1">Top 5 도서</h6>
                <c:if test="${!empty topBooks}">
                  <c:forEach var="book" items="${topBooks}">
                    <h5 class="mb-0 text-truncate" style="font-size: 0.8rem; font-weight: bold;" title="${book.name}">
                       ${book.name}
                    </h5>
                    <p class="text-muted mb-0" style="font-size: 0.8rem">
                      <fmt:formatNumber value="${book.totalPrice}" type="currency" currencySymbol="₩"/> (${book.count}건)
                    </p><br>
                  </c:forEach>
                </c:if>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-sm-6 col-lg-3">
        <div class="card summary-card">
          <div class="card-body">
            <div class="d-flex justify-content-between align-items-center">
              <div>
                <h6 class="text-muted mb-1">Top 5 구매자</h6>
                <c:if test="${!empty topUsers}">
                  <c:forEach var="user" items="${topUsers}">
                    <h5 class="mb-0 text-truncate" title="${user.name}">
                      ${user.name}
                    </h5>
                    <p class="text-muted mb-0" style="font-size: 0.8rem">
                      <fmt:formatNumber value="${user.totalPrice}" type="currency" currencySymbol="₩"/> (${user.count}건)
                    </p>
                  </c:forEach>
                </c:if>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ===== 차트 섹션 (2개 나란히) ===== -->
    <div class="row mb-5 g-4">
      <div class="col-12 col-lg-6">
        <div class="card summary-card">
          <div class="card-header d-flex flex-wrap gap-2 justify-content-between align-items-center">
            <span>구매현황</span>
            <div class="d-flex align-items-center gap-2">
              <label class="me-2">주기</label>
              <select id="chartTypeSelect" class="form-select">
                <option value="daily7">일(최근 7일)</option>
                <option value="monthlyThisYear">월</option>
                <option value="yearly">년</option>
              </select>
            </div>
          </div>
          <div class="card-body chart-container">
            <h5 class="card-title text-center" id="purchaseChartTitle"></h5>
            <div class="position-relative my-2 h-100">
              <button type="button" class="slide-nav-btn slide-prev" id="purchasePrev">←</button>
              <button type="button" class="slide-nav-btn slide-next" id="purchaseNext">→</button>
              <div class="chart-slider">
                <div class="chart-track" id="purchaseTrack">
                  <div class="chart-pane"><canvas id="insightCount"></canvas></div>
                  <div class="chart-pane"><canvas id="insightRevenueOrders"></canvas></div>
                  <div class="chart-pane"><canvas id="insightHourly"></canvas></div>
                  <div class="chart-pane"><canvas id="insightTop5"></canvas></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-12 col-lg-6">
        <div class="card summary-card">
          <div class="card-header d-flex justify-content-between align-items-center">
            <span>카테고리별 구매수</span>
          </div>
          <div class="card-body chart-container">
            <div class="h-100">
              <canvas id="categoryPieChart"></canvas>
            </div>
          </div>
        </div>
      </div>
    </div>

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
        <input type="text" class="form-control" name="genre" placeholder="장르" value="${param.genre}" autocomplete="off" />
      </div>
      <div class="col-md-2 col-sm-4">
        <input type="text" class="form-control" name="publisher" placeholder="출판사" value="${param.publisher}" autocomplete="off" />
      </div>
      <div class="col-md-2 col-sm-4 d-grid d-md-block">
        <button type="submit" class="btn btn-primary w-100">검색</button>
      </div>
    </form>

    <!-- 목록 테이블 -->
    <div class="card summary-card mb-5">
      <div class="card-header">결제 내역</div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover mb-0">
            <thead>
              <tr>
                <th>#</th>
                <th>결제일</th>
                <th>회원이름</th>
                <th>회원ID</th>
                <th>도서</th>
                <th>장르</th>
                <th>가격</th>
                <th>수량</th>
                <th>합계</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="p" items="${paymentList}" varStatus="s">
                <tr>
                  <td>${s.index + 1}</td>
                  <td><fmt:formatDate value="${p.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                  <td>${p.userName}</td>
                  <td>${p.userId}</td>
                  <td>${p.bookTitle}</td>
                  <td>${p.bookGenre}</td>
                  <td><fmt:formatNumber value="${p.bookPrice}" type="currency" currencySymbol="₩"/></td>
                  <td>${p.quantity}</td>
                  <td><fmt:formatNumber value="${p.bookPrice * p.quantity}" type="currency" currencySymbol="₩"/></td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>

  </div>

  <!-- Chart.js (v4) -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>

  <script>
    // ===== JSP → JS 직렬화 =====
    const payments = [
      <c:forEach var="p" items="${paymentList}" varStatus="s">
        {
          date: '<fmt:formatDate value="${p.createdAt}" pattern="yyyy-MM-dd\'T\'HH:mm:ss" />',
          quantity: ${p.quantity},
          bookPrice: ${p.bookPrice},
          bookTitle: '${fn:escapeXml(p.bookTitle)}',
          bookGenre: '${fn:escapeXml(p.bookGenre)}'
        }<c:if test="${!s.last}">,</c:if>
      </c:forEach>
    ];

    const categorySummary = [
      <c:forEach var="c" items="${categorySummary}" varStatus="s">
        {
          name: '${fn:escapeXml(c.name)}',
          count: ${c.count}
        }<c:if test="${!s.last}">,</c:if>
      </c:forEach>
    ];

    // ===== 유틸 =====
    const krw = v => new Intl.NumberFormat('ko-KR').format(v);
    const ymd = d => d.getFullYear()+"-"+String(d.getMonth()+1).padStart(2,'0')+"-"+String(d.getDate()).padStart(2,'0');

    // ===== 정규화 =====
    const norm = payments.map(p=>{
      const d = new Date(p.date);
      return {
        date: d, ymd: isNaN(d.getTime())? null : ymd(d), hour: isNaN(d.getTime())? null : d.getHours(),
        qty: Number(p.quantity||1), price: Number(p.bookPrice||0),
        total: Number((p.bookPrice||0)*(p.quantity||1)),
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

  // === 구매현황 + 인사이트 렌더링 ===
  const purchase = { charts: [], idx: 0 };
  const purchaseTitles = ['구매수', '매출 및 주문수', '시간대별 분포', 'Top 5 도서'];

  function aggCounts(mode){
    if(mode==='daily7'){
      return { labels: labels7, data: aggDailyCount7d() };
    } else if(mode==='monthlyThisYear'){
      return { labels: labelsMonth, data: aggMonthlyCountThisYear() };
    } else {
      const yr = aggYearlyCount();
      return { labels: yr.labels, data: yr.data };
    }
  }

  function aggRevenueAndOrders(mode){
    if(mode==='daily7') return aggDailyRevenueAndOrders7d();
    if(mode==='monthlyThisYear') return aggMonthlyRevenueAndOrdersThisYear();
    return aggYearlyRevenueAndOrders();
  }

  function aggHourly(mode){
    // 간단화: daily7은 최근7일, monthly/yearly는 올해 데이터 기준
    if(mode==='daily7') return aggHourlyOrders7d();
    return aggHourlyOrdersThisYear();
  }

  function aggTop5(mode){
    if(mode==='daily7') return aggTop5Books7d();
    if(mode==='monthlyThisYear') return aggTop5BooksThisYear();
    return aggTop5BooksAll();
  }

  function renderPurchaseInsights(mode){
    // destroy old
    purchase.charts.forEach(c=>{ try{ c && c.destroy(); }catch(e){} });
    purchase.charts = [];
    purchase.idx = 0; // 슬라이더 인덱스 초기화

    // 1) 해당 유형의 구매수
    const c1 = aggCounts(mode);
    const el1 = document.getElementById('insightCount');
    if(el1){
      purchase.charts[0] = new Chart(el1, {
        type:'bar',
        data:{ labels:c1.labels, datasets:[{ label:'구매수(건)', data:c1.data, borderWidth:1 }]},
        options:{ responsive:true, maintainAspectRatio:false, plugins:{ legend:{display:false} }, scales:{ y:{ beginAtZero:true } } }
      });
    }

    // 2) 매출 & 건수
    const r = aggRevenueAndOrders(mode);
    const el2 = document.getElementById('insightRevenueOrders');
    if(el2){
      purchase.charts[1] = new Chart(el2, {
        type:'bar',
        data:{ labels:r.labels, datasets:[
          { label:'매출(원)', data:r.revenue, yAxisID:'y1', borderWidth:1 },
          { type:'line', label:'주문수(건)', data:r.orders, yAxisID:'y2', borderWidth:2, tension:.3, pointRadius:3 }
        ]},
        options:{ responsive:true, maintainAspectRatio:false, scales:{
          y1:{ type:'linear', position:'left', ticks:{ callback:v=>krw(v) } },
          y2:{ type:'linear', position:'right', grid:{ drawOnChartArea:false } }
        }, plugins:{ legend:{display:false},
          tooltip:{ callbacks:{ label:ctx=> (ctx.dataset.yAxisID==='y1'?' 매출 '+krw(ctx.raw)+' 원':' 주문 '+ctx.raw+' 건') } }
        } }
      });
    }

    // 3) 시간대 분포
    const h = aggHourly(mode);
    const el3 = document.getElementById('insightHourly');
    if(el3){
      purchase.charts[2] = new Chart(el3, {
        type:'bar',
        data:{ labels:h.labels, datasets:[{ label:'주문수(건)', data:h.data, borderWidth:1 }]},
        options:{ responsive:true, maintainAspectRatio:false, scales:{ y:{ beginAtZero:true } }, plugins:{ legend:{display:false} } }
      });
    }

    // 4) Top5
    const t = aggTop5(mode);
    const el4 = document.getElementById('insightTop5');
    if(el4){
      purchase.charts[3] = new Chart(el4, {
        type:'bar',
        data:{ labels:t.labels, datasets:[{ label:'매출(원)', data:t.data, borderWidth:1 }]},
        options:{ indexAxis:'y', responsive:true, maintainAspectRatio:false, scales:{ x:{ ticks:{ callback:v=>krw(v) } } }, plugins:{ legend:{display:false} } }
      });
    }
  }

  // 슬라이드 제어
  function updatePurchaseSlide(){
    const track = document.getElementById('purchaseTrack');
    const titleEl = document.getElementById('purchaseChartTitle');
    if(!track || !titleEl) return;
    track.style.transform = 'translateX(-'+(purchase.idx*100)+'%)';
    titleEl.textContent = purchaseTitles[purchase.idx];
  }
  document.getElementById('purchasePrev')?.addEventListener('click', ()=>{ purchase.idx=(purchase.idx-1+4)%4; updatePurchaseSlide(); });
  document.getElementById('purchaseNext')?.addEventListener('click', ()=>{ purchase.idx=(purchase.idx+1)%4; updatePurchaseSlide(); });

  // 드롭다운과 연동
  const selectEl = document.getElementById('chartTypeSelect');
  if(selectEl){
    selectEl.addEventListener('change', e=>renderPurchaseInsights(e.target.value));
    renderPurchaseInsights(selectEl.value);
  }
  updatePurchaseSlide();

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
          const key = yearNow+'-'+String(p.date.getMonth()+1).padStart(2,'0');
          map.set(key,(map.get(key)||0)+1);
        }
      });
      return labelsMonth.map(k=>map.get(k)||0);
    }

    function aggYearlyCount(){
      const map = new Map();
      norm.forEach(p=>{
        const y = String(p.getFullYear());
        map.set(y,(map.get(y)||0)+1);
      });
      const labels = Array.from(map.keys()).sort();
      return { labels, data: labels.map(k=>map.get(k)||0) };
    }

  function aggMonthlyRevenueAndOrdersThisYear(){
    const mapR = new Map(labelsMonth.map(k=>[k,0]));
    const mapO = new Map(labelsMonth.map(k=>[k,0]));
    norm.forEach(p=>{
      const key = p.date.getFullYear()===yearNow ? (yearNow+'-'+String(p.date.getMonth()+1).padStart(2,'0')) : null;
      if(!key) return;
      mapR.set(key, (mapR.get(key)||0) + (p.total||0));
      mapO.set(key, (mapO.get(key)||0) + 1);
    });
    return { labels: labelsMonth, revenue: labelsMonth.map(k=>mapR.get(k)||0), orders: labelsMonth.map(k=>mapO.get(k)||0) };
  }

  function aggYearlyRevenueAndOrders(){
    const y = aggYearlyCount(); // reuse labels
    const mapR = new Map(y.labels.map(k=>[k,0]));
    norm.forEach(p=>{
      const key = String(p.date.getFullYear());
      mapR.set(key, (mapR.get(key)||0) + (p.total||0));
    });
    return { labels: y.labels, revenue: y.labels.map(k=>mapR.get(k)||0), orders: y.data };
  }

  function aggHourlyOrdersThisYear(){
    const labels = Array.from({length:24}, (_,i)=> i.toString().padStart(2,'0')+'시');
    const map = new Map(Array.from({length:24}, (_,i)=>[i,0]));
    norm.forEach(p=>{ if(p.date.getFullYear()===yearNow){ map.set(p.hour,(map.get(p.hour)||0)+1); } });
    return { labels, data: Array.from({length:24}, (_,i)=>map.get(i)||0) };
  }

  function aggTop5BooksThisYear(){
    const map = new Map();
    norm.forEach(p=>{ if(p.date.getFullYear()===yearNow){ map.set(p.bookTitle, (map.get(p.bookTitle)||0) + (p.total||0)); } });
    const sorted = Array.from(map.entries()).sort((a,b)=>b[1]-a[1]).slice(0,5);
    return { labels: sorted.map(x=>x[0]), data: sorted.map(x=>x[1]) };
  }
  function aggTop5BooksAll(){
    const map = new Map();
    norm.forEach(p=>{ map.set(p.bookTitle, (map.get(p.bookTitle)||0) + (p.total||0)); });
    const sorted = Array.from(map.entries()).sort((a,b)=>b[1]-a[1]).slice(0,5);
    return { labels: sorted.map(x=>x[0]), data: sorted.map(x=>x[1]) };
  }

    // === 기타 집계 ===
    function aggDailyRevenueAndOrders7d(){
      const mapR = new Map(labels7.map(k=>[k,0]));
      const mapO = new Map(labels7.map(k=>[k,0]));
      norm.forEach(p=>{
        if(p.date>=start7 && p.date<=today){
          mapR.set(p.ymd,(mapR.get(p.ymd)||0)+(p.total||0));
          mapO.set(p.ymd,(mapO.get(p.ymd)||0)+1);
        }
      });
      return { labels: labels7, revenue: labels7.map(k=>mapR.get(k)||0), orders: labels7.map(k=>mapO.get(k)||0) };
    }

    function aggHourlyOrders7d(){
      const labels = Array.from({length:24}, (_,i)=> i.toString().padStart(2,'0')+'시');
      const map = new Map(Array.from({length:24}, (_,i)=>[i,0]));
      norm.forEach(p=>{ if(p.date>=start7 && p.date<=today){ map.set(p.hour,(map.get(p.hour)||0)+1); } });
      return { labels, data: Array.from({length:24}, (_,i)=>map.get(i)||0) };
    }

    function aggTop5Books7d(){
      const map = new Map();
      norm.forEach(p=>{ if(p.date>=start7 && p.date<=today){ map.set(p.bookTitle, (map.get(p.bookTitle)||0) + (p.total||0)); } });
      const sorted = Array.from(map.entries()).sort((a,b)=>b[1]-a[1]).slice(0,5);
      return { labels: sorted.map(x=>x[0]), data: sorted.map(x=>x[1]) };
    }

    // 카테고리 파이 렌더링
    (function renderCategoryPie(){
      const el = document.getElementById('categoryPieChart');
      if(!el) return;
      const labels = categorySummary.map(c => c.name);
      const data = categorySummary.map(c => c.count);
      new Chart(el, { type:'pie', data:{ labels:labels, datasets:[{ label:'구매수(건)', data:data }] },
        options:{ responsive:true, maintainAspectRatio:false } });
    })();

  </script>
</body>
</html>
