<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
    <title>영수증</title>
   
    <style>
        body {
            background-color: #e5e5e5;
            font-family: 'Noto Sans KR', sans-serif;
            max-width: 700px;
            margin: 0 auto;
            padding: 12px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .receipt-container {
            width: 100%;
            background-color: #fff;
            padding: 30px;
            border-radius: 2px;
        }

        .receipt-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th,td {
            border: 1px; 
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .receipt-table th {
            background-color: #f4f4f4;
            font-weight: 700;
            color: #555;
            width: 30%;
        }

        .receipt-table td {
            color: #333;
        }

        .receipt-main {
            font-size: 28px;
            font-weight: 700;
            color: #333;
            margin: 2px;
            text-align: center;
            border-bottom: 2px solid #333;
            padding-bottom: 10px;
        }

        .logo-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 10px;
            margin-bottom:8px;
        }

        .button-group {
            display: flex;
            justify-content: center;
            gap: 25px;
            margin-top: 16px;
        }

        .back-button, .printbtn {
            padding: 12px 25px;
            font-size: 16px;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 1px;
        }

        .back-button:hover, .printbtn:hover {
            background-color: #f0f0f0;
            border-color: #999;
        }
       
    </style>
</head>
<body>
    <div class="logo-wrapper">
        <img src="/img/book.png" height="65px" alt="로고" />
    </div>

    <div class="receipt-container">
        <h5 class="receipt-main">현금 영수증</h5>
        <table class="receipt-table">
           
            <tr>
                <th>결제일</th>
                <td>${fn:replace(createdAt, "T", " ")}</td><!-- T를 제외하고 출력 -->
            </tr>
            <tr>
                <th>책 제목</th>
                <td>${title}</td>
            </tr>
            <tr>
                <th>이미지</th>
                <td><img src="/img/${image}" alt="${title}" style="max-width:100px;"></td>
            </tr>
            <tr>
                <th>장르</th>
                <td>${genre}</td>
            </tr>
            <tr>
                <th>출판사</th>
                <td>${publisher}</td>
            </tr>
            <tr>
                <th>결제 금액</th><!-- 소수점 아래 자리 없애고 *로 수량만큼 곱셈 -->
                <td><fmt:formatNumber value="${price * quantity}" type="currency" currencySymbol="" maxFractionDigits="0" />원</td>
            </tr>
            <tr>
                <th>총 수량</th>
                <td>${quantity}</td>
            </tr>
          
        </table>
    </div>

    <div class="button-group">
        <button onclick="history.back()" class="back-button">뒤로가기</button>
        <button onclick="if(confirm('영수증을 출력하시겠습니까?')) { alert('영수증이 출력되었습니다.'); }" class="printbtn">출력</button>
    </div>
</body>
</html>