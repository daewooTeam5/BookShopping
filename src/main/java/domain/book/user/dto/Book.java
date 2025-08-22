package domain.book.user.dto;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@JsonIgnoreProperties(ignoreUnknown = true)
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
	@JsonIgnore
	private Date publishedAt;
	@JsonIgnore
	private Date published_at;

	private Integer page;
	private String introduction; 
	
	private Double avgRating;   // 평균 평점
    private Integer reviewCount; // 리뷰 개수
    private Integer salesCount;  // 판매량
    private Double score;
}