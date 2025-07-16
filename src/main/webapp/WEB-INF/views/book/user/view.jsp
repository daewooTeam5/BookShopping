<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${book.title} - 상세 정보</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5" style="max-width: 800px;">
        <h2 class="mb-4">${book.title}</h2>
        <hr>
        <div class="row">
            <div class="col-md-4">
                <img src="/img/${book.image}" class="img-fluid">
            </div>
            <div class="col-md-8">
                <p><strong>저자:</strong> ${book.author}</p>
                <p><strong>출판사:</strong> ${book.publisher}</p>
                <p><strong>출판일:</strong> ${book.published_at}</p>
                <p><strong>장르:</strong> ${book.genre}</p>
                <p><strong>가격:</strong> <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true" /> 원</p>
                <hr>
                
               
                <form action="/payment/buyNow" method="POST" class="d-inline">
                    <input type="hidden" name="bookId" value="${book.id}">
                    <sec:csrfInput /> 
                    <button type="submit" class="btn btn-primary">바로 구매</button>
                </form>

                <form action="/cart" method="POST" class="d-inline" onsubmit="return confirm('장바구니에 추가하시겠습니까?');">
                    <input type="hidden" name="bookId" value="${book.id}">
                    <input type="hidden" name="quantity" value="1">
                    <sec:csrfInput /> 
                    <button type="submit" class="btn btn-secondary">장바구니</button>
                </form>
                
                
            </div>
        </div>
        <div class="mt-4">
            <h4>책 소개</h4>
            <p>${book.introduction}</p>
        </div>
        <div class="mt-3">
             <a href="/book/list" class="btn btn-outline-dark">목록으로</a>
        </div>
    </div>
</body>
</html>