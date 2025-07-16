<%@ page isErrorPage="true" language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>에러 발생!</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex justify-content-center align-items-center" style="height: 100vh;">

<div class="card shadow-sm" style="width: 30rem;">
    <div class="card-header bg-danger text-white text-center">
        <h4>😵 예외가 발생했어요!</h4>
    </div>
    <div class="card-body">
        <p class="card-text"><strong>에러 메시지:</strong></p>
        <div class="alert alert-warning" role="alert">
            <%= exception != null ? exception.getMessage() : "알 수 없는 오류입니다." %>
        </div>

        <div class="text-center">
            <button class="btn btn-primary" onclick="history.back()">🔙 뒤로가기</button>
        </div>
    </div>
    <div class="card-footer text-muted text-center">
        문제가 지속되면 관리자에게 문의해주세요 🙇‍♂️
    </div>
</div>

<!-- Bootstrap JS (선택, 안 넣어도 돼) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
