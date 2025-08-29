package domain.book.admin.dto;

import domain.book.admin.entity.Book;
import lombok.Data;

import domain.payment.user.dto.Payment;

import java.util.List;

@Data
public class BookDetailDto {
    private Book book;
    private BookSalesDto sales;
    private List<RatingCountDto> ratingDistribution;
    private List<Payment> payments;
}
