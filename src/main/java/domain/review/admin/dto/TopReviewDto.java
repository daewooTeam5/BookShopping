package domain.review.admin.dto;

import lombok.Data;

@Data
public class TopReviewDto {
    private Long accountId;
    private String name;
    private int reviewCount;
    private double avgRating;
}
