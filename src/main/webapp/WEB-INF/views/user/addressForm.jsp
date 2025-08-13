<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
    .address-item { cursor: pointer; }
    .address-item:hover { background-color: #f1f1f1; }
</style>
</head>
<body>
    <div class="container">
        <div class="card p-4">
            <h2 class="mb-4 text-center">배송지 선택</h2>
            <form id="payment-form" action="${pageContext.request.contextPath}/payment/processPayment" method="post">
                <sec:csrfInput/>
                
                <!-- 구매 정보 (Hidden Fields) -->
                <input type="hidden" name="purchaseType" value="${purchaseType}">
                <c:if test="${not empty bookId}"><input type="hidden" name="bookId" value="${bookId}"></c:if>
                <c:if test="${not empty quantity}"><input type="hidden" name="quantity" value="${quantity}"></c:if>
                <c:if test="${not empty cartIds}">
                    <c:forEach var="cartId" items="${cartIds}"><input type="hidden" name="cartIds" value="${cartId}"></c:forEach>
                </c:if>

                <!-- 저장된 주소 목록 -->
                <div id="saved-address-list">
                    <h5 class="mb-3">배송지 목록</h5>
                    <c:if test="${empty addresses}">
                        <p class="text-muted">저장된 배송지가 없습니다. <a href="/user/my-page">마이페이지</a>에서 배송지를 추가해주세요.</p>
                    </c:if>
                    <c:forEach var="addr" items="${addresses}" varStatus="status">
                        <div class="form-check address-item p-3 border rounded mb-2">
                            <input class="form-check-input" type="radio" name="addressId" id="addr${addr.id}" value="${addr.id}" ${status.first ? 'checked' : ''}>
                            <label class="form-check-label" for="addr${addr.id}">
                                <strong>(${addr.zipcode})</strong> ${addr.province} ${addr.city} ${addr.street}
                            </label>
                        </div>
                    </c:forEach>
                </div>
                <hr>

                <div class="d-grid gap-2 mt-4">
                    <c:if test="${not empty addresses}">
                        <button type="submit" class="btn btn-primary btn-lg">이 주소로 결제하기</button>
                    </c:if>
                    <button type="button" class="btn btn-secondary" onclick="history.back()">뒤로가기</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
