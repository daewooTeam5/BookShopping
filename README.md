# BookShopping Project
### 배포 주소: http://3.37.0.250/book/main  
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

## 📖 Book

| Method | URL | Controller | Description | Parameters |
| --- | --- | --- | --- | --- |
| GET | `/book/main` | BookController | 메인 페이지 (인기 도서, 베스트셀러) | - |
| GET | `/book/list` | BookController | 도서 목록 (검색, 장르 필터, 페이징) | `requestPage`, `searchField`, `keyword`, `genre` |
| GET | `/book/view` | BookController | 도서 상세 정보 | `id` (도서 ID) |

## 👤 User

| Method | URL | Controller | Description | Parameters |
| --- | --- | --- | --- | --- |
| GET | `/` | UserController | 메인 페이지로 리다이렉트 | - |
| GET | `/login` | UserController | 로그인 페이지 | - |
| GET | `/user/login` | UserController | 로그인 페이지로 리다이렉트 | - |
| GET | `/register` | UserController | 회원가입 페이지 | - |
| POST | `/register` | UserController | 회원가입 처리 | `UserRegisterForm` |
| GET | `/guest` | UserController | 게스트로 로그인 | - |
| GET | `/user/my-page` | UserController | 마이페이지 (주소, 장바구니, 주문내역) | `Authentication` |
| POST | `/user/receipt` | UserController | 영수증 상세 보기 | `receiptId`, `createdAt`, 등 영수증 정보 |

## 🛒 Shopping Cart

| Method | URL | Controller | Description | Parameters |
| --- | --- | --- | --- | --- |
| POST | `/cart` | ShoppingCartController | 장바구니에 상품 추가 | `Authentication`, `ShoppingCart` |
| POST | `/cart/delete/{id}` | ShoppingCartController | 장바구니 상품 삭제 | `id` (장바구니 ID) |
| POST | `/cart/update-quantity` | ShoppingCartController | 장바구니 상품 수량 변경 | `id`, `quantity` |
| GET | `/cart/my/{id}` | ShoppingCartController | (API) 사용자의 장바구니 목록 조회 | `id` (사용자 ID) |

## 💳 Payment

| Method | URL | Controller | Description | Parameters |
| --- | --- | --- | --- | --- |
| POST | `/payment/addressForm` | PaymentController | 바로 구매 시, 주소 선택 폼 | `bookId`, `quantity`, `Authentication` |
| POST | `/payment/addressFormFromCart` | PaymentController | 장바구니 구매 시, 주소 선택 폼 | `cartIds`, `Authentication` |
| POST | `/payment/processPayment` | PaymentController | 기존 주소로 결제 처리 | `purchaseType`, `bookId`, `quantity`, `cartIds`, `addressId`, `Authentication` |
| POST | `/payment/processPaymentWithNewAddress` | PaymentController | 새 주소로 결제 처리 | `purchaseType`, `bookId`, `quantity`, `cartIds`, `province`, `city`, `street`, `zipcode`, `Authentication` |

## 📝 Review

| Method | URL | Controller | Description | Parameters |
| --- | --- | --- | --- | --- |
| POST | `/review` | ReviewController | 리뷰 작성 | `Authentication`, `CreateReviewDto` |

## 🏠 Address

| Method | URL | Controller | Description | Parameters |
| --- | --- | --- | --- | --- |
| POST | `/address/add` | AddressController | 주소 추가 | `Address`, `Authentication` |

## ⚙️ Admin - Book

| Method | URL | Controller | Description | Parameters |
| --- | --- | --- | --- | --- |
| GET | `/book/admin/list` | BookAdminController | 도서 목록 (검색, 페이징) | `searchField`, `keyword`, `showDeleted`, `page` |
| GET | `/book/admin/writeform` | BookAdminController | 도서 등록 폼 | - |
| POST | `/book/admin/write` | BookAdminController | 도서 등록 | `Book`, `imageFile` |
| GET | `/book/admin/updateform` | BookAdminController | 도서 수정 폼 | `id` (도서 ID) |
| POST | `/book/admin/update` | BookAdminController | 도서 정보 수정 | `Book`, `imageFile`, `originalImage` |
| POST | `/book/admin/delete` | BookAdminController | 도서 삭제 | `id` (도서 ID) |

## ⚙️ Admin - Review

| Method | URL | Controller | Description | Parameters |
| --- | --- | --- | --- | --- |
| GET | `/review/admin/list` | ReviewAdminController | 리뷰 목록 (검색, 통계) | `searchField`, `keyword` |
| POST | `/review/admin/delete` | ReviewAdminController | 리뷰 삭제 | `id` (리뷰 ID) |