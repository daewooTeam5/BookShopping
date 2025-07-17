package domain.shopping_cart.dto;


import domain.book.user.dto.Book;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ShoppingCartDto {
	private Long accountId;
	private Book bookInfo;
}
