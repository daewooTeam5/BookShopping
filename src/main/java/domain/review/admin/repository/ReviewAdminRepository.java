package domain.review.admin.repository;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import domain.review.admin.dto.DailyReviewStat;
import domain.review.admin.dto.MonthlyReviewStat;
import domain.review.admin.dto.RatingCount;
import domain.review.admin.dto.TopRatedBook;
import domain.review.admin.dto.TopReviewDto;
import domain.review.admin.dto.WeekdayReviewCount;
import domain.review.admin.dto.YearlyReviewStat;
import domain.review.admin.entity.Review;

@Mapper
public interface ReviewAdminRepository {
	@Select("SELECT TO_CHAR(created_at, 'D') AS weekday, COUNT(*) AS reviewCount " +
	        "FROM review " +
	        "GROUP BY TO_CHAR(created_at, 'D') " +
	        "ORDER BY weekday")
	List<WeekdayReviewCount> findReviewCountByWeekday();
	
	@Select("SELECT ratings, COUNT(*) AS reviewCount " +
	        "FROM review " +
	        "GROUP BY ratings " +
	        "ORDER BY ratings")
	List<RatingCount> findReviewCountByRating();
	
	@Select("SELECT r.id, r.account_id, r.book_id, r.ratings, r.contents, b.title AS bookTitle " + "FROM review r "
			+ "JOIN book b ON r.book_id = b.id " + "ORDER BY r.id DESC")
	List<Review> findAll();

	@Select("SELECT r.id, r.account_id, r.book_id, r.ratings, r.contents, b.title AS bookTitle " + "FROM review r "
			+ "JOIN book b ON r.book_id = b.id " + "WHERE r.id = #{id}")
	Review findById(@Param("id") Long id);

	@Select("SELECT r.id, r.account_id, r.book_id, r.ratings, r.contents, b.title AS bookTitle " + "FROM review r "
			+ "JOIN book b ON r.book_id = b.id " + "WHERE r.contents LIKE '%' || #{like} || '%' " + "ORDER BY r.id DESC")
	List<Review> findByContentLike(@Param("like") String like);

	@Select("SELECT r.id, r.account_id, r.book_id, r.ratings, r.contents, b.title AS bookTitle " + "FROM review r "
			+ "JOIN book b ON r.book_id = b.id " + "WHERE r.account_id = #{accountId} " + "ORDER BY r.id DESC")
	List<Review> findByAccountId(@Param("accountId") Long accountId);

	@Select("SELECT r.id, r.account_id, r.book_id, r.ratings, r.contents, b.title AS bookTitle " + "FROM review r "
			+ "JOIN book b ON r.book_id = b.id " + "WHERE r.book_id = #{bookId} " + "ORDER BY r.id DESC")
	List<Review> findByBookId(@Param("bookId") Long bookId);

	@Select("SELECT r.id, r.account_id, r.book_id, r.ratings, r.contents, b.title AS bookTitle " + "FROM review r "
			+ "JOIN book b ON r.book_id = b.id " + "WHERE r.ratings = #{rating} " + "ORDER BY r.id DESC")
	List<Review> findByRating(@Param("rating") String rating);

	@Select("SELECT * FROM (" + "  SELECT b.id AS bookId," + "         b.title AS bookTitle,"
			+ "         ROUND(AVG(TO_NUMBER(r.ratings)), 2) AS avgRating," + "         COUNT(*) AS reviewCount "
			+ "  FROM review r " + "  JOIN book b ON r.book_id = b.id " + "  GROUP BY b.id, b.title "
			+ "  ORDER BY AVG(TO_NUMBER(r.ratings)) DESC, COUNT(*) DESC" + ") WHERE ROWNUM <= 5")
	List<TopRatedBook> findTop5ByAvgRating();

	@Delete("DELETE FROM review WHERE id = #{id}")
	int deleteById(@Param("id") Long id);
	
	@Select("SELECT a.id AS accountId, " +
	        "       a.name, " +
	        "       COUNT(r.id) AS reviewCount, " +
	        "       ROUND(AVG(r.ratings), 2) AS avgRating " +
	        "FROM review r " +
	        "JOIN account a ON r.account_id = a.id " +
	        "GROUP BY a.id, a.name " +
	        "ORDER BY reviewCount DESC " +
	        "FETCH FIRST 5 ROWS ONLY")
	List<TopReviewDto> findTop5ReviewersWithAccount();

	@Select("SELECT TO_CHAR(created_at, 'YYYY-MM-DD') as \"date\", ROUND(AVG(ratings), 2) as avgRating, COUNT(*) as reviewCount FROM review WHERE created_at >= TRUNC(SYSDATE) - 7 GROUP BY TO_CHAR(created_at, 'YYYY-MM-DD') ORDER BY \"date\" ASC")
	List<DailyReviewStat> findDailyStats();

	@Select("SELECT TO_CHAR(created_at, 'YYYY-MM') as \"month\", ROUND(AVG(ratings), 2) as avgRating, COUNT(*) as reviewCount FROM review WHERE TO_CHAR(created_at, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY') GROUP BY TO_CHAR(created_at, 'YYYY-MM') ORDER BY \"month\" ASC")
	List<MonthlyReviewStat> findMonthlyStats();

	@Select("SELECT TO_CHAR(created_at, 'YYYY') as \"year\", ROUND(AVG(ratings), 2) as avgRating, COUNT(*) as reviewCount FROM review GROUP BY TO_CHAR(created_at, 'YYYY') ORDER BY \"year\" ASC")
	List<YearlyReviewStat> findYearlyStats();
}
