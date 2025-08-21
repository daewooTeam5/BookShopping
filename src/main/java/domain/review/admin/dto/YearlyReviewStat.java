package domain.review.admin.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class YearlyReviewStat {
    private String year;
    private double avgRating;
    private int reviewCount;
}
