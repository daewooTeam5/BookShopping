<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<header class="container narrow-container mt-3 border-bottom">
    <div class="d-flex justify-content-between align-items-center mb-4 position-relative" style="line-height:65px">
        <div class="position-absolute top-0 start-50 translate-middle-x">
            <a href="/book/list">
                <img src="/img/book.png" height="65px"/>
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty pageContext.request.userPrincipal}">
                <sec:authorize access="hasRole('ROLE_ADMIN')">
                    <a href="/book/admin/list" class="btn btn-outline-danger btn-sm me-3">관리자 페이지</a>
                </sec:authorize>
                <sec:authorize access="hasRole('ROLE_USER') or hasRole('ROLE_ADMIN')">
                    <div class="ti">USER</div>
                    <div class="me-3">
                        <a href="/user/my-page" class="btn btn-outline-success btn-sm me-2">내 정보</a>
                        <form action="/logout" method="post" style="display: inline-block">
                            <sec:csrfInput/>
                            <button type='submit' class="btn btn-secondary btn-sm">로그아웃</button>
                        </form>
                    </div>
                </sec:authorize>
                <sec:authorize access="hasRole('ROLE_GUEST')">
                    <div class="ti">GUEST</div>
                    <div class="me-3">
                        <a href="/user/my-page" class="btn btn-outline-success btn-sm me-2">장바구니</a>
                        <form action="/logout" method="post" style="display: inline-block">
                            <sec:csrfInput/>
                            <button type='submit' class="btn btn-secondary btn-sm">로그아웃</button>
                        </form>
                    </div>
                </sec:authorize>
            </c:when>
            <c:otherwise>
                <div></div>
                <div class="me-3">
                    <a href="/login" class="btn btn-outline-primary btn-sm me-2">로그인</a>
                    <a href="/register" class="btn btn-primary btn-sm">회원가입</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</header>
