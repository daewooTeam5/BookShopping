package domain.review.admin.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MonthlyReviewStat {
    private String month;
    private double avgRating;
    private int reviewCount;
}
