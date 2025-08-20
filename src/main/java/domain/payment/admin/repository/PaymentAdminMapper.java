package domain.payment.admin.repository;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import domain.payment.admin.dto.PaymentRank;
import domain.payment.admin.entity.PaymentAdmin;

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
            "b.genre AS bookGenre, " +
            "b.price AS bookPrice, " +
            "p.quantity " + // quantity 필드 추가
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
                               @Param("genre") String genre,
                               @Param("fromDate") String fromDate,
                               @Param("toDate") String toDate,
                               @Param("minPrice") Integer minPrice,
                               @Param("maxPrice") Integer maxPrice);
    
    // 전체 결제 건수
    @Select("SELECT sum(quantity) as count FROM payment")
    int countAll();

    // 전체 결제 금액
    @Select("SELECT COALESCE(SUM(b.price*p.quantity), 0) FROM payment p JOIN book b ON p.book_id = b.id")
    int sumAll();

    // 도서별 결제 TOP 5
    List<PaymentRank> topBooks(@Param("limit") int limit);

    // 회원별 결제 TOP 5
    List<PaymentRank> topUsers(@Param("limit") int limit);
    
    // 카테고리별 요약
    @Select("SELECT " +
            "NVL(b.genre, '미지정') AS name, " +
            "SUM(p.quantity)        AS count, " +
            "SUM(b.price * p.quantity) AS totalPrice " +
            "FROM payment p " +
            "JOIN book b ON p.book_id = b.id " +
            "GROUP BY b.genre " +
            "ORDER BY count DESC"
    )
    List<PaymentRank> categorySummary();
}
