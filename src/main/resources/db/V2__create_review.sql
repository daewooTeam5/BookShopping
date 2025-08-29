CREATE TABLE review (
    id NUMBER PRIMARY KEY,
    created_at DATE,
    account_id NUMBER NOT NULL,
    book_id NUMBER NOT NULL,
    ratings NUMBER,
    contents VARCHAR2(1000),
    CONSTRAINT fk_review_account FOREIGN KEY (account_id) REFERENCES account(id) ON DELETE CASCADE,
    CONSTRAINT fk_review_book FOREIGN KEY (book_id) REFERENCES book(id) ON DELETE CASCADE
);

CREATE SEQUENCE seq_review_id
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER trg_review_id
BEFORE INSERT ON review
FOR EACH ROW
BEGIN
    :NEW.id := seq_review_id.NEXTVAL;
END;
/
