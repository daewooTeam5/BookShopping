package domain.book.admin.repository;

import domain.book.admin.entity.Book;
import domain.book.admin.dto.BookSalesDto;
import domain.book.admin.dto.RatingCountDto;
import domain.payment.user.dto.Payment;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BookAdminMapper {
    Book findBookById(@Param("id") Long id);
    BookSalesDto findBookSalesStats(@Param("bookId") Long bookId);
    List<RatingCountDto> findBookRatingDistribution(@Param("bookId") Long bookId);
    List<Payment> findPaymentsByBookId(@Param("bookId") Long bookId);
}
