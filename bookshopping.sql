-- 1. 책정보 테이블
CREATE TABLE book (
    id            NUMBER(19) PRIMARY KEY,
    title         VARCHAR2(255),
    author        VARCHAR2(255),
    publisher     VARCHAR2(255),
    image         VARCHAR2(255),
    price         NUMBER(19),
    published_at  DATE,
    genre         VARCHAR2(255),
    page          NUMBER(19),
    introduction  VARCHAR2(2000)
);

-- 2. 유저 테이블
CREATE TABLE account (
    id          NUMBER(19) PRIMARY KEY,
    uid         VARCHAR2(255),
    password    VARCHAR2(255),
    name        VARCHAR2(255),
    user_role   VARCHAR2(255),
    created_at  DATE
);

-- 3. 장바구니 테이블
CREATE TABLE shopping_cart (
    id          NUMBER(19) PRIMARY KEY,
    created_at  DATE,
    quantity    NUMBER(5),
    book_id     NUMBER(19),
    account_id  NUMBER(19),
    CONSTRAINT fk_cart_book FOREIGN KEY (book_id) REFERENCES book(id),
    CONSTRAINT fk_cart_account FOREIGN KEY (account_id) REFERENCES account(id)
);

-- 4. 결제내역 테이블
CREATE TABLE payment (
    id          NUMBER(19) PRIMARY KEY,
    created_at  DATE,
    account_id  NUMBER(19),
    book_id     NUMBER(19),
    CONSTRAINT fk_payment_account FOREIGN KEY (account_id) REFERENCES account(id),
    CONSTRAINT fk_payment_book FOREIGN KEY (book_id) REFERENCES book(id)
);
# -- 책정보 테이블 시퀀스 & 트리거
CREATE SEQUENCE seq_book_id START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_book_id
BEFORE INSERT ON book
FOR EACH ROW
BEGIN
    :NEW.id := seq_book_id.NEXTVAL;
END;
/

-- 유저 테이블 시퀀스 & 트리거
CREATE SEQUENCE seq_account_id START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_account_id
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    :NEW.id := seq_account_id.NEXTVAL;
END;
/
-- 장바구니 테이블 시퀀스 & 트리거
CREATE SEQUENCE seq_cart_id START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_cart_id
BEFORE INSERT ON shopping_cart
FOR EACH ROW
BEGIN
    :NEW.id := seq_cart_id.NEXTVAL;
END;
/

-- 결제내역 테이블 시퀀스 & 트리거
CREATE SEQUENCE seq_payment_id START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_payment_id
BEFORE INSERT ON payment
FOR EACH ROW
BEGIN
    :NEW.id := seq_payment_id.NEXTVAL;
END;
/
