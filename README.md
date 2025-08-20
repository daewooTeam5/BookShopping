# BookShopping Project
# Git Branch 전략 가이드 
#### 브랜치 전략 : Git Flow
[참고:우아한 형제들 기술 블로그](https://techblog.woowahan.com/2553/) 
<img width="905" height="380" alt="image" src="https://github.com/user-attachments/assets/7992cb7d-87c2-427f-ac99-9e3596900621" />

 1. 원격 데브 브랜치 pull
    - 로컬 저장소에 dev 브랜치가 있을시  
      `git checkout dev`  
      `git pull origin dev`
    - 로컬 저장소에 dev 브랜치가 없을시  
      `git fetch origin`
      `git checkout -b dev origin/dev`
2. 작업하려는기능 Project 에 Issue 로 추가
   - title 은 브랜치명
     - 브랜치명은 중복이 안되게 브랜치명 뒤에 숫자를 기입 ex) feature/payment2, feature/payment3...
   - description 에는 구현해야되는 기능 작성
3. 로컬 저장소에 feature branch 생성
   `git checkout -b feature/브랜치명`
4. 작업 완료시 브랜치 push
   - 최초 push 할시
     `git push --set-upstream origin feature/브랜치명`
   - 이후 push 할시
     `git push`
5. 최종 기능 구현시 pull Request + dev 브랜치로 머지 
   - pull Requst 를 날릴시 해당 브랜치는 폐기
   - 해당 기능에 추가 작업 필요시 브랜치명 뒤에 숫자를 올려서 1. 부터 작업
  
# API 명세서 

 # BookAdmin (/book/admin)
   * GET /list: 도서 목록 조회 (검색 기능 포함)
   * GET /writeform: 도서 등록 폼으로 이동
   * POST /write: 도서 등록
   * GET /updateform: 도서 수정 폼으로 이동
   * POST /update: 도서 정보 수정
   * POST /delete: 도서 삭제


  # Book (/book)
   * GET /list: 도서 목록 조회 (검색, 장르별 필터링, 페이징 기능 포함)
   * GET /view: 도서 상세 정보 조회


  # PaymentAdmin (/payment/admin)
   * GET /list: 결제 내역 목록 조회 (다양한 조건으로 검색 가능)

  # Payment (/payment)
   * POST /buyNow: 즉시 구매
   * POST /buyFromCart: 장바구니의 상품 구매 (선택 또는 전체)


  # ShoppingCart (/cart)
   * POST /: 장바구니에 상품 추가
   * POST /delete/{id}: 장바구니에서 상품 삭제
   * GET /my/{id}: 특정 사용자의 장바구니 목록 조회
   * POST /update-quantity: 장바구니 상품 수량 변경


  # User
   * GET /: 메인 페이지 (도서 목록으로 리다이렉트)
   * GET /user/login: 로그인 페이지로 리다이렉트
   * GET /user/my-page: 마이페이지 (사용자 정보, 장바구니, 결제 내역 조회)
   * GET /login: 로그인 페이지
   * GET /register: 회원가입 폼
   * POST /register: 회원가입 처리
