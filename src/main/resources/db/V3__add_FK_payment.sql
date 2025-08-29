ALTER TABLE payment
    ADD address_id NUMBER(19);

ALTER TABLE payment
    ADD CONSTRAINT fk_payment_address
        FOREIGN KEY (address_id)
        REFERENCES address (id);
