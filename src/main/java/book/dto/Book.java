package book.dto;

import java.sql.Date;

import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class Book {
	private Long id;
	private String title; 
	private String author; 
	private String publisher; 
	private Integer price;
	private String genre;
	private Date published_at;
	private Integer page;
	private String introduction; 
}