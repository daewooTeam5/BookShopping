<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 창</title>
<style>
    body {
        background-color: #f0f2f5;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
    }

    .signup-container {
        background-color: #fff;
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        width: 350px;
    }

    h2 {
        text-align: center;
        color: #333;
        margin-bottom: 20px;
    }

    input[type="text"], input[type="password"] {
        width: 100%;
        padding: 10px;
        margin-top: 8px;
        margin-bottom: 16px;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-size: 14px;
    }

    label {
        font-weight: bold;
        color: #555;
    }

    .checkbox-group {
        margin-bottom: 16px;
    }

    .checkbox-group input {
        margin-right: 6px;
    }

    button {
        width: 100%;
        padding: 12px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 16px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    button:hover {
        background-color: #0056b3;
    }

    .back-button {
        margin-top: 12px;
        background-color: #6c757d;
    }

    .back-button:hover {
        background-color: #5a6268;
    }
</style>
</head>
<body>

<div class="signup-container">
    <h2>회원가입</h2>
    <form action="#" method="post">
        <input type="text" name="userid" id="userid" placeholder="아이디를 입력해 주세요.">
        <input type="password" name="password" id="password" placeholder="비밀번호를 입력해 주세요.">
        <input type="text" name="name" id="name" placeholder="이름을 입력해 주세요.">
        
        <div class="checkbox-group">
            <p style="margin: 0 0 6px;">권한을 선택하세요:</p>
            <input type="checkbox" name="user_role" id="admin" value="admin">
            <label for="admin">관리자</label><br>
            <input type="checkbox" name="user_role" id="user" value="user">
            <label for="user">일반 사용자</label>
        </div>

        <button type="submit">회원가입 완료</button>
    </form>

    <form action="#" method="get">
        <button type="submit" class="back-button">뒤로가기</button>
    </form>
</div>

</body>
</html>
