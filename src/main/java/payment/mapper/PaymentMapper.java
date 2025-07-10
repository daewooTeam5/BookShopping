// src/main/java/payment/mapper/PaymentMapper.java
package payment.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import payment.dto.Payment;


@Mapper
public interface PaymentMapper {

   
    @Insert("INSERT INTO payment (id, created_at, account_id, book_id) " +
            "VALUES (seq_payment_id.nextval, SYSDATE, #{accountId}, #{bookId})")
    int insertPayment(Payment payment);
}
