<%@ page pageEncoding="UTF-8" %>
<!-- Category Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light mb-4">
    <div class="container-fluid">
        <a class="navbar-brand" href="/book/list">전체보기</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="/book/list?genre=경제경영">경제경영</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/book/list?genre=만화">만화</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/book/list?genre=외국어">외국어</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/book/list?genre=자기계발">자기계발</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/book/list?genre=컴퓨터/IT">컴퓨터/IT</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
