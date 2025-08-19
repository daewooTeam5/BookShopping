package domain.review.admin.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class TopRatedBook {
    private Long bookId;
    private String bookTitle;
    private Double avgRating;   // 소수점 평균
    private Integer reviewCount;
}
