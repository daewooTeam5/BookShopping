<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>메인 페이지</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
.book-card {
    width: 150px;
    text-align: center;
    position: relative;
    background-color: white;
    border-radius: 5px;
    overflow: hidden;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    transition: transform 0.2s;
}
.book-card:hover {
    transform: translateY(-5px);
}
.book-card img {
    width: 100%;
    height: 200px;
    object-fit: cover;
}
.book-card .title {
    margin-top: 8px;
    font-size: 14px;
    font-weight: bold;
    color: #333;
}
.book-rank {
    position: absolute;
    top: 5px;
    left: 5px;
    background-color: rgba(0,0,0,0.6);
    color: white;
    font-weight: bold;
    font-size: 16px;
    width: 28px;
    height: 28px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 10;
}
.rank-1 { background-color: gold; color: black; }
.rank-2 { background-color: silver; color: black; }
.rank-3 { background-color: #cd7f32; color: black; }

.section-title {
    font-size: 20px;
    font-weight: bold;
    margin: 40px 0 20px; /* 섹션 사이 간격 증가 */
}

/* 인기도서 캐러셀 */
#popularCarousel {
    position: relative;
    padding: 0 50px;
    margin-bottom: 60px; /* 아래 여백 추가 */
}
#popularCarousel .carousel-control-prev,
#popularCarousel .carousel-control-next {
    width: 40px;
    top: 50%;
    transform: translateY(-50%);
    z-index: 5;
}

/* 광고 슬라이더 */
#adCarousel {
    border-radius: 15px;
    overflow: hidden;
    margin-bottom: 60px; /* 아래 여백 추가 */
}
#adCarousel img {
    height: 400px;
    object-fit: cover;
    border-radius: 15px;
}

/* 베스트셀러 전체 회색 배경 */
.best-seller-section {
    background-color: #f5f5f5;
    padding: 30px 15px;
    border-radius: 10px;
    margin-bottom: 50px; /* 아래 여백 증가 */
}
.best-seller-section .book-card {
    margin: 0 auto;
}

/* 공통 섹션 마진 */
.popular-section {
    margin-left: 55px;
}

.allight{
text-align:center;
font-size:22px;
border:none;
font-weight: bold;
margin-bottom:25px;
line-height: 15px;

}
.carousel-control-prev-icon,
.carousel-control-next-icon {
  filter: invert(1); /* 흰색 → 검정으로 뒤집기 */
}
</style>
</head>
<body class="container mt-4">

<%@ include file="/WEB-INF/views/book/user/header.jsp" %>

<%@ include file="/WEB-INF/views/book/user/navigation.jsp" %>

<!-- 광고 슬라이더 -->
<div id="adCarousel" class="carousel slide rounded overflow-hidden" 
     data-bs-ride="carousel" data-bs-interval="3000">
    <div class="carousel-inner rounded overflow-hidden">
        <div class="carousel-item active">
            <img src="https://contents.kyobobook.co.kr/advrcntr/IMAC/creatives/2025/08/13/66873/NEWBOOK.png" 
                 class="d-block w-100" 
                 alt="광고1">
            <div class="carousel-caption text-end" style="bottom:10px; right:10px;">
                <span class="badge bg-dark text-white">광고1</span>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://contents.kyobobook.co.kr/advrcntr/IMAC/creatives/2025/08/14/69392/0728.png" 
                 class="d-block w-100" 
                 alt="광고2">
            <div class="carousel-caption text-end" style="bottom:10px; right:10px;">
                <span class="badge bg-dark text-white">광고2</span>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://contents.kyobobook.co.kr/pmtn/2025/event/d91b358263114198a3063cebabda817f.jpg" 
                 class="d-block w-100" 
                 alt="광고3">
            <div class="carousel-caption text-end" style="bottom:10px; right:10px;">
                <span class="badge bg-dark text-white">광고3</span>
            </div>
        </div>
    </div>
</div>

<!-- 인기도서 -->
<h2 class="section-title popular-section">인기도서 TOP 10</h2>
<div id="popularCarousel" class="carousel slide" data-bs-interval="false">
    <div class="carousel-inner">
        <c:forEach var="book" items="${popularBooks}" varStatus="status">
            <c:if test="${status.index % 5 == 0}">
                <div class="carousel-item ${status.index == 0 ? 'active' : ''}">
                    <div class="d-flex justify-content-between">
            </c:if>

            <div class="book-card">
                <a href="/book/view?id=${book.id}">
                    <img src="${book.image}" alt="${book.title}">
                </a>
                <div class="title">${book.title}</div>
            </div>

            <c:if test="${(status.index + 1) % 5 == 0 || status.last}">
                    </div>
                </div>
            </c:if>
        </c:forEach>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#popularCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
        <span class="visually-hidden">Previous</span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#popularCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
        <span class="visually-hidden">Next</span>
    </button>
</div>

<!-- 베스트셀러 -->
<h2 class="section-title popular-section">베스트셀러 TOP 10</h2>
<div class="best-seller-section">
    <div class="row row-cols-2 row-cols-md-5 g-3 text-center">
        <c:forEach var="book" items="${bestSellers}" varStatus="status">
            <div class="col d-flex justify-content-center">
                <div class="book-card position-relative">
                    <div class="book-rank ${status.index == 0 ? 'rank-1' : (status.index == 1 ? 'rank-2' : (status.index == 2 ? 'rank-3' : ''))}">
                        ${status.index + 1}
                    </div>
                    <a href="/book/view?id=${book.id}">
                        <img src="${book.image}" alt="${book.title}">
                    </a>
                    <div class="title">${book.title}</div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
<div class="allight"> © 2025 Daewoo Team:5 All Rights Reserved.</div>
</html>
