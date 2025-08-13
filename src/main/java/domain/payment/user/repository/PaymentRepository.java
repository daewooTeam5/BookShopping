package domain.payment.user.repository;

import domain.payment.user.dto.Payment;
import domain.payment.user.dto.PaymentDetailDto;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface PaymentRepository {

    @Insert("INSERT INTO payment (created_at, account_id, book_id, quantity, receipt_id, address_id) " +
            "VALUES (SYSDATE, #{accountId}, #{bookId}, #{quantity}, #{receiptId}, #{addressId})")
    int insertPayment(Payment payment);

    @Select("SELECT p.id, p.CREATED_AT as createdAt, b.title, b.IMAGE, b.GENRE, b.AUTHOR, b.PAGE, b.PRICE, b.PUBLISHER, p.quantity " +
            "FROM payment p JOIN BOOK b ON b.ID = p.BOOK_ID WHERE p.ACCOUNT_ID = #{accountId} order by p.created_at desc")
    List<PaymentDetailDto> findPaymentDetailsByAccountId(Long accountId);

    @Select("SELECT SUM(b.PRICE * p.quantity) FROM payment p JOIN BOOK b ON b.ID = p.BOOK_ID WHERE p.ACCOUNT_ID = #{accountId}")
    Integer getTotalPaymentAmountByAccountId(Long accountId);
}
