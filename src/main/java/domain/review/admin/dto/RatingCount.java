package domain.review.admin.dto;

import lombok.Data;

@Data
public class RatingCount {
	 private int ratings;       // 별점 (1~5)
	    private int reviewCount;
}
