<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script src="https://kit.fontawesome.com/6cbdf73c90.js" crossorigin="anonymous"></script>

<div class="container narrow-container text-end" style="margin-top: 10px; margin-bottom: -10px; font-size: 0.8em;">
    <sec:authorize access="isAnonymous()">
        <a href="/login" class="text-decoration-none text-secondary me-2">로그인</a>
        <span class="text-secondary">|</span>
        <a href="/register" class="text-decoration-none text-secondary ms-2">회원가입</a>
    </sec:authorize>
    <sec:authorize access="isAuthenticated()">
        <form action="/logout" method="post" style="display: inline;">
            <sec:csrfInput/>
            <button type="submit" class="btn btn-link text-secondary text-decoration-none p-0" style="font-size: 1em;">로그아웃</button>
        </form>
    </sec:authorize>
</div>

<header class="container narrow-container mt-3 border-bottom">
    <div class="d-flex justify-content-between align-items-center mb-4 position-relative" style="line-height:65px">
        <!-- 중앙 로고 -->
        <div class="position-absolute top-0 start-50 translate-middle-x">
            <a href="/book/main">
                <img src="/img/book.png" height="65px"/>
            </a>
        </div>

        <!-- 왼쪽: 관리자 페이지 -->
        <div>
            <sec:authorize access="hasRole('ROLE_ADMIN')">
                <a href="/book/admin/list" class="btn btn-outline-danger btn-sm">관리자 페이지</a>
            </sec:authorize>
        </div>

        <!-- 오른쪽: 아이콘 -->
        <div class="me-3 d-flex align-items-center">
            <a href="#" id="cart-popover" class="btn btn-outline-secondary btn-sm me-2" data-bs-toggle="popover" title="장바구니">
                <i class="fas fa-shopping-cart"></i>
            </a>
            <sec:authorize access="isAuthenticated()">
                 <a href="/user/my-page" class="btn btn-outline-secondary btn-sm">
                    <i class="fas fa-user"></i>
                </a>
            </sec:authorize>
            <sec:authorize access="isAnonymous()">
                 <a href="/login" class="btn btn-outline-secondary btn-sm">
                    <i class="fas fa-user"></i>
                </a>
            </sec:authorize>
        </div>
    </div>
</header>
<script>
document.addEventListener('DOMContentLoaded', function () {
    const cartIcon = document.getElementById('cart-popover');
    let cartPopover = new bootstrap.Popover(cartIcon, {
        html: true,
        placement: 'bottom',
        trigger: 'manual',
        content: '로딩 중...',
        customClass: 'cart-popover-width' // Add custom class for width
    });
    let isPopoverVisible = false;

    cartIcon.addEventListener('click', function (e) {
        e.preventDefault();

        if (isPopoverVisible) {
            cartPopover.hide();
            isPopoverVisible = false;
            return;
        }

        let isLoggedIn = false;
        <sec:authorize access="isAuthenticated()">
            isLoggedIn = true;
        </sec:authorize>

        if (isLoggedIn) {
            fetch('/cart/api/my-cart')
                .then(response => response.json())
                .then(cartItems => {
                    let content = '';
                    if (cartItems && cartItems.length > 0) {
                        content += '<ul class="list-group list-group-flush">';
                        cartItems.forEach(function(item) {
                            content +=
                                '<li class="list-group-item d-flex align-items-center py-2">' +
                                    '<img width="50" src="' + item.image + '" class="me-2" style="width: 20px; height: auto; object-fit: cover;">' +
                                    '<div class="flex-grow-1" style="font-size: 0.8em;">' + item.title + '</div>' +
                                    '<span class="badge bg-primary rounded-pill ms-2">' + item.quantity + '</span>' +
                                '</li>';
                        });
                        content += '</ul>';
                    } else {
                        content = '<div class="p-2">장바구니가 비었습니다.</div>';
                    }
                    cartPopover.setContent({ '.popover-body': content });
                    cartPopover.show();
                    isPopoverVisible = true;
                });
        } else {
            const cartCookie = getCookie('cart');
            if (cartCookie) {
                try {
                    const decodedCart = decodeURIComponent(cartCookie);
                    const cartItems = JSON.parse(decodedCart);
                    const bookIds = cartItems.map(function(item) { return item.bookId; });

                    if (bookIds.length > 0) {
                        fetch('/book/api/books-by-ids?ids=' + bookIds.join(','))
                            .then(response => response.json())
                            .then(books => {
                                let content = '';
                                if (books && books.length > 0) {
                                    const quantityMap = new Map(cartItems.map(function(item) { return [item.bookId, item.quantity]; }));
                                    content += '<ul class="list-group list-group-flush">';
                                    books.forEach(function(book) {
                                        content +=
                                            '<li class="list-group-item d-flex align-items-center py-2">' +
                                                '<img width="50" src="' + book.image + '" class="me-2" style="width: 20px; height: auto; object-fit: cover;">' +
                                                '<div class="flex-grow-1" style="font-size: 0.8em;">' + book.title + '</div>' +
                                                '<span class="badge bg-primary rounded-pill ms-2">' + quantityMap.get(book.id) + '</span>' +
                                            '</li>';
                                    });
                                    content += '</ul>';
                                } else {
                                    content = '<div class="p-2">장바구니 정보를 불러올 수 없습니다.</div>';
                                }
                                cartPopover.setContent({ '.popover-body': content });
                                cartPopover.show();
                                isPopoverVisible = true;
                            });
                    } else {
                         cartPopover.setContent({ '.popover-body': '<div class="p-2">장바구니가 비었습니다.</div>' });
                         cartPopover.show();
                         isPopoverVisible = true;
                    }
                } catch (e) {
                    console.error('쿠키 파싱 오류:', e);
                    cartPopover.setContent({ '.popover-body': '<div class="p-2">장바구니 정보를 불러오는데 실패했습니다.</div>' });
                    cartPopover.show();
                    isPopoverVisible = true;
                }
            } else {
                cartPopover.setContent({ '.popover-body': '<div class="p-2">장바구니가 비었습니다.</div>' });
                cartPopover.show();
                isPopoverVisible = true;
            }
        }
    });

    function getCookie(name) {
        const value = '; ' + document.cookie;
        const parts = value.split('; ' + name + '=');
        if (parts.length === 2) return parts.pop().split(';').shift();
    }
    
    // Close popover when clicking outside
    document.addEventListener('click', function (e) {
        if (isPopoverVisible && !cartIcon.contains(e.target) && !document.querySelector('.popover').contains(e.target)) {
            cartPopover.hide();
            isPopoverVisible = false;
        }
    });
});
</script>
<style>
    .cart-popover-width {
        min-width: 300px; /* Adjust width as needed */
    }
    .popover-body {
        padding: 0;
    }
</style>
