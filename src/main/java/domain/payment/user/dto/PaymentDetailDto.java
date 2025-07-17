package domain.payment.user.dto;

import java.time.LocalDateTime;

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
    private LocalDateTime createdAt;
    private String title;
    private String image;
    private String genre;
    private String author;
    private Integer page;
    private Integer price;
    private String publisher;
}
