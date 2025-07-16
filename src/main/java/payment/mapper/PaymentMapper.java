// src/main/java/payment/mapper/PaymentMapper.java
package payment.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import payment.dto.Payment;
import payment.dto.PaymentDetailDto;

import java.util.List;


@Mapper
public interface PaymentMapper {

   
    @Insert("INSERT INTO payment (id, created_at, account_id, book_id) " +
            "VALUES (seq_payment_id.nextval, SYSDATE, #{accountId}, #{bookId})")
    int insertPayment(Payment payment);

    @Select("SELECT p.id, p.CREATED_AT as createdAt, b.title, b.IMAGE, b.GENRE, b.AUTHOR, b.PAGE, b.PRICE, b.PUBLISHER " +
            "FROM payment p JOIN BOOK b ON b.ID = p.BOOK_ID WHERE p.ACCOUNT_ID = #{accountId}")
    List<PaymentDetailDto> findPaymentDetailsByAccountId(Long accountId);

    @Select("SELECT SUM(b.PRICE) FROM payment p JOIN BOOK b ON b.ID = p.BOOK_ID WHERE p.ACCOUNT_ID = #{accountId}")
    Integer getTotalPaymentAmountByAccountId(Long accountId);
}
