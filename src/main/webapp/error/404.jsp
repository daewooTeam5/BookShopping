<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - 페이지를 찾을 수 없습니다</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #f8f9fa;
            color: #343a40;
        }
        .error-container {
            text-align: center;
            padding: 40px;
            border-radius: 8px;
            background-color: #ffffff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h1 {
            font-size: 5rem;
            color: #dc3545;
            margin-bottom: 20px;
        }
        p {
            font-size: 1.2rem;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>404</h1>
        <p>죄송합니다! 요청하신 페이지를 찾을 수 없습니다.</p>
        <a href="/book/main" class="btn btn-primary">홈페이지로 이동</a>
    </div>
</body>
</html>