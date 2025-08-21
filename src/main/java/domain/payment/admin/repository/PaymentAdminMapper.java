package domain.payment.admin.repository;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import domain.payment.admin.dto.PaymentRank;
import domain.payment.admin.entity.PaymentAdmin;

@Mapper
public interface PaymentAdminMapper {

    // 기존 전체 목록(정렬 포함) - 그대로 유지
    @Select(
        "SELECT " +
        "  p.id, " +
        "  p.created_at AS createdAt, " +
        "  a.name AS userName, " +
        "  a.user_id AS userId, " +
        "  b.id AS bookId, " +
        "  b.title AS bookTitle, " +
        "  b.author AS bookAuthor, " +
        "  b.publisher AS bookPublisher, " +
        "  b.genre AS bookGenre, " +
        "  b.price AS bookPrice, " +
        "  p.quantity " + // quantity 필드
        "FROM payment p " +
        "JOIN account a ON p.account_id = a.id " +
        "JOIN book b ON p.book_id = b.id " +
        "ORDER BY p.created_at DESC"
    )
    List<PaymentAdmin> findAll();

    // (XML 등으로 구현되어 있을 가능성) - 그대로 두기
    List<PaymentAdmin> search(
        @Param("userName") String userName,
        @Param("userId") String userId,
        @Param("bookTitle") String bookTitle,
        @Param("publisher") String publisher,
        @Param("genre") String genre,
        @Param("fromDate") String fromDate,
        @Param("toDate") String toDate,
        @Param("minPrice") Integer minPrice,
        @Param("maxPrice") Integer maxPrice
    );

    // =========================
    // KPI용 기존 통계 메서드들 (유지)
    // =========================

    // 전체 결제 "건수"를 수량 합계로 쓰고 있었다면 유지
    @Select("SELECT SUM(quantity) AS count FROM payment")
    int countAll();

    // 전체 결제 금액
    @Select("SELECT COALESCE(SUM(b.price * p.quantity), 0) FROM payment p JOIN book b ON p.book_id = b.id")
    int sumAll();

    // 도서별 결제 TOP 5
    List<PaymentRank> topBooks(@Param("limit") int limit);

    // 회원별 결제 TOP 5
    List<PaymentRank> topUsers(@Param("limit") int limit);

    // 카테고리별 요약
    @Select(
        "SELECT " +
        "  NVL(b.genre, '미지정') AS name, " +
        "  SUM(p.quantity)        AS count, " +
        "  SUM(b.price * p.quantity) AS totalPrice " +
        "FROM payment p " +
        "JOIN book b ON p.book_id = b.id " +
        "GROUP BY b.genre " +
        "ORDER BY count DESC"
    )
    List<PaymentRank> categorySummary();


    // =========================
    // 추가: 페이징 전용 메서드 (Oracle 11g)
    // =========================

    // 리스트 총 "행 수"(페이지네이션용)
    @Select(
        "SELECT COUNT(*) " +
        "FROM payment p " +
        "JOIN account a ON p.account_id = a.id " +
        "JOIN book b ON p.book_id = b.id"
    )
    int listCount();

    // ROW_NUMBER() 기반 페이징
    @Select(
        "SELECT * FROM (" +
        "  SELECT " +
        "    p.id, " +
        "    p.created_at AS createdAt, " +
        "    a.name AS userName, " +
        "    a.user_id AS userId, " +
        "    b.id AS bookId, " +
        "    b.title AS bookTitle, " +
        "    b.author AS bookAuthor, " +
        "    b.publisher AS bookPublisher, " +
        "    b.genre AS bookGenre, " +
        "    b.price AS bookPrice, " +
        "    p.quantity, " +
        "    ROW_NUMBER() OVER (ORDER BY p.created_at DESC) AS rn " +
        "  FROM payment p " +
        "  JOIN account a ON p.account_id = a.id " +
        "  JOIN book b ON p.book_id = b.id " +
        ") " +
        "WHERE rn BETWEEN #{startRow} AND #{endRow}"
    )
    List<PaymentAdmin> findPage(@Param("startRow") int startRow, @Param("endRow") int endRow);
}
