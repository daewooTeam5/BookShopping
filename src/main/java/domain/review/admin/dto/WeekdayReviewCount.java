package domain.review.admin.dto;

import lombok.Data;

@Data
public class WeekdayReviewCount {
    private int weekday;       // 1=일요일, 2=월요일...
    private int reviewCount;
    // getter/setter
}