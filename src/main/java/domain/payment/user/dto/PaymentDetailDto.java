package domain.payment.user.dto;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PaymentDetailDto {
    private Long id;
    private String receiptId;
    private Date createdAt;
    private String title;
    private String image;
    private String genre;
    private String author;
    private Integer page;
    private Integer price;
    private String publisher;
    private int quantity;		 // 수량
}
