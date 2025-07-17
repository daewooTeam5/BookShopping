<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
<title>My Page</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
<style>
body {
	background-color: #f8f9fa;
}

.container {
	margin-top: 50px;
}

.card-header {
	background-color: #343a40;
	color: white;
}

.cart-item-img {
	max-width: 80px;
	height: auto;
}

.quantity-input {
	width: 60px;
	text-align: center;
}

.item-row {
	display: flex;
	align-items: center;
	margin-bottom: 15px;
	padding: 10px;
	border: 1px solid #dee2e6;
	border-radius: .25rem;
}

.item-details {
	flex-grow: 1;
	display: flex;
	align-items: center;
}

.item-info {
	margin-left: 15px;
}

.item-price, .item-total {
	min-width: 120px;
	text-align: right;
}
</style>
</head>
<body>
	<header class=" narrow-container  border-bottom mt-4"
		style="height: 80px;">
		<div
			class="d-flex justify-content-center align-items-center h-80 mb-2">
			<a href="/book/list"> <img src="/img/book.png" height="65px"
				alt="로고" />
			</a>
		</div>
	</header>
	<div class="container">
		<div class="row">
			<!-- User Info -->
			<div class="col-md-4">
				<div class="card mb-4">
					<div class="card-header">
						<h3>내 정보</h3>
					</div>
					<div class="card-body">
						<p>
							<strong>아이디:</strong> ${user.userId}
						</p>
						<p>
							<strong>이름:</strong> ${user.name}
						</p>
						<c:choose>
							<c:when test="${user.userRole == 'ROLE_ADMIN'}">
								<p>
									<strong>권한:</strong> 관리자
								</p>
							</c:when>
							<c:when test="${user.userRole == 'ROLE_USER'}">
								<p>
									<strong>권한:</strong> 회원
								</p>
							</c:when>
							<c:otherwise>
								<p>
									<strong>권한:</strong> 알 수 없음
								</p>
							</c:otherwise>
						</c:choose>
						<p>
							<strong>가입일:</strong>
							<fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd" />
						</p>
						<sec:authorize access="hasRole('ROLE_ADMIN')">
							<a href="/book/admin/list"
								class="btn btn-outline-danger btn-block">관리자 페이지</a>
						</sec:authorize>
						<form action="/logout" method="post" class="mt-3">
							<input type="hidden" name="${_csrf.parameterName}"
								id="csrf_token" value="${_csrf.token}" />
							<button type="submit" class="btn btn-danger btn-block">로그아웃</button>
						</form>
					</div>
				</div>
			</div>

			<!-- Shopping Cart -->
			<div class="col-md-8">
				<div class="card">
					<div
						class="card-header d-flex justify-content-between align-items-center">
						<h3>장바구니</h3>
						<span class="h5 mb-0" id="total-price">총계: ₩0</span>
					</div>
					<div class="card-body">
						<c:choose>
							<c:when test="${not empty shoppingCart}">
								<div id="cart-items">
									<c:forEach var="item" items="${shoppingCart}">
										<div class="item-row" data-price="${item.price}">
											<input type="checkbox" class="item-checkbox" checked>
											<div class="item-details">
												<img src="/img/${item.image}" alt="${item.title}"
													class="cart-item-img ml-3">
												<div class="item-info">
													<h5>${item.title}</h5>
													<span><fmt:formatNumber value="${item.price}"
															type="currency" currencySymbol="" />원</span>
												</div>
											</div>
											<form class="quantity-controls mx-4 d-flex">
												<input type="hidden" id="shop-item-id" name="id"
													value="${item.id}"> <input type="hidden"
													name="quantity" value="${item.quantity}">
												<button type="button"
													class="btn btn-secondary btn-sm quantity-minus">-</button>
												<input type="text"
													class="quantity-input form-control d-inline-block"
													value="${item.quantity}" readonly>
												<button type="button"
													class="btn btn-secondary btn-sm quantity-plus">+</button>
												<button type="button"
													class="btn btn-danger btn-sm delete-item-btn ml-2">
													<i class="fas fa-trash"></i>
												</button>
											</form>
										</div>
									</c:forEach>
								</div>
								<button type="button" id="order-button"
									class="btn btn-primary btn-block mt-3">주문하기</button>
							</c:when>
							<c:otherwise>
								<p class="text-center">장바구니에 담긴 상품이 없습니다.</p>
								<a href="/book/list" class="btn btn-block btn-info">쇼핑하러가기</a>

							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
		</div>

		<div class="row mt-4">
			<div class="col-md-12">
				<div class="card">
					<div class="card-header">
						<h3>결제 내역</h3>
					</div>
					<div class="card-body">
						<c:choose>
							<c:when test="${not empty myPaymentList}">
								<table class="table table-striped">
									<thead>
										<tr>
											<th>결제 ID</th>
											<th>결제 시간</th>
											<th>책 제목</th>
											<th>이미지</th>
											<th>장르</th>
											<th>출판사</th>
											<th>가격</th>
											<th>수량</th>
										</tr>
									</thead>
									<tbody>
										<c:set var="totalQuantity" value="0" />
										<c:forEach var="payment" items="${myPaymentList}">
											<tr>
												<td>${payment.id}</td>
												<td>${payment.createdAt}</td>
												<td>${payment.title}</td>
												<td><img src="/img/${payment.image}"
													alt="${payment.title}" class="cart-item-img"></td>
												<td>${payment.genre}</td>
												<td>${payment.publisher}</td>
												<td><fmt:formatNumber value="${payment.price}"
														type="currency" currencySymbol="" />원</td>
												<td>${payment.quantity}</td>
											</tr>
											<c:set var="totalQuantity"
												value="${totalQuantity + payment.quantity}" />
										</c:forEach>
									</tbody>
								</table>
							</c:when>
							<c:otherwise>
								<p class="text-center">결제 내역이 없습니다.</p>
							</c:otherwise>
						</c:choose>
						<c:if test="${not empty myPaymentList}">
							<div class="mt-3 text-right">
								<h4>총 수량: ${totalQuantity}개</h4>
								<h4>
									총 결제 금액:
									<fmt:formatNumber value="${totalPaymentAmount}" type="currency"
										currencySymbol="" />
									원
								</h4>
							</div>
						</c:if>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
  // JSP 서버에서 CSRF 토큰 JS 변수에 넣기
  const csrfToken = '${_csrf.token}';

  document.addEventListener('DOMContentLoaded', function () {
    updateTotalPrice();

    document.querySelectorAll('.quantity-plus').forEach(btn => {
      btn.addEventListener('click', () => updateQuantity(btn, 1));
    });

    document.querySelectorAll('.quantity-minus').forEach(btn => {
      btn.addEventListener('click', () => updateQuantity(btn, -1));
    });

    document.querySelectorAll('.item-checkbox').forEach(checkbox => {
      checkbox.addEventListener('change', updateTotalPrice);
    });

    document.querySelectorAll('.delete-item-btn').forEach((btn,idx) => {
      btn.addEventListener('click', () => deleteItem(btn,idx));
    });

    document.getElementById('order-button').addEventListener('click', function() {
      let total = 0;
      const selectedCartIds = [];
      document.querySelectorAll('.item-row').forEach(itemRow => {
        const checkbox = itemRow.querySelector('.item-checkbox');
        if (checkbox && checkbox.checked) {
          const price = parseFloat(itemRow.dataset.price);
          const quantity = parseInt(itemRow.querySelector('input[name="quantity"]').value);
          total += price * quantity;
          const cartIdInput = itemRow.querySelector('.quantity-controls input[name="id"]');
          if (cartIdInput) {
            selectedCartIds.push(cartIdInput.value);
          }
        }
      });

      if (selectedCartIds.length === 0) {
        alert('결제할 상품을 선택해주세요.');
        return;
      }

      const formattedTotal = new Intl.NumberFormat('ko-KR', { style: 'currency', currency: 'KRW' }).format(total);

      if (confirm('총 결제 금액: ' + formattedTotal + '\n결제하시겠습니까?')) {
        let url = '/payment/buyFromCart';
        const params = new URLSearchParams();
        params.append('_csrf', csrfToken);
        selectedCartIds.forEach(id => params.append('cartIds', id));

        fetch(url, {
          method: 'POST',
          headers: {
            'X-CSRF-TOKEN': csrfToken,
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: params
        })
        .then(response => {
          if (response.ok) {
            location.href="/user/my-page";
            alert("결제 성공");
          } else {
            alert('결제 요청에 실패했습니다.');
          }
        })
        .catch(error => {
          console.error('결제 요청 중 에러:', error);
          alert('결제 요청 중 오류가 발생했습니다.');
        });
      }
    });
  });

  function updateQuantity(button, change) {
    const form = button.closest('form');
    const quantityInput = form.querySelector('input[name="quantity"]');
    const id = form.querySelector('input[name="id"]').value;

    let currentQuantity = parseInt(quantityInput.value);
    let newQuantity = currentQuantity + change;
    if (newQuantity < 1) newQuantity = 1;

    const params = new URLSearchParams();
    params.append('id', id);
    params.append('quantity', newQuantity);
    params.append('_csrf', csrfToken); // CSRF 토큰 파라미터로도 보내기

    fetch('/cart/update-quantity', {
      method: 'POST',
      headers: {
        'X-CSRF-TOKEN': csrfToken
      },
      body: params
    })
    .then(response => {
      if (!response.ok) throw new Error('서버 응답 에러');
      return response.json();
    })
    .then(data => {
      if (data.success) {
        // 서버에서 업데이트 된 수량으로 UI 동기화
        quantityInput.value = data.newQuantity;

        // 화면에 보여지는 수량 input (readonly) 업데이트
        const displayInput = button.closest('.quantity-controls').querySelector('.quantity-input');
        displayInput.value = data.newQuantity;

        updateTotalPrice();
      } else {
        alert('수량 업데이트 실패');
      }
    })
    .catch(error => {
      console.error('업데이트 중 에러:', error);
      alert('수량 업데이트 중 오류가 발생했습니다.');
    });
  }

  function updateTotalPrice() {
    let total = 0;
    document.querySelectorAll('.item-row').forEach(row => {
      const checkbox = row.querySelector('.item-checkbox');
      if (checkbox.checked) {
        const price = parseFloat(row.dataset.price);
        const quantity = parseInt(row.querySelector('input[name="quantity"]').value);
        total += price * quantity;
      }
    });

    // 한글 KRW 통화 포맷 적용
    document.getElementById('total-price').innerText =
      '총계: ' + new Intl.NumberFormat('ko-KR', { style: 'currency', currency: 'KRW' }).format(total);
  }
  
  function deleteItem(button,idx) {
	  const id = document.querySelectorAll("#shop-item-id")[idx].value;
    const itemRow = button.closest('.item-row');
    const csrfToken = document.getElementById('csrf_token').value;

    if (!confirm('정말로 삭제하시겠습니까?')) {
      return;
    }

    fetch("/cart/delete/"+id, {
    	
      method: 'POST',
      headers: {
        'X-CSRF-TOKEN': csrfToken
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        itemRow.remove();
        updateTotalPrice();
        location.href = "/user/my-page";
      } else {
        alert('삭제 실패: ' + data.message);
      }
    })
    .catch(error => {
      console.error('삭제 중 에러:', error);
      alert('삭제 중 오류가 발생했습니다.');
    });
  }
</script>
</body>
</html>