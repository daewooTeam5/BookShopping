package domain.review.admin.entity;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data             
@NoArgsConstructor  
public class Review {
    private Long id;
    private Long accountId; // account_id
    private Long bookId;    // book_id
    private String rating;
    private String contents;
    private String bookTitle;
}
