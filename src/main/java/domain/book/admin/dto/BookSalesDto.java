package domain.book.admin.dto;

import lombok.Data;

@Data
public class BookSalesDto {
    private Long totalPurchaseCount;
    private Long totalSalesAmount;
}
