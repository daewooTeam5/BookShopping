package payment.admin;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectProvider;

import java.util.List;
import java.util.Map;

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
    List<PaymentAdmin> findAll();
    
    List<PaymentAdmin> search(@Param("userName") String userName,
                               @Param("userId") String userId,
                               @Param("bookTitle") String bookTitle,
                               @Param("publisher") String publisher,
                               @Param("fromDate") String fromDate,
                               @Param("toDate") String toDate,
                               @Param("minPrice") Integer minPrice,
                               @Param("maxPrice") Integer maxPrice);
}