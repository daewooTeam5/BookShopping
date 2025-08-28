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
                        <select name="province" id="province" class="form-control"></select>
                    </div>
                    <div class="form-group mb-3">
                        <label class="form-label">시/군/구</label>
                        <select name="city" id="city" class="form-control"></select>
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

            const addressData = {
                "서울특별시": ["종로구", "중구", "용산구", "성동구", "광진구", "동대문구", "중랑구", "성북구", "강북구", "도봉구", "노원구", "은평구", "서대문구", "마포구", "양천구", "강서구", "구로구", "금천구", "영등포구", "동작구", "관악구", "서초구", "강남구", "송파구", "강동구"],
                "부산광역시": ["중구", "서구", "동구", "영도구", "부산진구", "동래구", "남구", "북구", "해운대구", "사하구", "금정구", "강서구", "연제구", "수영구", "사상구", "기장군"],
                "대구광역시": ["중구", "동구", "서구", "남구", "북구", "수성구", "달서구", "군위군", "달성군"],
                "인천광역시": ["중구", "동구", "미추홀구", "연수구", "남동구", "부평구", "계양구", "서구", "강화군", "옹진군"],
                "광주광역시": ["동구", "서구", "남구", "북구", "광산구"],
                "대전광역시": ["동구", "중구", "서구", "유성구", "대덕구"],
                "울산광역시": ["중구", "남구", "동구", "북구", "울주군"],
                "세종특별자치시": [],
                "경기도": ["수원시", "성남시", "의정부시", "안양시", "부천시", "광명시", "평택시", "동두천시", "안산시", "고양시", "과천시", "구리시", "남양주시", "오산시", "시흥시", "군포시", "의왕시", "하남시", "용인시", "파주시", "이천시", "안성시", "김포시", "화성시", "광주시", "양주시", "포천시", "여주시", "연천군", "가평군", "양평군"],
                "강원특별자치도": ["춘천시", "원주시", "강릉시", "동해시", "태백시", "속초시", "삼척시", "홍천군", "횡성군", "영월군", "평창군", "정선군", "철원군", "화천군", "양구군", "인제군", "고성군", "양양군"],
                "충청북도": ["청주시", "충주시", "제천시", "보은군", "옥천군", "영동군", "증평군", "진천군", "괴산군", "음성군", "단양군"],
                "충청남도": ["천안시", "공주시", "보령시", "아산시", "서산시", "논산시", "계룡시", "당진시", "금산군", "부여군", "서천군", "청양군", "홍성군", "예산군", "태안군"],
                "전북특별자치도": ["전주시", "군산시", "익산시", "정읍시", "남원시", "김제시", "완주군", "진안군", "무주군", "장수군", "임실군", "순창군", "고창군", "부안군"],
                "전라남도": ["목포시", "여수시", "순천시", "나주시", "광양시", "담양군", "곡성군", "구례군", "고흥군", "보성군", "화순군", "장흥군", "강진군", "해남군", "영암군", "무안군", "함평군", "영광군", "장성군", "완도군", "진도군", "신안군"],
                "경상북도": ["포항시", "경주시", "김천시", "안동시", "구미시", "영주시", "영천시", "상주시", "문경시", "경산시", "의성군", "청송군", "영양군", "영덕군", "청도군", "고령군", "성주군", "칠곡군", "예천군", "봉화군", "울진군", "울릉군"],
                "경상남도": ["창원시", "진주시", "통영시", "사천시", "김해시", "밀양시", "거제시", "양산시", "의령군", "함안군", "창녕군", "고성군", "남해군", "하동군", "산청군", "함양군", "거창군", "합천군"],
                "제주특별자치도": ["제주시", "서귀포시"]
            };

            const provinceSelect = document.getElementById('province');
            const citySelect = document.getElementById('city');

            for (const province in addressData) {
                const option = document.createElement('option');
                option.value = province;
                option.textContent = province;
                provinceSelect.appendChild(option);
            }

            function updateCityDropdown() {
                const selectedProvince = provinceSelect.value;
                const cities = addressData[selectedProvince];

                citySelect.innerHTML = '';
                
                if (cities && cities.length > 0) {
                    cities.forEach(city => {
                        const option = document.createElement('option');
                        option.value = city;
                        option.textContent = city;
                        citySelect.appendChild(option);
                    });
                    citySelect.disabled = false;
                } else {
                    const option = document.createElement('option');
                    option.textContent = "시/군/구 정보 없음";
                    citySelect.appendChild(option);
                    citySelect.disabled = true;
                }
            }

            provinceSelect.addEventListener('change', updateCityDropdown);

            updateCityDropdown();
        });
    </script>
</body>
</html>