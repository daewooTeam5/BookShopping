package domain.review.user.repository;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import domain.review.user.dto.ReviewStatistic;
import domain.review.user.entity.Review;
import domain.review.user.entity.ReviewUserDto;

@Mapper
public interface ReviewRepository {
	@Insert("INSERT INTO review (ratings,contents,account_id,book_id) values(#{ratings},#{contents},#{accountId},#{bookId})")
	int save(Review review);
	
	@Select("SELECT r.ID AS id, " +
	        "r.CREATED_AT AS created_at, " +
	        "a.NAME AS writerName, " +
	        "a.ID AS writerId, " +
	        "r.CONTENTS AS contents, " +
	        "r.RATINGS AS ratings " +
	        "FROM REVIEW r " +
	        "JOIN ACCOUNT a ON r.ACCOUNT_ID = a.ID " +
	        "JOIN BOOK b ON b.ID = r.BOOK_ID " +
	        "WHERE r.BOOK_ID = #{bookId} " +
	        "ORDER BY r.CREATED_AT DESC")
	List<ReviewUserDto> findAllUserJoinWriter(Long bookId);
	
	@Select("SELECT avg(r.RATINGS) AS ratingAvg ,count(r.ACCOUNT_ID) AS totalRatings "
			+ "FROM REVIEW r "
			+ "JOIN BOOK b "
			+ "ON r.BOOK_ID =b.ID "
			+ "GROUP BY b.ID "
			+ "HAVING r.BOOK_ID =#{bookId}")
	ReviewStatistic getBookReviewStatistic(Long bookId);
	
}
