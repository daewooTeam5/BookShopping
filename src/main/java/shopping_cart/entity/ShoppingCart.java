package shopping_cart.entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ShoppingCart {
    private Long id;
    private Date createdAt;
    private Integer quantity;
    private Long bookId;
    private Long accountId;
}
