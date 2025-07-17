// src/main/java/payment/mapper/PaymentMapper.java
package domain.payment.user.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import domain.payment.user.dto.Payment;
import domain.payment.user.dto.PaymentDetailDto;


@Mapper
public interface PaymentMapper {

   
    @Insert("INSERT INTO payment (id, created_at, account_id, book_id, quantity) " +
            "VALUES (seq_payment_id.nextval, SYSDATE, #{accountId}, #{bookId}, #{quantity})")
    int insertPayment(Payment payment);

    @Select("SELECT p.id, p.CREATED_AT as createdAt, b.title, b.IMAGE, b.GENRE, b.AUTHOR, b.PAGE, b.PRICE, b.PUBLISHER, p.quantity " +
            "FROM payment p JOIN BOOK b ON b.ID = p.BOOK_ID WHERE p.ACCOUNT_ID = #{accountId} order by p.created_at desc")
    List<PaymentDetailDto> findPaymentDetailsByAccountId(Long accountId);

    @Select("SELECT SUM(b.PRICE * p.quantity) FROM payment p JOIN BOOK b ON b.ID = p.BOOK_ID WHERE p.ACCOUNT_ID = #{accountId}")
    Integer getTotalPaymentAmountByAccountId(Long accountId);
}
