package domain.payment.admin.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class AuthorSalesDto {
    private String author;
    private BigDecimal totalSales;
    private String period; // "daily", "monthly", "yearly"
}
