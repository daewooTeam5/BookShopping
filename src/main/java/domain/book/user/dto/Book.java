package domain.book.user.dto;

import java.sql.Date;

import org.springframework.stereotype.Component;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Book {
	private Long id;
	private String title; 
	private String author; 
	private String publisher;
	private String image;
	private Integer price;
	private String genre;
	private Date published_at;
	private Integer page;
	private String introduction; 
	
	private Double avgRating;   // 평균 평점
    private Integer reviewCount; // 리뷰 개수
    private Integer salesCount;  // 판매량
    private Double score;
}