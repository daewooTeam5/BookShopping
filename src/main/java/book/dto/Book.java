package book.dto;

import java.sql.Date;

import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class Book {
	private int id;
	private String title; 
	private String author; 
	private String publisher; 
	private int price;
	private String genre;
	private Date publisherd_at;
	private int page;
	private String introduction; 
}