package domain.payment.admin.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class PublisherSalesDto {
    private String publisher;
    private BigDecimal totalSales;
    private String period; // "daily", "monthly", "yearly"
}
