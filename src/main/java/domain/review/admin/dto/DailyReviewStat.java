package domain.review.admin.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DailyReviewStat {
    private String date;
    private double avgRating;
    private int reviewCount;
}
