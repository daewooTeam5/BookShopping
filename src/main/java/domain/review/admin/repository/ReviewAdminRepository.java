package domain.review.admin.repository;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import domain.review.admin.dto.TopRatedBook;
import domain.review.admin.entity.Review;

@Mapper
public interface ReviewAdminRepository {

	@Select("SELECT r.id, r.account_id, r.book_id, r.ratings, r.contents, b.title AS bookTitle " + "FROM review r "
			+ "JOIN book b ON r.book_id = b.id " + "ORDER BY r.id DESC")
	List<Review> findAll();

	@Select("SELECT r.id, r.account_id, r.book_id, r.ratings, r.contents, b.title AS bookTitle " + "FROM review r "
			+ "JOIN book b ON r.book_id = b.id " + "WHERE r.id = #{id}")
	Review findById(@Param("id") Long id);

	@Select("SELECT r.id, r.account_id, r.book_id, r.ratings, r.contents, b.title AS bookTitle " + "FROM review r "
			+ "JOIN book b ON r.book_id = b.id " + "WHERE r.ratings LIKE #{like} " + "ORDER BY r.id DESC")
	List<Review> findByContentLike(@Param("like") String like);

	@Select("SELECT r.id, r.account_id, r.book_id, r.ratings, r.contents, b.title AS bookTitle " + "FROM review r "
			+ "JOIN book b ON r.book_id = b.id " + "WHERE r.account_id = #{accountId} " + "ORDER BY r.id DESC")
	List<Review> findByAccountId(@Param("accountId") Long accountId);

	@Select("SELECT r.id, r.account_id, r.book_id, r.rating, r.contents, b.title AS bookTitle " + "FROM review r "
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
}
