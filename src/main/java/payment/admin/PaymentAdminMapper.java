package payment.admin;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import java.util.List;

@Mapper
public interface PaymentAdminMapper {

    @Select("SELECT " +
            "p.id, " +
            "p.created_at AS createdAt, " +
            "a.name AS userName, " +
            "a.user_id AS userId, " +
            "b.id AS bookId, " +
            "b.title AS bookTitle, " +
            "b.author AS bookAuthor, " +
            "b.publisher AS bookPublisher, " +
            "b.price AS bookPrice " +
            "FROM payment p " +
            "JOIN account a ON p.account_id = a.id " +
            "JOIN book b ON p.book_id = b.id " +
            "ORDER BY p.created_at DESC"
    )
    List<AdminPayment> findAll();
}