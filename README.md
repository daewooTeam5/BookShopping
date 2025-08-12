
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
