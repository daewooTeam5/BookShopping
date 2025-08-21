<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

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

.pay {
	color: black;
	background-color: lightgreen;
	border: none;
	border-radius: 6px;
	font-size: 14px;
	text-align: center;
	align-items: center;
}

.payform {
	margin: 0;
	padding: 0;
	display: inline;
}

td {
	text-align: center;
}

th {
	text-align: center;
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
							<c:when test="${user.userRole == 'ROLE_GUEST'}">
								<p>
									<strong>권한:</strong> 비회원
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

				<div class="card">
					<div class="card-header">
						<h3>배송지 관리</h3>
					</div>
					<div class="card-body">
						<h5 class="mb-3">나의 배송지 목록</h5>
						<c:choose>
							<c:when test="${not empty addressList}">
								<ul class="list-group mb-3">
									<c:forEach var="addr" items="${addressList}">
										<li class="list-group-item">(${addr.zipcode})
											${addr.province} ${addr.city} ${addr.street}</li>
									</c:forEach>
								</ul>
							</c:when>
							<c:otherwise>
								<p class="text-muted">저장된 배송지가 없습니다.</p>
							</c:otherwise>
						</c:choose>

						<button type="button" id="add-address-btn"
							class="btn btn-outline-info btn-block mb-3">새 배송지 추가</button>

						<form id="add-address-form"
							action="${pageContext.request.contextPath}/address/add"
							method="post" style="display: none;">
							<sec:csrfInput />
							<h5 class="mt-3">새 배송지 입력</h5>
							<div class="form-group">
								<label>광역/도</label> <input type="text" name="province"
									class="form-control" placeholder="예: 서울특별시" required
									maxlength="100">
							</div>
							<div class="form-group">
								<label>시/군/구</label> <input type="text" name="city"
									class="form-control" placeholder="예: 강남구" required
									maxlength="100">
							</div>
							<div class="form-group">
								<label>상세주소</label> <input type="text" name="street"
									class="form-control" placeholder="예: 테헤란로 123" required
									maxlength="100">
							</div>
							<div class="form-group">
								<label>우편번호</label> <input type="text" name="zipcode"
									class="form-control" placeholder="5자리 숫자" required
									maxlength="6">
							</div>
							<button type="submit" class="btn btn-info btn-block">추가하기</button>
						</form>
					</div>
				</div>
			</div>

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
								<form id="order-form"
									action="${pageContext.request.contextPath}/payment/addressFormFromCart"
									method="post">
									<sec:csrfInput />
									<div id="cart-items">
										<c:forEach var="item" items="${shoppingCart}">
											<div class="item-row" data-price="${item.price}">
												<input type="checkbox" name="cartIds" value="${item.id}"
													class="item-checkbox" checked>
												<div class="item-details">
													<img src="/img/${item.image}" alt="${item.title}"
														class="cart-item-img ml-3">
													<div class="item-info">
														<h5>${item.title}</h5>
														<span><fmt:formatNumber value="${item.price}"
																type="currency" currencySymbol="" />원</span>
													</div>
												</div>
												<div class="quantity-controls mx-4 d-flex">
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
												</div>
											</div>
										</c:forEach>
									</div>
									<button type="submit" class="btn btn-primary btn-block mt-3">주문하기</button>
								</form>
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
								<table class="table ">
									<thead>
										<tr>
											<th>주문 ID</th>
											<th>결제일</th>
											<th>책 제목</th>
											<th>이미지</th>
											<th>장르</th>
											<th>출판사</th>
											<th>가격</th>
											<th>수량</th>
											<th>영수증</th>

										</tr>
									</thead>
									<tbody>

										<c:forEach var="entry" items="${groupedPayments}">
											<c:set var="receiptId" value="${entry.key}" />
											<c:set var="payments" value="${entry.value}" />
											<c:forEach var="payment" items="${payments}" varStatus="loop">
												<tr>
													<c:if test="${loop.first}">
														<td rowspan="${fn:length(payments)}">
															<!-- 강조만 하기 -->
															<h6
																style="border: none; background: none; padding: 0; color: inherit; text-decoration: none;">
																P-${fn:split(receiptId, '-')[0]}-${fn:split(receiptId, '-')[1]}
															</h6>

														</td>
														<td rowspan="${fn:length(payments)}">
															${fn:replace(payment.createdAt, "T", " ")}</td>
													</c:if>
													<td>${payment.title}</td>
													<td><img src="/img/${payment.image}"
														class="cart-item-img" /></td>
													<td>${payment.genre}</td>
													<td>${payment.publisher}</td>
													<td><fmt:formatNumber value="${payment.price}"
															type="currency" currencySymbol="" />원</td>
													<td>${payment.quantity}</td>

													<td>
														<!-- 폼에다 input타입들을 히든으로 주어서 가져오기 -->
														<form class="payform" action="/user/receipt" method="post"
															var="item" items="${payment}" style="margin: 0;">

															<input type="hidden" name="${_csrf.parameterName}"
																value="${_csrf.token}" /> <input type="hidden"
																name="receiptId" value="${receiptId}" /> <input
																type="hidden" name="createdAt"
																value="${payment.createdAt}" /> <input type="hidden"
																name="title" value="${payment.title}" /> <input
																type="hidden" name="image" value="${payment.image}" />
															<input type="hidden" name="genre"
																value="${payment.genre}" /> <input type="hidden"
																name="publisher" value="${payment.publisher}" /> <input
																type="hidden" name="price" value="${payment.price}" />
															<input type="hidden" name="quantity"
																value="${payment.quantity}" />

															<button type="submit"
																style="border: 1px solid lightgrey; border-radius: 3px;">영수증</button>

														</form>


													</td>
												</tr>

											</c:forEach>
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
								<h4>총 수량: ${totalQuantity}권</h4>
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
    document.getElementById('add-address-btn').addEventListener('click', function() {
        var form = document.getElementById('add-address-form');
        if (form.style.display === 'none') {
            form.style.display = 'block';
            this.textContent = '추가 취소';
        } else {
            form.style.display = 'none';
            this.textContent = '새 배송지 추가';
        }
    });

    const csrfToken = '${_csrf.token}';
    document.addEventListener('DOMContentLoaded', function () {
        if (document.getElementById('order-form')) {
            updateTotalPrice();
            document.querySelectorAll('.quantity-plus').forEach(btn => btn.addEventListener('click', () => updateQuantity(btn, 1)));
            document.querySelectorAll('.quantity-minus').forEach(btn => btn.addEventListener('click', () => updateQuantity(btn, -1)));
            document.querySelectorAll('.item-checkbox').forEach(checkbox => checkbox.addEventListener('change', updateTotalPrice));
            document.querySelectorAll('.delete-item-btn').forEach((btn,idx) => btn.addEventListener('click', () => deleteItem(btn,idx)));
            document.getElementById('order-form').addEventListener('submit', function(e) {
                if (document.querySelectorAll('.item-checkbox:checked').length === 0) {
                    alert('결제할 상품을 선택해주세요.');
                    e.preventDefault();
                    return;
                }
                let total = 0;
                document.querySelectorAll('.item-row').forEach(itemRow => {
                    const checkbox = itemRow.querySelector('.item-checkbox');
                    if (checkbox && checkbox.checked) {
                        const price = parseFloat(itemRow.dataset.price);
                        const quantity = parseInt(itemRow.querySelector('input[name="quantity"]').value);
                        total += price * quantity;
                    }
                });
                const formattedTotal = new Intl.NumberFormat('ko-KR', { style: 'currency', currency: 'KRW' }).format(total);
                if (!confirm('총 결제 금액: ' + formattedTotal + '\n결제하시겠습니까?')) {
                    e.preventDefault();
                }
            });
        }
    });

    function updateQuantity(button, change) {
        const controls = button.closest('.quantity-controls');
        const quantityInput = controls.querySelector('input[name="quantity"]');
        const id = controls.querySelector('input[name="id"]').value;
        let newQuantity = parseInt(quantityInput.value) + change;
        if (newQuantity < 1) newQuantity = 1;

        const params = new URLSearchParams();
        params.append('id', id);
        params.append('quantity', newQuantity);
        
        fetch('/cart/update-quantity', { method: 'POST', headers: {'X-CSRF-TOKEN': csrfToken}, body: params })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                quantityInput.value = data.newQuantity;
                controls.querySelector('.quantity-input').value = data.newQuantity;
                updateTotalPrice();
            } else { alert('수량 업데이트 실패'); }
        }).catch(() => alert('수량 업데이트 중 오류가 발생했습니다.'));
    }

    function updateTotalPrice() {
        let total = 0;
        document.querySelectorAll('.item-row').forEach(row => {
            if (row.querySelector('.item-checkbox').checked) {
                const price = parseFloat(row.dataset.price);
                const quantity = parseInt(row.querySelector('input[name="quantity"]').value);
                total += price * quantity;
            }
        });
        document.getElementById('total-price').innerText = '총계: ' + new Intl.NumberFormat('ko-KR', { style: 'currency', currency: 'KRW' }).format(total);
    }
    
    function deleteItem(button,idx) {
        const id = document.querySelectorAll("#shop-item-id")[idx].value;
        const itemRow = button.closest('.item-row');
        if (!confirm('정말로 삭제하시겠습니까?')) return;

        fetch("/cart/delete/"+id, { method: 'POST', headers: {'X-CSRF-TOKEN': csrfToken} })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                itemRow.remove();
                updateTotalPrice();
                if(document.querySelectorAll('.item-row').length === 0){
                    location.reload();
                }
            } else {
                alert('삭제 실패: ' + data.message);
            }
        }).catch(() => alert('삭제 중 오류가 발생했습니다.'));
    }
    
    
	</script>
</body>
</html>