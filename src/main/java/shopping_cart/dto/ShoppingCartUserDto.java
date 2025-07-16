package shopping_cart.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class ShoppingCartUserDto {
	private Long id;
	private String title; 
	private String author; 
	private String publisher;
	private String image;
	private Integer price;
	private String genre;
	private Date publishedAt;
	private Integer page;
	private String introduction; 
	private Integer quantity;

}
