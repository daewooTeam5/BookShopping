<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주소 선택</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { background-color: #f8f9fa; }
    .container { max-width: 700px; margin-top: 40px; }
    .card { border-radius: 1rem; }
    .address-item:hover { background-color: #f1f1f1; }
    .item-img { width: 60px; height: auto; margin-right: 15px; }
</style>
</head>
<body>
    <div class="container">
        <div class="card p-4 mb-4">
            <h4 class="mb-3">주문 상품 정보</h4>
            <ul class="list-group list-group-flush">
                <c:forEach var="item" items="${purchaseItems}">
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                            <img src="${item.image}" alt="${item.title}" class="item-img rounded">
                            <div>
                                <h6 class="my-0">${item.title}</h6>
                                <small class="text-muted">${item.quantity}개</small>
                            </div>
                        </div>
                        <span class="text-muted"><fmt:formatNumber value="${item.price * item.quantity}" type="number" groupingUsed="true" />원</span>
                    </li>
                </c:forEach>
            </ul>
            <hr>
            <div class="d-flex justify-content-between">
                <h4>총 결제 금액</h4>
                <h4><fmt:formatNumber value="${totalPrice}" type="number" groupingUsed="true" />원</h4>
            </div>
        </div>

        <div class="card p-4">
            <h2 class="mb-4 text-center">배송지 선택</h2>
            <form id="payment-form" method="post">
                <sec:csrfInput/>
                
                <input type="hidden" name="purchaseType" value="${purchaseType}">
                <c:if test="${not empty bookId}"><input type="hidden" name="bookId" value="${bookId}"></c:if>
                <c:if test="${not empty quantity}"><input type="hidden" name="quantity" value="${quantity}"></c:if>
                <c:if test="${not empty cartIds}">
                    <c:forEach var="cartId" items="${cartIds}"><input type="hidden" name="cartIds" value="${cartId}"></c:forEach>
                </c:if>

                <div id="saved-address-view">
                    <c:if test="${not empty addresses}">
                        <h5 class="mb-3">배송지 목록</h5>
                        <c:forEach var="addr" items="${addresses}" varStatus="status">
                            <div class="form-check address-item p-3 border rounded mb-2">
                                <input class="form-check-input" type="radio" name="addressId" id="addr${addr.id}" value="${addr.id}" ${status.first ? 'checked' : ''}>
                                <label class="form-check-label w-100" for="addr${addr.id}">
                                    <strong>(${addr.zipcode})</strong> ${addr.province} ${addr.city} ${addr.street}
                                </label>
                            </div>
                        </c:forEach>
                        <button type="submit" class="btn btn-primary w-100 mt-3" onclick="setFormAction('processPayment')">이 주소로 결제하기</button>
                    </c:if>
                    <button type="button" class="btn btn-outline-secondary w-100 mt-2" id="show-new-address-btn">
                        ${not empty addresses ? '새 배송지 추가' : '배송지 직접 입력'}
                    </button>
                </div>

                <div id="new-address-view" style="display:none;">
                    <h5 class="mb-3">새 배송지 입력</h5>
                    <div class="form-group mb-3">
                        <label class="form-label">광역/도</label>
                        <input type="text" name="province" class="form-control" placeholder="예: 서울특별시" maxlength="100">
                    </div>
                    <div class="form-group mb-3">
                        <label class="form-label">시/군/구</label>
                        <input type="text" name="city" class="form-control" placeholder="예: 강남구" maxlength="100">
                    </div>
                    <div class="form-group mb-3">
                        <label class="form-label">상세주소</label>
                        <input type="text" name="street" class="form-control" placeholder="예: 테헤란로 123" maxlength="100">
                    </div>
                    <div class="form-group mb-3">
                        <label class="form-label">우편번호</label>
                        <input type="text" name="zipcode" class="form-control" placeholder="5자리 숫자" maxlength="6">
                    </div>
                    <button type="submit" class="btn btn-primary w-100 mt-3" onclick="setFormAction('processPaymentWithNewAddress')">입력한 주소로 결제하기</button>
                    <c:if test="${not empty addresses}">
                         <button type="button" class="btn btn-outline-secondary w-100 mt-2" id="show-saved-address-btn">저장된 배송지 목록 보기</button>
                    </c:if>
                </div>
                <button type="button" class="btn btn-secondary w-100 mt-3" onclick="history.back()">뒤로가기</button>
            </form>
        </div>
    </div>

    <script>
        const form = document.getElementById('payment-form');
        const savedView = document.getElementById('saved-address-view');
        const newView = document.getElementById('new-address-view');
        const showNewBtn = document.getElementById('show-new-address-btn');
        const showSavedBtn = document.getElementById('show-saved-address-btn');

        showNewBtn.addEventListener('click', function() {
            savedView.style.display = 'none';
            newView.style.display = 'block';
        });

        if (showSavedBtn) {
            showSavedBtn.addEventListener('click', function() {
                newView.style.display = 'none';
                savedView.style.display = 'block';
            });
        }
        
        function setFormAction(action) {
            if (action === 'processPayment') {
                form.action = '${pageContext.request.contextPath}/payment/processPayment';
            } else if (action === 'processPaymentWithNewAddress') {
                const requiredInputs = newView.querySelectorAll('input[type=text]');
                for(const input of requiredInputs) {
                    if (!input.value) {
                        alert('"' + input.previousElementSibling.textContent + '" 항목을 입력해주세요.');
                        input.focus();
                        event.preventDefault(); // 폼 제출을 막음
                        return;
                    }
                }
                form.action = '${pageContext.request.contextPath}/payment/processPaymentWithNewAddress';
            }
        }

        window.addEventListener('DOMContentLoaded', function() {
            const hasAddresses = ${not empty addresses};
            if (!hasAddresses) {
                savedView.style.display = 'none';
                newView.style.display = 'block';
            }
        });
    </script>
</body>
</html>