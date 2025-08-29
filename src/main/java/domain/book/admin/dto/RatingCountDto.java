package domain.book.admin.dto;

import lombok.Data;

@Data
public class RatingCountDto {
    private Integer ratings;
    private Long count;
}
